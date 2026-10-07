#!/bin/bash
set -e

REPO_URL="https://github.com/expgt/net-fops-hw-14-4.git"
TARGET_DIR="/opt/fastapiapp"

echo "=== 1. Клонирование репозитория в $TARGET_DIR ==="
if [ -d "$TARGET_DIR" ]; then
    echo "Каталог уже существует, обновление"
    sudo git -C $TARGET_DIR pull
else
    sudo git clone $REPO_URL $TARGET_DIR
fi

echo "=== 2. Переход в каталог и настройка прав ==="
cd $TARGET_DIR
sudo chown -R $USER:$USER .

echo "=== 3. Создание файла окружения .env ==="
cat << EOF > .env
MYSQL_ROOT_PASSWORD=YtReWq4321
MYSQL_DATABASE=virtd
MYSQL_USER=app
MYSQL_PASSWORD=QwErTy1234
EOF

echo "=== 4. Запуск проекта через Docker Compose ==="
docker compose down || true
docker compose up -d --build

echo "=== Развертывание успешно завершено! ==="
docker compose ps