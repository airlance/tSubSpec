package handler

import (
	"fmt"
	"io"
	"net/http"

	"github.com/airlance/api/internal/application/usecase"
	"github.com/go-chi/chi/v5"
)

type DownloadHandler struct {
	downloadUseCase *usecase.DownloadUseCase
}

func NewDownloadHandler(downloadUseCase *usecase.DownloadUseCase) *DownloadHandler {
	return &DownloadHandler{
		downloadUseCase: downloadUseCase,
	}
}

func (h *DownloadHandler) Handle(w http.ResponseWriter, r *http.Request) {
	ctx := r.Context()
	jobUUID := chi.URLParam(r, "uuid")

	result, err := h.downloadUseCase.Execute(ctx, jobUUID)
	if err != nil {
		http.Error(w, err.Error(), http.StatusNotFound)
		return
	}
	defer result.Reader.Close()

	w.Header().Set("Content-Type", result.ContentType)
	w.Header().Set("Content-Length", fmt.Sprintf("%d", result.Size))
	w.Header().Set("Content-Disposition", fmt.Sprintf("attachment; filename=%s", result.Filename))

	io.Copy(w, result.Reader)
}
