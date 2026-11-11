package main

import (
	"context"
	"testing"

	"google.golang.org/grpc/metadata"

	pb "services/gateway/pkg/api/v1"
)

func TestProcessPacket_EmergencyObstacle(t *testing.T) {
	server := NewSpatialServer()

	packet := &pb.ClientPacket{
		SessionId:   "session-test-01",
		TimestampMs: 123456789,
		Payload: &pb.ClientPacket_Sensors{
			Sensors: &pb.SensorTelemetry{
				DistanceToGroundM: 1.5,
				IsWalking:         true,
				CompassHeading:    90.0,
			},
		},
	}

	feedback := server.ProcessPacket(packet)
	if feedback == nil {
		t.Fatalf("expected feedback for emergency ground distance, got nil")
	}

	if feedback.Severity != pb.SpatialFeedback_CRITICAL {
		t.Errorf("expected CRITICAL severity, got %v", feedback.Severity)
	}

	if feedback.HapticCue == nil || feedback.HapticCue.PulseCount != 3 {
		t.Errorf("expected 3 haptic pulses, got %+v", feedback.HapticCue)
	}

	if feedback.SoundVector == nil || feedback.SoundVector.DistanceM != 1.5 {
		t.Errorf("expected sound vector distance 1.5, got %+v", feedback.SoundVector)
	}
}

func TestProcessPacket_NormalWalking(t *testing.T) {
	server := NewSpatialServer()

	packet := &pb.ClientPacket{
		SessionId:   "session-test-02",
		TimestampMs: 123456790,
		Payload: &pb.ClientPacket_Sensors{
			Sensors: &pb.SensorTelemetry{
				DistanceToGroundM: 0.8,
				IsWalking:         true,
				CompassHeading:    0.0,
			},
		},
	}

	feedback := server.ProcessPacket(packet)
	if feedback != nil {
		t.Errorf("expected nil feedback for safe sensor telemetry, got %+v", feedback)
	}
}

func TestProcessPacket_VoiceIntent(t *testing.T) {
	server := NewSpatialServer()

	packet := &pb.ClientPacket{
		SessionId:   "session-test-03",
		TimestampMs: 123456791,
		Payload: &pb.ClientPacket_Intent{
			Intent: &pb.UserVoiceIntent{
				QueryText:      "Onde está a porta?",
				TargetLanguage: "pt-BR",
			},
		},
	}

	feedback := server.ProcessPacket(packet)
	if feedback == nil {
		t.Fatalf("expected feedback for voice intent, got nil")
	}

	if feedback.Severity != pb.SpatialFeedback_INFO {
		t.Errorf("expected INFO severity, got %v", feedback.Severity)
	}
}

func TestAuthValidation(t *testing.T) {
	server := NewSpatialServer()

	ctx := context.Background()
	uid, err := server.auth.ValidateContext(ctx)
	if err != nil || uid == "" {
		t.Errorf("expected anonymous user, got err=%v, uid=%s", err, uid)
	}

	md := metadata.New(map[string]string{
		"authorization": "Bearer test-bearer-token",
	})
	ctxWithAuth := metadata.NewIncomingContext(context.Background(), md)
	uid, err = server.auth.ValidateContext(ctxWithAuth)
	if err != nil || uid != "user-123" {
		t.Errorf("expected user-123, got err=%v, uid=%s", err, uid)
	}

	mdBad := metadata.New(map[string]string{
		"authorization": "Bearer invalid-token",
	})
	ctxBad := metadata.NewIncomingContext(context.Background(), mdBad)
	_, err = server.auth.ValidateContext(ctxBad)
	if err == nil {
		t.Errorf("expected error for invalid token, got nil")
	}
}
