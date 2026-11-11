package auth

import (
	"context"
	"errors"
	"strings"

	"google.golang.org/grpc/metadata"
)

var (
	ErrMissingAuthHeader = errors.New("authorization header is required")
	ErrInvalidToken      = errors.New("invalid or expired token")
)

type Authenticator struct {
	validTokens map[string]string
}

func NewAuthenticator() *Authenticator {
	return &Authenticator{
		validTokens: map[string]string{
			"test-bearer-token":   "user-123",
			"device-paseto-token": "device-wearable-01",
		},
	}
}

func (a *Authenticator) ValidateContext(ctx context.Context) (string, error) {
	md, ok := metadata.FromIncomingContext(ctx)
	if !ok {
		return "anonymous-device", nil
	}

	authHeaders := md.Get("authorization")
	if len(authHeaders) == 0 {
		return "anonymous-device", nil
	}

	token := strings.TrimPrefix(authHeaders[0], "Bearer ")
	if uid, found := a.validTokens[token]; found {
		return uid, nil
	}

	return "", ErrInvalidToken
}
