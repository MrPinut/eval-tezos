LIGO_VERSION = 0.72.0
LIGO = docker run --rm -v "C:\Users\pinon\Desktop\Subs\eval-tezos":/data -w /data ligolang/ligo:$(LIGO_VERSION)
LIGO2 = docker run --rm -v $(PWD):/data -w /data ligolang/ligo:$(LIGO_VERSION)

image=oxheadalpha/flextesa:20230901
script=nairobibox

############################################################

help:
	@echo "Ceci est la section d'aide "



###########################################################

compileLigo: contracts/factory.mligo
	@echo "Compiling Tezos Contract... "
	@$(LIGO) compile contract $^ --output-file compiled/factory.tz
	@$(LIGO) compile contract $^ --michelson-format json --output-file compiled/factory.json

###########################################################

testLigo:
	@echo "Testing Tezos Contract... "
	@$(LIGO) run test ./tests/factory.mligo

###########################################################

install:
	@npm --prefix ./scripts/ install

###########################################################

run-deploy:
	@npm --prefix ./scripts/ run deploy
	
###########################################################

ligoInstall:
	@$(LIGO) install


###########################################################
sandbox-start:
	@docker run --rm --name flextesa-sandbox \
		--detach -p 20000:20000 \
		-e block_time=3 \
		-e flextesa_node_cors_origin='*' \
		$(image) $(script) start

sandbox-stop:
	@docker stop flextesa-sandbox

sandbox-exec:
	@docker exec flextesa-sandbox octez-client get balance for alice