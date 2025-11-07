package config

import "os"

type Config struct {
	MinIO    MinIOConfig
	RabbitMQ RabbitMQConfig
	Server   ServerConfig
}

type MinIOConfig struct {
	Endpoint  string
	AccessKey string
	SecretKey string
	Bucket    string
	UseSSL    bool
}

type RabbitMQConfig struct {
	URL       string
	QueueName string
}

type ServerConfig struct {
	Port    string
	BaseURL string
}

func Load() *Config {
	return &Config{
		MinIO: MinIOConfig{
			Endpoint:  getEnv("MINIO_ENDPOINT", "localhost:9000"),
			AccessKey: getEnv("MINIO_ACCESS_KEY", "minio_user"),
			SecretKey: getEnv("MINIO_SECRET_KEY", "minio_password"),
			Bucket:    getEnv("MINIO_BUCKET", "uploads"),
			UseSSL:    false,
		},
		RabbitMQ: RabbitMQConfig{
			URL:       getEnv("RABBITMQ_URL", "amqp://rabbitmq:rabbitmq@localhost:5672/"),
			QueueName: getEnv("RABBITMQ_QUEUE", "jobs"),
		},
		Server: ServerConfig{
			Port:    getEnv("SERVER_PORT", "8080"),
			BaseURL: getEnv("BASE_URL", "http://api.airlance.localhost"),
		},
	}
}

func getEnv(key, defaultValue string) string {
	if value := os.Getenv(key); value != "" {
		return value
	}
	return defaultValue
}
