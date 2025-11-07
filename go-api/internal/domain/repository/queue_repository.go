package repository

import (
	"context"

	"github.com/airlance/api/internal/domain/entity"
)

type QueueRepository interface {
	PublishJob(ctx context.Context, job *entity.Job) error
	Close() error
}
