package cmd

import (
	"bytes"
	"encoding/json"
	"fmt"
	"io"
	"mime/multipart"
	"net/http"
	"os"
	"path/filepath"
	"time"

	"github.com/airlance/api/internal/application/dto"
	"github.com/spf13/cobra"
)

var (
	mediaPath string
	audioPath string
	apiURL    string
)

var uploadCmd = &cobra.Command{
	Use:   "upload",
	Short: "Upload files via CLI",
	Long:  `Upload media (image or video) and audio files to the API from command line.`,
	Run:   runUpload,
}

func init() {
	uploadCmd.Flags().StringVarP(&mediaPath, "media", "m", "", "Path to media file - image or video (required)")
	uploadCmd.Flags().StringVarP(&audioPath, "audio", "a", "", "Path to audio file (required)")
	uploadCmd.Flags().StringVarP(&apiURL, "url", "u", "http://localhost:8080", "API URL")
	uploadCmd.MarkFlagRequired("media")
	uploadCmd.MarkFlagRequired("audio")
}

func runUpload(cmd *cobra.Command, args []string) {
	if _, err := os.Stat(mediaPath); os.IsNotExist(err) {
		fmt.Printf("❌ Media file not found: %s\n", mediaPath)
		os.Exit(1)
	}
	if _, err := os.Stat(audioPath); os.IsNotExist(err) {
		fmt.Printf("❌ Audio file not found: %s\n", audioPath)
		os.Exit(1)
	}

	body := &bytes.Buffer{}
	writer := multipart.NewWriter(body)

	mediaFile, err := os.Open(mediaPath)
	if err != nil {
		fmt.Printf("❌ Failed to open media: %v\n", err)
		os.Exit(1)
	}
	defer mediaFile.Close()

	mediaPart, err := writer.CreateFormFile("media", filepath.Base(mediaPath))
	if err != nil {
		fmt.Printf("❌ Failed to create media form: %v\n", err)
		os.Exit(1)
	}
	io.Copy(mediaPart, mediaFile)

	audioFile, err := os.Open(audioPath)
	if err != nil {
		fmt.Printf("❌ Failed to open audio: %v\n", err)
		os.Exit(1)
	}
	defer audioFile.Close()

	audioPart, err := writer.CreateFormFile("audio", filepath.Base(audioPath))
	if err != nil {
		fmt.Printf("❌ Failed to create audio form: %v\n", err)
		os.Exit(1)
	}
	io.Copy(audioPart, audioFile)

	writer.Close()

	fmt.Println("📤 Uploading files...")
	req, err := http.NewRequest("POST", apiURL+"/upload", body)
	if err != nil {
		fmt.Printf("❌ Failed to create request: %v\n", err)
		os.Exit(1)
	}
	req.Header.Set("Content-Type", writer.FormDataContentType())

	client := &http.Client{Timeout: 30 * time.Second}
	resp, err := client.Do(req)
	if err != nil {
		fmt.Printf("❌ Failed to upload: %v\n", err)
		os.Exit(1)
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		bodyBytes, _ := io.ReadAll(resp.Body)
		fmt.Printf("❌ Upload failed: %s\n", string(bodyBytes))
		os.Exit(1)
	}

	var uploadResp dto.UploadResponse
	if err := json.NewDecoder(resp.Body).Decode(&uploadResp); err != nil {
		fmt.Printf("❌ Failed to parse response: %v\n", err)
		os.Exit(1)
	}

	fmt.Printf("✅ Upload successful!\n")
	fmt.Printf("📋 Job UUID: %s\n", uploadResp.UUID)
	fmt.Printf("🔍 Check status: curl %s/status/%s\n", apiURL, uploadResp.UUID)

	pollStatus(apiURL, uploadResp.UUID)
}

func pollStatus(baseURL, uuid string) {
	fmt.Println("\n⏳ Waiting for processing...")
	ticker := time.NewTicker(2 * time.Second)
	defer ticker.Stop()

	timeout := time.After(5 * time.Minute)

	for {
		select {
		case <-timeout:
			fmt.Println("⏰ Timeout waiting for processing")
			return
		case <-ticker.C:
			resp, err := http.Get(fmt.Sprintf("%s/status/%s", baseURL, uuid))
			if err != nil {
				fmt.Printf("❌ Failed to check status: %v\n", err)
				return
			}

			var statusResp dto.StatusResponse
			json.NewDecoder(resp.Body).Decode(&statusResp)
			resp.Body.Close()

			if statusResp.Status == "ready" {
				fmt.Printf("✅ Processing complete!\n")
				fmt.Printf("📥 Download: %s\n", statusResp.URL)
				return
			} else if statusResp.Status == "failed" {
				fmt.Println("❌ Processing failed")
				return
			}

			fmt.Print(".")
		}
	}
}
