package cmd

import (
	"context"
	"net/http"
	"os"
	"os/signal"
	"syscall"
	"time"

	"github.com/airlance/api/internal/application/usecase"
	"github.com/airlance/api/internal/domain/service"
	handler2 "github.com/airlance/api/internal/http/handler"
	"github.com/airlance/api/internal/http/router"
	"github.com/airlance/api/internal/infrastructure/config"
	"github.com/airlance/api/internal/infrastructure/persistence"
	"github.com/airlance/api/internal/infrastructure/queue"
	"github.com/airlance/api/internal/infrastructure/storage"
	"github.com/sirupsen/logrus"
	"github.com/spf13/cobra"
)

var serverCmd = &cobra.Command{
	Use:   "server",
	Short: "Start the API server",
	Long:  `Start the HTTP API server for handling uploads and downloads.`,
	Run:   runServer,
}

func runServer(cmd *cobra.Command, args []string) {
	cfg := config.Load()
	logger := setupLogger()

	logrus.WithFields(logrus.Fields{
		"port":     cfg.Server.Port,
		"minio":    cfg.MinIO.Endpoint,
		"rabbitmq": cfg.RabbitMQ.QueueName,
	}).Info("Starting API server")

	// Infrastructure
	storageRepo, err := storage.NewMinIOStorage(
		cfg.MinIO.Endpoint,
		cfg.MinIO.AccessKey,
		cfg.MinIO.SecretKey,
		cfg.MinIO.Bucket,
		cfg.MinIO.UseSSL,
	)
	if err != nil {
		logrus.WithError(err).Fatal("Failed to initialize storage")
	}

	queueRepo, err := queue.NewRabbitMQQueue(cfg.RabbitMQ.URL, cfg.RabbitMQ.QueueName)
	if err != nil {
		logrus.WithError(err).Fatal("Failed to initialize queue")
	}
	defer queueRepo.Close()

	jobRepo := persistence.NewMemoryJobRepository()

	// Domain Services
	validationSvc := service.NewValidationService()

	// Use Cases
	uploadUseCase := usecase.NewUploadUseCase(jobRepo, storageRepo, queueRepo, validationSvc, logger)
	statusUseCase := usecase.NewStatusUseCase(jobRepo, storageRepo, cfg.Server.BaseURL)
	downloadUseCase := usecase.NewDownloadUseCase(storageRepo)

	// Handlers
	uploadHandler := handler2.NewUploadHandler(uploadUseCase)
	statusHandler := handler2.NewStatusHandler(statusUseCase)
	downloadHandler := handler2.NewDownloadHandler(downloadUseCase)

	// Router
	apiRouter := router.NewRouter(uploadHandler, statusHandler, downloadHandler)

	srv := &http.Server{
		Addr:         ":" + cfg.Server.Port,
		Handler:      apiRouter.Setup(),
		ReadTimeout:  15 * time.Second,
		WriteTimeout: 15 * time.Second,
		IdleTimeout:  60 * time.Second,
	}

	go func() {
		sigChan := make(chan os.Signal, 1)
		signal.Notify(sigChan, os.Interrupt, syscall.SIGTERM)
		<-sigChan

		logrus.Info("Shutting down server...")

		ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
		defer cancel()

		if err := srv.Shutdown(ctx); err != nil {
			logrus.WithError(err).Error("Server shutdown error")
		}
	}()

	logrus.Infof("API server started on :%s", cfg.Server.Port)
	if err := srv.ListenAndServe(); err != nil && err != http.ErrServerClosed {
		logrus.WithError(err).Fatal("Server error")
	}
}

func setupLogger() *logrus.Logger {
	logger := logrus.New()
	logger.SetFormatter(&logrus.TextFormatter{
		FullTimestamp:   true,
		TimestampFormat: "2006-01-02 15:04:05",
		ForceColors:     true,
	})
	logger.SetOutput(os.Stdout)
	logger.SetLevel(logrus.InfoLevel)
	return logger
}
