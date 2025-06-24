Build the image

```sh
docker build -t image-restart .
```

now run

```
docker compose up -d
```

watch their behaviour

```sh
watch docker ps -a
```
