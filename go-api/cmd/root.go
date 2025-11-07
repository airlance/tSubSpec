package cmd

import (
	"fmt"
	"os"

	"github.com/spf13/cobra"
)

var rootCmd = &cobra.Command{
	Use:   "airlance",
	Short: "Airlance video processing service",
	Long:  `A video processing service that combines images and audio using MinIO and RabbitMQ.`,
	Run:   runServer,
}

func Execute() {
	if err := rootCmd.Execute(); err != nil {
		fmt.Println(err)
		os.Exit(1)
	}
}

func init() {
	rootCmd.AddCommand(serverCmd)
	rootCmd.AddCommand(uploadCmd)
}
