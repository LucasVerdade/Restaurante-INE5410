#include "cozinha.h"
#include <stdlib.h>

void cozinha_init(int cozinheiros, int bocas, int frigideiras, int garcons, int tam_balcao) {
	cozinha_t *cozinha = malloc(sizeof(cozinha_t));
	*cozinha = (cozinha_t) {
		.cozinheiroBuffer = (int*)malloc(sizeof(int)*cozinheiros),
		.bocasBuffer = (int*)malloc(sizeof(int)*bocas),
		.frigideirasBuffer = (int*)malloc(sizeof(int)*frigideiras),
		.garcosBuffer = (int*)malloc(sizeof(int)*garcons),
		.tam_balcaoBuffer = (int*)malloc(sizeof(int)*tam_balcao),
	};
}
void cozinha_destroy(cozinha_t* cozinha) {
	free(cozinha->cozinheiroBuffer);
	free(cozinha->bocasBuffer);
	free(cozinha->frigideirasBuffer);
	free(cozinha->garcosBuffer);
	free(cozinha->tam_balcaoBuffer);
	free(cozinha);
}

void processar_pedido(pedido_t pedido) {
	// criar semaforo de acesso ao fogao p os cozinheiros
	// criar semaforo para acesso ao bacao de pedidos prontos

	
}