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
int tam_balcao_global;

pthread_mutex_t pratos_prontos_mutex;

sem_t pratos_prontos_balcao;
sem_t espacos_vazios_balcao;

sem_t cozinheiros_livres;
sem_t garcons_livres;

sem_t frigideira;
sem_t bocas_livres;

prato_t* balcao_prontos;

extern void cozinha_init(int cozinheiros, int bocas, int frigideiras, int garcons, int tam_balcao);
extern void cozinha_destroy();
extern void processar_pedido(pedido_t* p);

void * produzir_pedido(void * arg);

void * funcao_garcom(void * prato);

void fazer_sopa(pedido_t* pedido);
void fazer_carne(pedido_t pedido);
void fazer_spaghetti(pedido_t* pedido);
void * interface_fazer_carne(void * arg);
void * interface_fazer_spaghetti(void * arg);
void * interface_fazer_sopa(void * arg);
void * interface_agua (void * arg);
void * interface_legumes (void * arg);
void * interface_spag_agua (void * arg);
void * interface_spag_bacon (void * arg);
void * interface_spag_molho (void * arg);

#endif /*__COZINHA_H__*/
