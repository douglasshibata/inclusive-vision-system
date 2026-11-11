package main

import (
	"fmt"
	"io"
	"log"
	"net"
	"os"

	"google.golang.org/grpc"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"

	"services/gateway/internal/auth"
	"services/gateway/internal/session"
	"services/gateway/internal/telemetry"
	pb "services/gateway/pkg/api/v1"
)

type SpatialServer struct {
	pb.UnimplementedSpatialIntelligenceServiceServer
	auth     *auth.Authenticator
	sessions *session.SessionManager
}

func NewSpatialServer() *SpatialServer {
	return &SpatialServer{
		auth:     auth.NewAuthenticator(),
		sessions: session.NewSessionManager(),
	}
}

func (s *SpatialServer) StreamTelemetry(stream pb.SpatialIntelligenceService_StreamTelemetryServer) error {
	ctx := stream.Context()

	userID, err := s.auth.ValidateContext(ctx)
	if err != nil {
		return status.Errorf(codes.Unauthenticated, "auth validation failed: %v", err)
	}

	var sessionID string

	for {
		select {
		case <-ctx.Done():
			if sessionID != "" {
				s.sessions.Remove(sessionID)
			}
			return ctx.Err()
		default:
			packet, err := stream.Recv()
			if err == io.EOF {
				if sessionID != "" {
					s.sessions.Remove(sessionID)
				}
				return nil
			}
			if err != nil {
				if sessionID != "" {
					s.sessions.Remove(sessionID)
				}
				return status.Errorf(codes.Unknown, "falha no recebimento do stream: %v", err)
			}

			if sessionID == "" && packet.SessionId != "" {
				sessionID = packet.SessionId
				s.sessions.Register(sessionID, userID)
			} else if sessionID != "" {
				s.sessions.Touch(sessionID)
			}

			// Pipeline não-bloqueante: Roteia mensagens conforme a severidade
			feedback := s.ProcessPacket(packet)

			isCritical := feedback != nil && feedback.Severity == pb.SpatialFeedback_CRITICAL
			telemetry.DefaultCollector.RecordPacket(len(packet.String()), isCritical)

			if feedback != nil {
				if err := stream.Send(feedback); err != nil {
					return status.Errorf(codes.Unavailable, "falha ao enviar feedback ao cliente: %v", err)
				}
			}
		}
	}
}

func (s *SpatialServer) ProcessPacket(packet *pb.ClientPacket) *pb.SpatialFeedback {
	if packet == nil {
		return nil
	}

	// Lógica de gateway: Detecta falhas de colisão no payload de sensores
	if sensors := packet.GetSensors(); sensors != nil {
		if sensors.DistanceToGroundM > 1.2 && sensors.IsWalking {
			// Resposta emergencial de borda sem aguardar o LLM
			return &pb.SpatialFeedback{
				Severity:      pb.SpatialFeedback_CRITICAL,
				VerbalMessage: "Atenção: Queda de nível à frente.",
				HapticCue: &pb.HapticPattern{
					PulseCount: 3,
					DurationMs: 150,
					Intensity:  100,
				},
				SoundVector: &pb.SpatialCoordinate{
					AzimuthDeg: 0,
					DistanceM:  sensors.DistanceToGroundM,
				},
			}
		}
	}

	// Processa comandos ou intenções de voz caso especificado
	if intent := packet.GetIntent(); intent != nil {
		return &pb.SpatialFeedback{
			Severity:      pb.SpatialFeedback_INFO,
			VerbalMessage: fmt.Sprintf("Recebida requisição contextual: %s", intent.QueryText),
			HapticCue: &pb.HapticPattern{
				PulseCount: 1,
				DurationMs: 100,
				Intensity:  50,
			},
			SoundVector: &pb.SpatialCoordinate{
				AzimuthDeg: 0,
				DistanceM:  1.0,
			},
		}
	}

	return nil
}

func RunGateway(port string) error {
	lis, err := net.Listen("tcp", port)
	if err != nil {
		return fmt.Errorf("falha ao inicializar socket do Gateway: %w", err)
	}

	grpcServer := grpc.NewServer()
	server := NewSpatialServer()
	pb.RegisterSpatialIntelligenceServiceServer(grpcServer, server)

	log.Printf("🚀 IVS Spatial Gateway ativo na porta %s (gRPC)", port)
	return grpcServer.Serve(lis)
}

func main() {
	port := os.Getenv("PORT")
	if port == "" {
		port = ":50051"
	} else if port[0] != ':' {
		port = ":" + port
	}

	if err := RunGateway(port); err != nil {
		log.Fatalf("Falha crítica no gRPC Server: %v", err)
	}
}
