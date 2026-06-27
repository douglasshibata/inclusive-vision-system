package main

import (
	"encoding/json"
	"log"
	"net/http"
)

type Response struct {
	Status  string `json:"status"`
	Version string `json:"version"`
	Message string `json:"message"`
}

func main() {
	mux := http.NewServeMux()

	// Health check and root
	mux.HandleFunc("/", healthCheck)
	mux.HandleFunc("/health", healthCheck)

	// Navigation endpoints
	mux.HandleFunc("/api/v1/nav/route", getRoute)

	// Auth and User endpoints (Mock)
	mux.HandleFunc("/api/v1/user/settings", getSettings)

	log.Println("Inclusive Vision System Backend starting on :8080")
	err := http.ListenAndServe(":8080", mux)
	if err != nil {
		log.Fatal(err)
	}
}

func healthCheck(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(Response{
		Status:  "OK",
		Version: "1.0.0",
		Message: "IVS API Gateway is running",
	})
}

func getRoute(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	// Mock GeoJSON response
	json.NewEncoder(w).Encode(map[string]interface{}{
		"type": "FeatureCollection",
		"features": []interface{}{},
		"meta": map[string]string{
			"instruction": "Continue straight for 50 meters",
		},
	})
}

func getSettings(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(map[string]interface{}{
		"high_contrast": true,
		"speech_rate":   1.2,
		"braille_mode":  true,
	})
}
