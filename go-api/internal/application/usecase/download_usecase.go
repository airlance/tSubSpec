package usecase

import (
	"context"
	"fmt"
	"io"
	"path/filepath"

	"github.com/airlance/api/internal/domain/repository"
)

type DownloadUseCase struct {
	storageRepo repository.StorageRepository
}

func NewDownloadUseCase(storageRepo repository.StorageRepository) *DownloadUseCase {
	return &DownloadUseCase{
		storageRepo: storageRepo,
	}
}

type DownloadResult struct {
	Reader      io.ReadCloser
	Size        int64
	ContentType string
	Filename    string
}

func (uc *DownloadUseCase) Execute(ctx context.Context, jobUUID string) (*DownloadResult, error) {
	outputPath := filepath.Join(jobUUID, "output.mp4")

	reader, size, contentType, err := uc.storageRepo.Download(ctx, outputPath)
	if err != nil {
		return nil, fmt.Errorf("file not found: %w", err)
	}

	return &DownloadResult{
		Reader:      reader,
		Size:        size,
		ContentType: contentType,
		Filename:    "output.mp4",
	}, nil
}
