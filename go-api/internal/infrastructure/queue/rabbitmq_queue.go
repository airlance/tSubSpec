package queue

import (
	"context"
	"encoding/json"
	"fmt"

	"github.com/airlance/api/internal/domain/entity"
	"github.com/airlance/api/internal/domain/repository"
	amqp "github.com/rabbitmq/amqp091-go"
	"github.com/sirupsen/logrus"
)

type RabbitMQQueue struct {
	conn      *amqp.Connection
	channel   *amqp.Channel
	queueName string
}

func NewRabbitMQQueue(url, queueName string) (repository.QueueRepository, error) {
	conn, err := amqp.Dial(url)
	if err != nil {
		return nil, fmt.Errorf("failed to connect to RabbitMQ: %w", err)
	}

	channel, err := conn.Channel()
	if err != nil {
		conn.Close()
		return nil, fmt.Errorf("failed to open channel: %w", err)
	}

	_, err = channel.QueueDeclare(
		queueName,
		true,
		false,
		false,
		false,
		nil,
	)
	if err != nil {
		channel.Close()
		conn.Close()
		return nil, fmt.Errorf("failed to declare queue: %w", err)
	}

	logrus.WithField("queue", queueName).Info("RabbitMQ connected")

	return &RabbitMQQueue{
		conn:      conn,
		channel:   channel,
		queueName: queueName,
	}, nil
}

func (q *RabbitMQQueue) PublishJob(ctx context.Context, job *entity.Job) error {
	message := map[string]string{
		"uuid":   job.UUID,
		"media":  job.MediaPath,
		"audio":  job.AudioPath,
		"bucket": "uploads",
	}

	jobData, err := json.Marshal(message)
	if err != nil {
		return fmt.Errorf("failed to marshal job: %w", err)
	}

	err = q.channel.PublishWithContext(ctx,
		"",
		q.queueName,
		false,
		false,
		amqp.Publishing{
			ContentType: "application/json",
			Body:        jobData,
		})
	if err != nil {
		return fmt.Errorf("failed to publish job: %w", err)
	}

	return nil
}

func (q *RabbitMQQueue) Close() error {
	if q.channel != nil {
		q.channel.Close()
	}
	if q.conn != nil {
		q.conn.Close()
	}
	return nil
}
