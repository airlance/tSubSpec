package service

import (
	"fmt"
	"path/filepath"
	"strings"
)

type ValidationService struct{}

func NewValidationService() *ValidationService {
	return &ValidationService{}
}

func (s *ValidationService) ValidateMediaFile(filename string) error {
	ext := strings.ToLower(filepath.Ext(filename))
	validExts := []string{".jpg", ".jpeg", ".png", ".webp", ".mp4", ".mov", ".avi", ".mkv", ".webm"}

	for _, valid := range validExts {
		if ext == valid {
			return nil
		}
	}

	return fmt.Errorf("invalid media format: %s (allowed: jpg, png, webp, mp4, mov, avi, mkv, webm)", ext)
}

func (s *ValidationService) ValidateAudioFile(filename string) error {
	ext := strings.ToLower(filepath.Ext(filename))
	validExts := []string{".mp3", ".wav", ".m4a", ".aac"}

	for _, valid := range validExts {
		if ext == valid {
			return nil
		}
	}

	return fmt.Errorf("invalid audio format: %s (allowed: mp3, wav, m4a, aac)", ext)
}
