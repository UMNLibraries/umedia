usage:
	@echo "usage: make [clean|install]"

prod:
	docker build --no-cache --target production --progress=plain -t umedia.azurecr.io/umedia-rails:latest .

