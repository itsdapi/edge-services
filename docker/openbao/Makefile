.PHONY: up down logs init unseal unseal-all status join

CONTAINER := openbao
BAO := docker exec $(CONTAINER) bao

up:
	docker compose pull
	docker compose up -d

down:
	docker compose down

logs:
	docker compose logs -f

# Run once on the first node after all three are up. Save the output somewhere safe.
init:
	docker exec -it $(CONTAINER) bao operator init

# One shard per invocation: make unseal KEY=<shard>
unseal:
	@test -n "$(KEY)" || (echo "Usage: make unseal KEY=<unseal-key>"; exit 1)
	$(BAO) operator unseal "$(KEY)"

# All shards at once: make unseal-all KEY1=... KEY2=... KEY3=...
unseal-all:
	@test -n "$(KEY1)" -a -n "$(KEY2)" -a -n "$(KEY3)" || \
		(echo "Usage: make unseal-all KEY1=... KEY2=... KEY3=..."; exit 1)
	$(BAO) operator unseal "$(KEY1)"
	$(BAO) operator unseal "$(KEY2)"
	$(BAO) operator unseal "$(KEY3)"

status:
	$(BAO) status

# Manual fallback; retry_join in config.hcl usually handles this automatically.
join:
	@test -n "$(LEADER)" || (echo "Usage: make join LEADER=https://node1.your-tailnet.ts.net:8200"; exit 1)
	$(BAO) operator raft join "$(LEADER)"
