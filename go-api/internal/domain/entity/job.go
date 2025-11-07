package entity

import "time"

type Job struct {
	UUID      string
	MediaPath string
	AudioPath string
	Status    JobStatus
	CreatedAt time.Time
	UpdatedAt time.Time
}

type JobStatus string

const (
	JobStatusPending    JobStatus = "pending"
	JobStatusProcessing JobStatus = "processing"
	JobStatusReady      JobStatus = "ready"
	JobStatusFailed     JobStatus = "failed"
)
