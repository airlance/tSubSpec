package usecase

import (
	"context"
	"fmt"
	"io"
	"path/filepath"

	"github.com/airlance/api/internal/application/dto"
	"github.com/airlance/api/internal/domain/entity"
	"github.com/airlance/api/internal/domain/repository"
	"github.com/airlance/api/internal/domain/service"
	"github.com/google/uuid"
	"github.com/sirupsen/logrus"
)

type UploadUseCase struct {
	jobRepo       repository.JobRepository
	storageRepo   repository.StorageRepository
	queueRepo     repository.QueueRepository
	validationSvc *service.ValidationService
	logger        *logrus.Logger
}

func NewUploadUseCase(
	jobRepo repository.JobRepository,
	storageRepo repository.StorageRepository,
	queueRepo repository.QueueRepository,
	validationSvc *service.ValidationService,
	logger *logrus.Logger,
) *UploadUseCase {
	return &UploadUseCase{
		jobRepo:       jobRepo,
		storageRepo:   storageRepo,
		queueRepo:     queueRepo,
		validationSvc: validationSvc,
		logger:        logger,
	}
}

func (uc *UploadUseCase) Execute(ctx context.Context, req dto.UploadRequest, mediaReader, audioReader io.Reader) (*dto.UploadResponse, error) {
	if err := uc.validationSvc.ValidateMediaFile(req.MediaFilename); err != nil {
		return nil, fmt.Errorf("validation failed: %w", err)
	}

	if err := uc.validationSvc.ValidateAudioFile(req.AudioFilename); err != nil {
		return nil, fmt.Errorf("validation failed: %w", err)
	}

	jobID := uuid.New().String()

	job := &entity.Job{
		UUID:      jobID,
		MediaPath: filepath.Join(jobID, req.MediaFilename),
		AudioPath: filepath.Join(jobID, req.AudioFilename),
		Status:    entity.JobStatusPending,
	}

	log := uc.logger.WithFields(logrus.Fields{
		"job_uuid": jobID,
		"media":    req.MediaFilename,
		"audio":    req.AudioFilename,
	})

	if err := uc.storageRepo.Upload(ctx, mediaReader, job.MediaPath, req.MediaSize, req.MediaContentType); err != nil {
		log.WithError(err).Error("Failed to upload media")
		return nil, fmt.Errorf("failed to upload media: %w", err)
	}

	if err := uc.storageRepo.Upload(ctx, audioReader, job.AudioPath, req.AudioSize, req.AudioContentType); err != nil {
		log.WithError(err).Error("Failed to upload audio")
		return nil, fmt.Errorf("failed to upload audio: %w", err)
	}

	if err := uc.jobRepo.Create(ctx, job); err != nil {
		log.WithError(err).Error("Failed to create job")
		return nil, fmt.Errorf("failed to create job: %w", err)
	}

	if err := uc.queueRepo.PublishJob(ctx, job); err != nil {
		log.WithError(err).Error("Failed to publish job")
		return nil, fmt.Errorf("failed to publish job: %w", err)
	}

	log.Info("Job created and published")

	return &dto.UploadResponse{UUID: jobID}, nil
}
