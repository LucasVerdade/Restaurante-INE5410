#ifndef __COZINHA_H__
#define __COZINHA_H__

#include "pedido.h"
#include "tarefas.h"
#include <semaphore.h>


sem_t pratos_prontos_balcao;
sem_t espacos_vazios_balcao;

sem_t frigideiras;
sem_t bocas_livres;

prato_t* balcao_prontos;

extern void cozinha_init(int cozinheiros, int bocas, int frigideiras, int garcons, int tam_balcao);
extern void cozinha_destroy();
extern void processar_pedido(pedido_t p);

void produzir_pedido(pedido_t* pedido);

void * funcao_garcom(void * prato);

#endif /*__COZINHA_H__*/
