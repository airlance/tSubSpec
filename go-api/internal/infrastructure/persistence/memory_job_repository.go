package persistence

import (
	"context"
	"fmt"
	"sync"
	"time"

	"github.com/airlance/api/internal/domain/entity"
	"github.com/airlance/api/internal/domain/repository"
)

type MemoryJobRepository struct {
	mu   sync.RWMutex
	jobs map[string]*entity.Job
}

func NewMemoryJobRepository() repository.JobRepository {
	return &MemoryJobRepository{
		jobs: make(map[string]*entity.Job),
	}
}

func (r *MemoryJobRepository) Create(ctx context.Context, job *entity.Job) error {
	r.mu.Lock()
	defer r.mu.Unlock()

	now := time.Now()
	job.CreatedAt = now
	job.UpdatedAt = now

	r.jobs[job.UUID] = job
	return nil
}

func (r *MemoryJobRepository) GetByUUID(ctx context.Context, uuid string) (*entity.Job, error) {
	r.mu.RLock()
	defer r.mu.RUnlock()

	job, exists := r.jobs[uuid]
	if !exists {
		return nil, fmt.Errorf("job not found")
	}

	return job, nil
}

func (r *MemoryJobRepository) UpdateStatus(ctx context.Context, uuid string, status entity.JobStatus) error {
	r.mu.Lock()
	defer r.mu.Unlock()

	job, exists := r.jobs[uuid]
	if !exists {
		return fmt.Errorf("job not found")
	}

	job.Status = status
	job.UpdatedAt = time.Now()

	return nil
}
