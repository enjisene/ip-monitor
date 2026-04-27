## Стек

- **Core:** Ruby 3.4 + Roda
- **DB:** PostgreSQL + Sequel
- **Background:** Rufus-scheduler
- **CI/CD:** GitHub Actions + RuboCop + RSpec

## Быстрый запуск

### Подготовка:
````
make db-up
make db-migrate
````

### Основные команды:
| Команда     | Действие                     |
|:------------|:-----------------------------|
| `make run`  | Запуск приложения            |
| `make stop` | Остановить все контейнеры    |
| `make test` | Запуск RSpec тестов          |
| `make worker-up` | Запустить только мониторинг  |        

