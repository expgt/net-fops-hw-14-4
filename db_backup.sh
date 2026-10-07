#!/bin/bash
set -e

ENV_FILE="/opt/fastapiapp/.env"
BACKUP_DIR="/opt/backup"

# Проверка наличия файла с секретами
if [ ! -f "$ENV_FILE" ]; then
    echo "Ошибка: Файл окружения $ENV_FILE не найден!" >&2
    exit 1
fi

# Экспорт переменных из .env файла хоста
export $(grep -v '^#' "$ENV_FILE" | xargs)

# Формирование имя файла дампа (Имя_БД_Дата_Время.sql.gz)
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_FILE="${BACKUP_DIR}/${MYSQL_DATABASE}_${TIMESTAMP}.sql.gz"

# Создание директории для бэкапов, если её нет
sudo mkdir -p "$BACKUP_DIR"

# Запуск бэкапа
docker run --rm \
  --network fastapiapp_backend \
  -e MYSQL_PWD="$MYSQL_ROOT_PASSWORD" \
  schnitzler/mysqldump \
  mysqldump -h mysql_db -u root "$MYSQL_DATABASE" | gzip > "$BACKUP_FILE"

# Корректировка прав, для доступа к чтению
sudo chmod 600 "$BACKUP_FILE"

echo "Бэкап базы данных '$MYSQL_DATABASE' успешно сохранен в: $BACKUP_FILE"