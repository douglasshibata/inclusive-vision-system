package session

import (
	"sync"
	"time"
)

type SessionInfo struct {
	SessionID   string
	UserID      string
	DeviceType  string
	ConnectedAt time.Time
	LastPingAt  time.Time
}

type SessionManager struct {
	mu       sync.RWMutex
	sessions map[string]*SessionInfo
}

func NewSessionManager() *SessionManager {
	return &SessionManager{
		sessions: make(map[string]*SessionInfo),
	}
}

func (s *SessionManager) Register(sessionID, userID string) *SessionInfo {
	s.mu.Lock()
	defer s.mu.Unlock()

	now := time.Now()
	info := &SessionInfo{
		SessionID:   sessionID,
		UserID:      userID,
		ConnectedAt: now,
		LastPingAt:  now,
	}
	s.sessions[sessionID] = info
	return info
}

func (s *SessionManager) Touch(sessionID string) {
	s.mu.Lock()
	defer s.mu.Unlock()

	if sess, ok := s.sessions[sessionID]; ok {
		sess.LastPingAt = time.Now()
	}
}

func (s *SessionManager) Remove(sessionID string) {
	s.mu.Lock()
	defer s.mu.Unlock()
	delete(s.sessions, sessionID)
}

func (s *SessionManager) ActiveCount() int {
	s.mu.RLock()
	defer s.mu.RUnlock()
	return len(s.sessions)
}
