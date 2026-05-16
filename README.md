# 🚀 Full Stack Docker Setup

Bu loyiha `PHP`, `Node.js` va `MySQL` servislarini Docker orqali ishga tushiradi.

---

# 📦 Servislar

- PHP Backend
- Node Frontend
- MySQL Database

---

# ⚙️ Talablar

Kompyuterda quyidagilar o‘rnatilgan bo‘lishi kerak:

- Docker
- Docker Compose

---

# 📁 Project Structure

```bash
project/
│
├── backend/
│   └── Dockerfile.dev
│
├── frontend/
│   └── Dockerfile.dev
│
├── docker-compose.yml
└── .env
```

---

# 🔑 .env Example

```env
MYSQL_ROOT_PASSWORD=root
MYSQL_DATABASE=app_db
MYSQL_USER=user
MYSQL_PASSWORD=password
```

---

# ▶️ Projectni Ishga Tushirish

## Build + Run

```bash
docker compose up --build
```

Bu command:

- image build qiladi
- containerlarni yaratadi
- projectni ishga tushiradi

---

# 🔥 Backgroundda Ishlatish

```bash
docker compose up -d --build
```

`-d` → detached mode  
Terminalni band qilmaydi.

---

# 🛑 Containerlarni To‘xtatish

```bash
docker compose down
```

---

# 🔄 Containerlarni Restart Qilish

```bash
docker compose restart
```

---

# 📜 Loglarni Ko‘rish

## Barcha servislar

```bash
docker compose logs
```

## Live logs

```bash
docker compose logs -f
```

## Faqat PHP

```bash
docker compose logs -f php
```

---

# 🐘 PHP Container Ichiga Kirish

```bash
docker exec -it backend sh
```

---

# 🟢 Node Container Ichiga Kirish

```bash
docker exec -it frontend sh
```

---

# 🗄️ MySQL Container Ichiga Kirish

```bash
docker exec -it database mysql -u root -p
```

Password `.env` ichidagi `MYSQL_ROOT_PASSWORD`

---

# 🌐 Portlar

| Service | Port |
|---|---|
| Backend | 8000 |
| Frontend | 5173 |
| MySQL | 3306 |

---

# 📂 Volumes

## Backend

```yml
- ./backend:/var/www/html
```

Local backend kodlari container bilan sync bo‘ladi.

---

## Frontend

```yml
- ./frontend:/app
```

Frontend realtime update bo‘ladi.

---

## MySQL Data

```yml
- mysql_data:/var/lib/mysql
```

Database ma’lumotlari saqlanib qoladi.

---

# 🔍 Healthcheck

```yml
depends_on:
  mysql:
    condition: service_healthy
```

MySQL tayyor bo‘lmaguncha backend kutadi.

---

# 🧹 Keraksiz Docker Fayllarni Tozalash

```bash
docker system prune -a
```

⚠️ Ishlatilmayotgan image va containerlarni o‘chiradi.

---

# 🚀 Quick Start

```bash
docker compose up -d --build
```

Frontend:

```txt
http://localhost:5173
```

Backend:

```txt
http://localhost:8000
```

MySQL:

```txt
localhost:3306
```

---

# 📌 Foydali Docker Commandlar

## Running containerlar

```bash
docker ps
```

## Barcha containerlar

```bash
docker ps -a
```

## Imagelar

```bash
docker images
```

## Container stop

```bash
docker stop backend
```

## Container start

```bash
docker start backend
```

---

# 🛠️ docker-compose.yml

```yml
services:
  php:
    build:
      context: ./backend
      dockerfile: Dockerfile.dev
    container_name: backend
    restart: unless-stopped
    ports:
      - 8000:8000
    volumes:
      - ./backend:/var/www/html
      - /var/www/html/vendor
    networks:
      - app_network
    depends_on:
      mysql:
        condition: service_healthy
    
  node:
    build:
      context: ./frontend
      dockerfile: Dockerfile.dev
    container_name: frontend
    restart: unless-stopped
    ports:
      - 5173:5173
    volumes:
      - ./frontend:/app
      - /app/node_modules
    networks:
      - app_network

  mysql:
    image: mysql:8.4
    container_name: database
    restart: unless-stopped
    env_file:
      - .env
    ports:
      - 3306:3306
    volumes: 
      - mysql_data:/var/lib/mysql
    networks:
      - app_network
    healthcheck:
      test:
        [
          "CMD",
          "mysqladmin",
          "ping",
          "-h",
          "localhost",
          "-u", 
          "root",
          "-p${MYSQL_ROOT_PASSWORD}",
        ]
      interval: 10s
      timeout: 30s
      retries: 5
      start_period: 30s

networks:
  app_network:
    driver: "bridge"

volumes:
  mysql_data:
```
