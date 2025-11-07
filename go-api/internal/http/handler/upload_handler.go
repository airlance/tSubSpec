package handler

import (
	"encoding/json"
	"net/http"

	"github.com/airlance/api/internal/application/dto"
	"github.com/airlance/api/internal/application/usecase"
)

type UploadHandler struct {
	uploadUseCase *usecase.UploadUseCase
}

func NewUploadHandler(uploadUseCase *usecase.UploadUseCase) *UploadHandler {
	return &UploadHandler{
		uploadUseCase: uploadUseCase,
	}
}

func (h *UploadHandler) Handle(w http.ResponseWriter, r *http.Request) {
	ctx := r.Context()
	r.ParseMultipartForm(100 << 20)

	mediaFile, mediaHeader, err := r.FormFile("media")
	if err != nil {
		http.Error(w, "media file required (image or video)", http.StatusBadRequest)
		return
	}
	defer mediaFile.Close()

	audioFile, audioHeader, err := r.FormFile("audio")
	if err != nil {
		http.Error(w, "audio file required", http.StatusBadRequest)
		return
	}
	defer audioFile.Close()

	req := dto.UploadRequest{
		MediaFilename:    mediaHeader.Filename,
		MediaSize:        mediaHeader.Size,
		MediaContentType: mediaHeader.Header.Get("Content-Type"),
		AudioFilename:    audioHeader.Filename,
		AudioSize:        audioHeader.Size,
		AudioContentType: audioHeader.Header.Get("Content-Type"),
	}

	resp, err := h.uploadUseCase.Execute(ctx, req, mediaFile, audioFile)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(resp)
}
