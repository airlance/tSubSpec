package repository

import (
	"context"
	"io"
)

type StorageRepository interface {
	Upload(ctx context.Context, reader io.Reader, objectName string, size int64, contentType string) error
	Download(ctx context.Context, objectName string) (io.ReadCloser, int64, string, error)
	Exists(ctx context.Context, objectName string) (bool, error)
	Delete(ctx context.Context, objectName string) error
}
