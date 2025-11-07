package handler

import (
	"encoding/json"
	"net/http"

	"github.com/airlance/api/internal/application/usecase"
	"github.com/go-chi/chi/v5"
)

type StatusHandler struct {
	statusUseCase *usecase.StatusUseCase
}

func NewStatusHandler(statusUseCase *usecase.StatusUseCase) *StatusHandler {
	return &StatusHandler{
		statusUseCase: statusUseCase,
	}
}

func (h *StatusHandler) Handle(w http.ResponseWriter, r *http.Request) {
	ctx := r.Context()
	jobUUID := chi.URLParam(r, "uuid")

	resp, err := h.statusUseCase.Execute(ctx, jobUUID)
	if err != nil {
		http.Error(w, err.Error(), http.StatusNotFound)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(resp)
}
