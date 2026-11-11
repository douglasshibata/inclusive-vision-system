package telemetry

import (
	"log"
	"sync/atomic"
	"time"
)

type MetricsCollector struct {
	totalPacketsReceived uint64
	totalCriticalAlerts  uint64
	totalBytesReceived   uint64
}

var DefaultCollector = &MetricsCollector{}

func (m *MetricsCollector) RecordPacket(sizeBytes int, isCritical bool) {
	atomic.AddUint64(&m.totalPacketsReceived, 1)
	atomic.AddUint64(&m.totalBytesReceived, uint64(sizeBytes))
	if isCritical {
		atomic.AddUint64(&m.totalCriticalAlerts, 1)
	}
}

func (m *MetricsCollector) LogStatsPeriodically(interval time.Duration) {
	go func() {
		ticker := time.NewTicker(interval)
		defer ticker.Stop()
		for range ticker.C {
			log.Printf("[IVS Telemetry] Packets: %d | Critical Alerts: %d | Bytes: %d",
				atomic.LoadUint64(&m.totalPacketsReceived),
				atomic.LoadUint64(&m.totalCriticalAlerts),
				atomic.LoadUint64(&m.totalBytesReceived))
		}
	}()
}
