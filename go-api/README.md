### run
```bash
go run main.go server
```

### cli
```bash
go run main.go upload -i image.jpg -a audio.mp3
```

### upload by api
```curl
curl -X POST http://localhost:8080/upload \
  -F "image=@image.jpg" \
  -F "audio=@audio.mp3"
```

### check status
```curl
curl http://localhost:8080/status/{uuid}
```