postgres:
	docker run -d \
		--name local-postgres \
		-e POSTGRES_USER=root \
		-e POSTGRES_PASSWORD=123456 \
		-p 5432:5432 \
		postgres:alpine

createdb:
	docker exec -it local-postgres createdb --username=root --owner=root simple_bank

dropdb:
	docker exec -it local-postgres dropdb simple_bank

migrateup:
	migrate -path db/migration -database "postgres://root:123456@localhost:5432/simple_bank?sslmode=disable" -verbose up

migratedown:
	migrate -path db/migration -database "postgres://root:123456@localhost:5432/simple_bank?sslmode=disable" -verbose down -all

sqlc:
	sqlc generate

test:
	go test -v -cover ./...

server:
	go run main.go

mockgen:
	mockgen -package mockdb -destination db/mock/store.go simple-bank/db/sqlc Store

.PHONY: postgres createdb dropdb migrateup migratedown sqlc test server mockgen
