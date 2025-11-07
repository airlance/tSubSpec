package storage

import (
	"context"
	"fmt"
	"io"

	"github.com/airlance/api/internal/domain/repository"
	"github.com/minio/minio-go/v7"
	"github.com/minio/minio-go/v7/pkg/credentials"
	"github.com/sirupsen/logrus"
)

type MinIOStorage struct {
	client *minio.Client
	bucket string
}

func NewMinIOStorage(endpoint, accessKey, secretKey, bucket string, useSSL bool) (repository.StorageRepository, error) {
	client, err := minio.New(endpoint, &minio.Options{
		Creds:  credentials.NewStaticV4(accessKey, secretKey, ""),
		Secure: useSSL,
	})
	if err != nil {
		return nil, fmt.Errorf("failed to init MinIO: %w", err)
	}

	storage := &MinIOStorage{
		client: client,
		bucket: bucket,
	}

	if err := storage.ensureBucket(context.Background()); err != nil {
		return nil, err
	}

	return storage, nil
}

func (s *MinIOStorage) ensureBucket(ctx context.Context) error {
	exists, err := s.client.BucketExists(ctx, s.bucket)
	if err != nil {
		return fmt.Errorf("failed to check bucket: %w", err)
	}
	if !exists {
		err = s.client.MakeBucket(ctx, s.bucket, minio.MakeBucketOptions{})
		if err != nil {
			return fmt.Errorf("failed to create bucket: %w", err)
		}
		logrus.WithField("bucket", s.bucket).Info("Bucket created")
	}
	return nil
}

func (s *MinIOStorage) Upload(ctx context.Context, reader io.Reader, objectName string, size int64, contentType string) error {
	_, err := s.client.PutObject(ctx, s.bucket, objectName, reader, size, minio.PutObjectOptions{
		ContentType: contentType,
	})
	if err != nil {
		return fmt.Errorf("failed to upload object: %w", err)
	}
	return nil
}

func (s *MinIOStorage) Download(ctx context.Context, objectName string) (io.ReadCloser, int64, string, error) {
	obj, err := s.client.GetObject(ctx, s.bucket, objectName, minio.GetObjectOptions{})
	if err != nil {
		return nil, 0, "", fmt.Errorf("failed to get object: %w", err)
	}

	stat, err := obj.Stat()
	if err != nil {
		obj.Close()
		return nil, 0, "", fmt.Errorf("failed to stat object: %w", err)
	}

	return obj, stat.Size, stat.ContentType, nil
}

func (s *MinIOStorage) Exists(ctx context.Context, objectName string) (bool, error) {
	_, err := s.client.StatObject(ctx, s.bucket, objectName, minio.StatObjectOptions{})
	if err != nil {
		errResp := minio.ToErrorResponse(err)
		if errResp.Code == "NoSuchKey" {
			return false, nil
		}
		return false, err
	}
	return true, nil
}

func (s *MinIOStorage) Delete(ctx context.Context, objectName string) error {
	return s.client.RemoveObject(ctx, s.bucket, objectName, minio.RemoveObjectOptions{})
}
