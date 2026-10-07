
# Домашнее задание к занятию 5. «Практическое применение Docker» - Розаев А.Ю.

### Инструкция к выполнению

1. Для выполнения заданий обязательно ознакомьтесь с [инструкцией](https://github.com/netology-code/devops-materials/blob/master/cloudwork.MD) по экономии облачных ресурсов. Это нужно, чтобы не расходовать средства, полученные в результате использования промокода.
3. **Своё решение к задачам оформите в вашем GitHub репозитории.**
4. В личном кабинете отправьте на проверку ссылку на .md-файл в вашем репозитории.
5. Сопроводите ответ необходимыми скриншотами.

---
## Примечание: Ознакомьтесь со схемой виртуального стенда [по ссылке](https://github.com/netology-code/shvirtd-example-python/blob/main/schema.pdf)

---

## Задача 0

![0](https://github.com/expgt/net-fops-hw-14-4/blob/main/14_4_0.png)

---

## Задача 1
1. Создан fork [репозитория](https://github.com/netology-code/shvirtd-example-python).

2. Создан файл ```Dockerfile.python``` на основе существующего `Dockerfile`:

![1_2](https://github.com/expgt/net-fops-hw-14-4/blob/main/14_4_1_2.png)

3. (Необязательная часть, *) Запущено web-приложение без использования docker, с помощью venv. (Mysql БД в docker run).

![1_3_1](https://github.com/expgt/net-fops-hw-14-4/blob/main/14_4_1_3_1.png)
![1_3_2](https://github.com/expgt/net-fops-hw-14-4/blob/main/14_4_1_3_2.png)

4. (Необязательная часть, *) Добавлено управление названием таблицы через ENV переменную.

![1_4_1](https://github.com/expgt/net-fops-hw-14-4/blob/main/14_4_1_4_1.png)
![1_4_2](https://github.com/expgt/net-fops-hw-14-4/blob/main/14_4_1_4_2.png)

---

## Задача 2 (*)
1. Создан в yandex cloud container registry с именем "test" с помощью "yc tool" . [Инструкция](https://cloud.yandex.ru/ru/docs/container-registry/quickstart/?from=int-console-help)

![2_1](https://github.com/expgt/net-fops-hw-14-4/blob/main/14_4_2_1.png)

2. Настроена аутентификация локального docker в yandex container registry.
3. Собран и залит образ с python приложением из задания №1.

![2_3](https://github.com/expgt/net-fops-hw-14-4/blob/main/14_4_2_3.png)

4. Просканирован образ на уязвимости.

![2_4](https://github.com/expgt/net-fops-hw-14-4/blob/main/14_4_2_4.png)

5. Отчет сканирования.

![2_5](https://github.com/expgt/net-fops-hw-14-4/blob/main/14_4_2_5.png)

---

## Задача 3
1. Изучен файл "proxy.yaml"
2. Создан в репозитории с проектом файл ```compose.yaml```. С помощью директивы "include" подключен к нему файл "proxy.yaml".
3. В файле ```compose.yaml``` описаны следующие сервисы: 

- ```web```. Образ приложения собирается при запуске compose из файла ```Dockerfile.python```, возможность скачивания из yandex cloud container registry(из задание №2 со *) так указана (строка закоментирована). Контейнер работать в bridge-сети с названием ```backend``` и иметь фиксированный ipv4-адрес ```172.20.0.5```. Сервис перезапускается в случае ошибок.
Переданы необходимые ENV-переменные для подключения к Mysql базе данных по сетевому имени сервиса ```web``` 

- ```db```. image=mysql:8. Контейнер работает в bridge-сети с названием ```backend``` и имеет фиксированный ipv4-адрес ```172.20.0.10```. Сервис перезапускается в случае ошибок. Использованы необходимые ENV-переменные для создания: пароля root пользователя, создания базы данных, пользователя и пароля для web-приложения. Использован уже существующий .env file для назначения секретных ENV-переменных.

4. Проект запущен локально с помощью docker compose , получен успешный ответ ```curl -L http://127.0.0.1:8090``` в виде времени и локального IP-адреса.

5. Произведено подключение к БД mysql с помощью команды ```docker exec -ti <имя_контейнера> mysql -uroot -p<пароль root-пользователя>```. Введены последовательно команды: 
- show databases; 
- use virtd; 
- show tables; 
- SELECT * from requests LIMIT 10;

6. Скриншот sql-запроса.

![3](https://github.com/expgt/net-fops-hw-14-4/blob/main/14_4_3.png)

---

## Задача 4
1. Запущена в Yandex Cloud ВМ.

![4_1](https://github.com/expgt/net-fops-hw-14-4/blob/main/14_4_4_1.png)

2. Произведено подключение к ВМ по ssh и установлен docker.
3. Написан bash-скрипт, который скачивает fork-репозиторий в каталог /opt и запускает проект целиком.

![4_3](https://github.com/expgt/net-fops-hw-14-4/blob/main/14_4_4_3.png)

4. С сайта: ```https://check-host.net/check-http``` запущена проверка сервиса ```http://<внешний_IP-адрес_ВМ>:8090```. Трафик направлен в ingress-proxy и направлен через цепочки: Пользователь → Internet → Nginx → HAProxy → FastAPI(запись в БД) → HAProxy → Nginx → Internet → Пользователь

![4_4](https://github.com/expgt/net-fops-hw-14-4/blob/main/14_4_4_4.png)

5. (Необязательная часть) Настроен remote ssh context к серверу. Отображен список контекстов и результат удаленного выполнения ```docker ps -a```

![4_5](https://github.com/expgt/net-fops-hw-14-4/blob/main/14_4_4_5.png)

6. Повторно выполнен SQL-запрос на ВМ.

![4_6](https://github.com/expgt/net-fops-hw-14-4/blob/main/14_4_4_6.png)
[fork](https://github.com/expgt/net-fops-hw-14-4.git)

---

## Задача 5 (*)
1. Написан и задеплойен на облачную ВМ bash скрипт, который производит резервное копирование БД mysql в директорию "/opt/backup" с помощью запуска в сети "backend" контейнера из образа ```schnitzler/mysqldump``` при помощи ```docker run ...``` команды.
2. Протестирован ручной запуск
3. Настроено выполнение скрипта раз в 1 минуту через crontab. Для исключения проброса логина/пароля в git использован уже существующий файл .env
4. Скрипт, cron-task и скриншот с несколькими резервными копиями в "/opt/backup"

[Script](https://github.com/expgt/net-fops-hw-14-4/blob/main/deploy.sh)
![5_1](https://github.com/expgt/net-fops-hw-14-4/blob/main/14_4_5_4_1.png)
![5_2](https://github.com/expgt/net-fops-hw-14-4/blob/main/14_4_5_4_2.png)

---

## Задача 6
Скачен docker образ ```hashicorp/terraform:latest```, с помощью dive и docker save скопирован бинарный файл ```/bin/terraform``` на локальную машину.

Скриншоты  действий.

![6_1](https://github.com/expgt/net-fops-hw-14-4/blob/main/14_4_6_1.png)
![6_1](https://github.com/expgt/net-fops-hw-14-4/blob/main/14_4_6_1.png)

---

В fork-репозитории добавлено 5 файлов: ```Dockerfile.python```, ```compose.yaml```, ```.gitignore```, ```.dockerignore```,```bash-скрипт```, а также bash-скрипт резевного копирования БД.

---

## Описание проекта FastAPI-приложения для изучения Docker Compose.

Это простое веб-приложение на FastAPI, предназначенное для изучения контейнеризации и работы с Docker Compose. Приложение демонстрирует:

- Создание веб-сервиса на FastAPI
- Подключение к базе данных MySQL
- Работу с прокси-серверами (Nginx → HAProxy → FastAPI)
- Корректную настройку сетей Docker
- Передачу IP-адресов через заголовки прокси

### Функциональность

При обращении к главной странице приложение:
1. Определяет IP-адрес клиента
2. Записывает время запроса и IP-адрес в базу данных MySQL
3. Возвращает эту информацию пользователю

**Важно для обучения:** Если обращаться к приложению напрямую (минуя прокси), вы получите подсказку о неправильном выполнении задания.

## Способы запуска

### 1. Запуск через Docker Compose

**Архитектура при запуске через Docker Compose:**
```
Клиент → Nginx (8090) → HAProxy (8080) → FastAPI App (5000) → MySQL
```

### 2. Локальный запуск для разработки

```bash
# Создайте виртуальное окружение
python3 -m venv venv
source venv/bin/activate  # в Windows: venv\Scripts\activate

# Установите зависимости
pip install -r requirements.txt

# Настройте переменные окружения для подключения к БД(не забудьте отдельно запустить БД)
export DB_HOST='127.0.0.1'
export DB_USER='app'  
export DB_PASSWORD='very_strong'
export DB_NAME='example'

# Запустите приложение
uvicorn main:app --host 0.0.0.0 --port 5000 --reload
```

**Требования для локального запуска:**
- Python 3.12+
- Запущенный сервер MySQL
- База данных и пользователь, настроенные согласно переменным окружения

## Настройка базы данных MySQL

```sql
CREATE DATABASE example;
CREATE USER 'app'@'localhost' IDENTIFIED BY 'very_strong';
GRANT ALL PRIVILEGES ON example.* TO 'app'@'localhost';
FLUSH PRIVILEGES;
```

## Доступные эндпоинты

- `GET /` - главная страница (записывает запрос в БД и возвращает время + IP)
- `GET /requests` - просмотр всех записей из базы данных  
- `GET /debug` - отладочная информация о заголовках запроса
- `GET /docs` - автоматическая документация FastAPI (Swagger UI)

## Переменные окружения

| Переменная | Значение по умолчанию | Описание |
|------------|----------------------|----------|
| `DB_HOST` | `127.0.0.1` | Хост базы данных MySQL |
| `DB_USER` | `app` | Пользователь БД |
| `DB_PASSWORD` | `very_strong` | Пароль БД |
| `DB_NAME` | `example` | Имя базы данных |

## Проверка работы

```bash
# При правильной настройке через прокси
curl http://localhost:8090

# При прямом обращении (НЕПРАВИЛЬНО) 
curl http://localhost:5000  
# Получите подсказку о том, что нужно использовать порт 8090
```

## Лицензия

Этот проект распространяется под лицензией MIT (подробности в файле `LICENSE`).
