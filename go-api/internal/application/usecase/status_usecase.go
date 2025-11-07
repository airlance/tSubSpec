package usecase

import (
	"context"
	"fmt"
	"path/filepath"

	"github.com/airlance/api/internal/application/dto"
	"github.com/airlance/api/internal/domain/entity"
	"github.com/airlance/api/internal/domain/repository"
)

type StatusUseCase struct {
	jobRepo     repository.JobRepository
	storageRepo repository.StorageRepository
	baseURL     string
}

func NewStatusUseCase(jobRepo repository.JobRepository, storageRepo repository.StorageRepository, baseURL string) *StatusUseCase {
	return &StatusUseCase{
		jobRepo:     jobRepo,
		storageRepo: storageRepo,
		baseURL:     baseURL,
	}
}

func (uc *StatusUseCase) Execute(ctx context.Context, jobUUID string) (*dto.StatusResponse, error) {
	job, err := uc.jobRepo.GetByUUID(ctx, jobUUID)
	if err != nil {
		return nil, fmt.Errorf("job not found: %w", err)
	}

	outputPath := filepath.Join(jobUUID, "output.mp4")
	exists, err := uc.storageRepo.Exists(ctx, outputPath)
	if err != nil {
		return nil, fmt.Errorf("failed to check output: %w", err)
	}

	resp := &dto.StatusResponse{
		UUID:   jobUUID,
		Status: string(job.Status),
	}

	if exists {
		resp.Status = string(entity.JobStatusReady)
		resp.URL = fmt.Sprintf("%s/download/%s/output.mp4", uc.baseURL, jobUUID)
	}

	return resp, nil
}
