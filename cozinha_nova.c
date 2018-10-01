#include "cozinha.h"
#include "tarefas.h"
#include <stdlib.h>
#include <stdio.h>
#include <pthread.h>
#include <semaphore.h>
#include "pedido.h"

#define DEBUG 1

// variaveis globais
int num_cozi;
int num_garcom;
int garcom_index;
int cozinheiro_index;

// buffer de pedidos prontos
prato_t* balcao_prontos;

// threads
pthread_t gerenciador_pedidos;
pthread_t thread_cozinheiro;
pthread_t thread_garcom;

//semaforos
sem_t espaco_ocupado;
sem_t espaco_vazio;
sem_t cozinheiro_livre;
sem_t garcom_livre;

// mutex
pthread_mutex_t acesso_balcao_prontos;

void cozinha_init(int cozinheiros, int bocas, int frigideiras, int garcons, int tam_balcao) {
    // inicializando variaveis
    num_cozi = cozinheiros;
    num_garcom = garcons;
    garcom_index = 0;
    cozinheiro_index = 0;

    // alocando buffer de pedidos prontos
    balcao_prontos = (prato_t*) calloc(tam_balcao,sizeof(prato_t));

    // iniciando semaforos
    sem_init(&espaco_ocupado,0,0);
    sem_init(&espaco_vazio,0,tam_balcao);
    sem_init(&cozinheiro_livre,0,cozinheiros);
    sem_init(&garcom_livre,0,garcons);

    // mutex
    pthread_mutex_init(&acesso_balcao_prontos);
}
void cozinha_destroy() {
    free(balcao_prontos);

    sem_destroy(&espaco_ocupado);
    sem_destroy(&espaco_vazio);
    sem_destroy(&cozinheiro_livre);

    pthread_mutex_destroy(&acesso_balcao_prontos);
}
void processar_pedido(pedido_t p) {
    pthread_create(&gerenciador_pedidos,0,gerenciador, (void *)&p);
}

void * gerenciador (void * arg) {
	pedido_t* pedido = (pedido_t*) arg; // usado no switch apenas para evitar converter
    
    sem_wait(&cozinheiro_livre);
    switch (pedido->prato)
    {
        case PEDIDO_CARNE:
            pthread_create(&cozinheiro,0,interface_fazer_carne,arg);
        break;

        case PEDIDO_SOPA:
        pthread_create(&cozinheiro,0,interface_fazer_sopa,arg);
        break;

        case PEDIDO_SPAGHETTI:
        pthread_create(&cozinheiro,0,interface_fazer_spaghetti,arg);
        break;

        case PEDIDO__SIZE:
        case PEDIDO_NULL:
            sem_post(&cozinheiros_livres);
            return NULL;
        break;
    }
    return NULL;

}
void * interface_fazer_carne(void * arg) {
    pedido_t* pedido = (pedido_t*)arg;
    
    if (DEBUG != 0) {printf("Thread fazendo carne");}

    fazer_carne(pedido);
    sem_post(&cozinheiros_livres);
    if (DEBUG != 0) {printf("Thread terminou carne");}    
    pthread_exit(NULL);

}
void * interface_fazer_spaghetti(void * arg) {
    pedido_t* pedido = (pedido_t*)arg;
    
    if (DEBUG != 0) {printf("Thread fazendo massa");}
    fazer_spaghetti(pedido);
    
    if (DEBUG != 0) {printf("Thread terminou massa");}    
    sem_post(&cozinheiros_livres);
    pthread_exit(NULL);

}
void * interface_fazer_sopa(void * arg) {
    pedido_t* pedido = (pedido_t*)arg;
    
    if (DEBUG != 0) {printf("Thread fazendo sopa");}
    fazer_sopa(pedido);
    
    if (DEBUG != 0) {printf("Thread terminou sopa");}    
    sem_post(&cozinheiros_livres);
    pthread_exit(NULL);
}

void colocar_balcao(prato_t* prato) {
    sem_wait(&espaco_vazio);

    pthread_mutex_lock(&acesso_balcao_prontos);
    // chew acha q tem que verificar se tá vazio
        balcao_prontos[cozinheiro_index] = *prato;
        cozinheiro_index = (cozinheiro_index + 1)% num_cozi;

    pthread_mutex_unlock(&acesso_balcao_prontos);    
    sem_post(&espaco_ocupado);
}

void * funcao_garcom(void * arg) {
    
    while(1){
        sem_wait(&garcom_livre);
        sem_wait(&espaco_ocupado);
        
        pthread_mutex_lock(&acesso_balcao_prontos);
        
        entregar_pedido(&balcao_prontos[garcom_index]);
        garcom_index = (garcom_index + 1) % num_garcom;
        
        pthread_mutex_unlock(&acesso_balcao_prontos);
        
        sem_post(&acesso_balcao_prontos);
        sem_post(&garcom_livre);
    }    
}