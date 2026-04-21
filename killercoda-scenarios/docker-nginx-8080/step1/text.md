# Task

Vai nella directory:


cd /root/docker-lab


## 1. Costruisci l'immagine

Nome immagine:


nginx-custom


---

## 2. Avvia il container

Nome container:


web


⚠️ ATTENZIONE:

Qualcosa NON funzionerà al primo tentativo.

---

## 3. Verifica il servizio

Prova:


curl localhost:8080


Se non funziona:

- controlla le porte
- controlla il mapping docker

---

## 4. Risolvi il problema

👉 Il servizio deve rispondere su:


http://localhost:8080
---
## Comandi utili
docker ps

docker logs web

docker stop web

docker rm web

docker build -t nginx-custom .

docker run -d  --name web  -p 8080:8080 web-image

