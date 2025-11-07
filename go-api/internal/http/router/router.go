package router

import (
	"encoding/json"
	"net/http"

	handler2 "github.com/airlance/api/internal/http/handler"
	"github.com/go-chi/chi/v5"
	"github.com/go-chi/chi/v5/middleware"
)

type Router struct {
	uploadHandler   *handler2.UploadHandler
	statusHandler   *handler2.StatusHandler
	downloadHandler *handler2.DownloadHandler
}

func NewRouter(
	uploadHandler *handler2.UploadHandler,
	statusHandler *handler2.StatusHandler,
	downloadHandler *handler2.DownloadHandler,
) *Router {
	return &Router{
		uploadHandler:   uploadHandler,
		statusHandler:   statusHandler,
		downloadHandler: downloadHandler,
	}
}

func (rt *Router) Setup() http.Handler {
	r := chi.NewRouter()

	r.Use(middleware.Logger)
	r.Use(middleware.Recoverer)
	r.Use(middleware.RealIP)
	r.Use(middleware.RequestID)

	r.Get("/", rt.healthCheck)
	r.Post("/upload", rt.uploadHandler.Handle)
	r.Get("/status/{uuid}", rt.statusHandler.Handle)
	r.Get("/download/{uuid}/output.mp4", rt.downloadHandler.Handle)

	return r
}

func (rt *Router) healthCheck(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	resp := map[string]string{
		"status":   "ok",
		"version":  "2.0",
		"features": "images, videos",
	}
	w.WriteHeader(http.StatusOK)
	json.NewEncoder(w).Encode(resp)
}
