#ifndef __COZINHA_H__
#define __COZINHA_H__

#include "pedido.h"

typedef struct {
	int* cozinheiroBuffer;
	int* bocasBuffer;
	int* frigideirasBuffer;
	int* garcosBuffer;
	int* tam_balcaoBuffer;
} cozinha_t;

extern void cozinha_init(int cozinheiros, int bocas, int frigideiras, int garcons, int tam_balcao);
extern void cozinha_destroy();
extern void processar_pedido(pedido_t p);

#endif /*__COZINHA_H__*/
