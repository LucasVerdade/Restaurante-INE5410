#ifndef __COZINHA_H__
#define __COZINHA_H__

#include "pedido.h"
#include "tarefas.h"
#include <semaphore.h>
#include <pthread.h>

typedef struct {
    /* 0 se ocupado, 1 se livre*/
    int livre;
    pthread_t thread;
} cozinheiro_t;

cozinheiro_t* cozinheiro;
int num_cozi;


sem_t pratos_prontos_balcao;
sem_t espacos_vazios_balcao;

sem_t cozinheiros_livres;

sem_t frigideira;
sem_t bocas_livres;

prato_t* balcao_prontos;

extern void cozinha_init(int cozinheiros, int bocas, int frigideiras, int garcons, int tam_balcao);
extern void cozinha_destroy();
extern void processar_pedido(pedido_t* p);

void produzir_pedido(pedido_t* pedido);

void * funcao_garcom(void * prato);

#endif /*__COZINHA_H__*/
