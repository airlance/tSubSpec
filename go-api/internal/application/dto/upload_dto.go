package dto

type UploadRequest struct {
	MediaFilename    string
	MediaSize        int64
	MediaContentType string
	AudioFilename    string
	AudioSize        int64
	AudioContentType string
}

type UploadResponse struct {
	UUID string `json:"uuid"`
}
