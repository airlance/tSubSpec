package dto

type StatusResponse struct {
	UUID   string `json:"uuid"`
	Status string `json:"status"`
	URL    string `json:"url,omitempty"`
}
