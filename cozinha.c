#ifndef __COZINHA_H__
#define __COZINHA_H__

#include "pedido.h"

void cozinha_init(int cozinheiros, int bocas, int frigideiras, int garcons, int tam_balcao) {
	int* cozinheiroBuffer = (int*)malloc(cozinheiros);
	int* bocasBuffer = (int*)malloc(bocas);
	int* frigideirasBuffer = (int*)malloc(frigideiras);
	int* garcosBuffer = (int*)malloc(garcos);
	int* tam_balcaoBuffer = (int*)malloc(tan_balcao);
}
void cozinha_destroy() {
	free(cozinheiroBuffer);
	free(bocasBuffer);
	free(frigideirasBuffer);
	free(garcosBuffer);
	free(tam_balcaoBuffer);
}
