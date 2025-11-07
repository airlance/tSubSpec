package entity

import "io"

type Media struct {
	Filename    string
	Size        int64
	ContentType string
	Reader      io.Reader
}

type MediaType int

const (
	MediaTypeImage MediaType = iota
	MediaTypeVideo
	MediaTypeAudio
)
