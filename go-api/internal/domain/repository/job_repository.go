package repository

import (
	"context"

	"github.com/airlance/api/internal/domain/entity"
)

type JobRepository interface {
	Create(ctx context.Context, job *entity.Job) error
	GetByUUID(ctx context.Context, uuid string) (*entity.Job, error)
	UpdateStatus(ctx context.Context, uuid string, status entity.JobStatus) error
}
