#include "cozinha.h"
#include "tarefas.h"
#include <string.h>
#include <errno.h>
#include <stdlib.h>
#include <stdio.h>
#include <pthread.h>
#include <semaphore.h>

#define DEBUG 0
extern sem_t barreira;

void cozinha_init(int cozinheiros, int bocas, int frigideiras, int garcons, int tam_balcao) {
 sem_init(&pratos_prontos_balcao,0,0);
 sem_init(&espacos_vazios_balcao,0,tam_balcao);
 sem_init(&cozinheiros_livres,0,cozinheiros);
 //sem_init(&garcons_livres, 0,garcons);


 
 for(int i = 0; i < garcons; i++) {
     pthread_create(&garcom, 0, funcao_garcom,NULL);
 }
 

 sem_init(&frigideira,0,frigideiras);
 sem_init(&bocas_livres,0,bocas);

 pthread_mutex_init(&pratos_prontos_mutex,NULL);

 balcao_prontos = malloc(tam_balcao * sizeof(prato_t*));
 
 //cozinheiro = malloc(cozinheiros * sizeof(cozinheiro_t));

    num_cozi = cozinheiros;
    num_garcom = garcons;
    garcom_index = 0;
    cozinheiro_index = 0;

    tam_balcao_global = tam_balcao;

 
 
}

void cozinha_destroy() {
	sem_destroy(&pratos_prontos_balcao);
	sem_destroy(&espacos_vazios_balcao);

    sem_destroy(&cozinheiros_livres);
	sem_destroy(&frigideira);
	sem_destroy(&bocas_livres);

    pthread_mutex_destroy(&pratos_prontos_mutex);

    free(balcao_prontos);
    //free(cozinheiro);

}


void colocar_no_balcao(prato_t* prato) {
    sem_wait(&espacos_vazios_balcao);

    pthread_mutex_lock(&pratos_prontos_mutex);

        balcao_prontos[cozinheiro_index] = prato;
        cozinheiro_index = (cozinheiro_index + 1)% tam_balcao_global;

    pthread_mutex_unlock(&pratos_prontos_mutex);    
    sem_post(&pratos_prontos_balcao);
}
void processar_pedido (pedido_t p) {
    pthread_t gerencia_cozinheiros;
    pedido_t* pedido =(pedido_t*) malloc(sizeof(pedido_t));
    pedido->id = p.id;
    pedido->prato = p.prato;
    if (DEBUG != 0) {printf("Thread gerenciadora de pedidos chamada\n");}
    pthread_create(&gerencia_cozinheiros,0,produzir_pedido, (void *)pedido);

}
void * funcao_garcom(void * arg) {
     while(1){
        //sem_wait(&garcons_livres);
        sem_wait(&pratos_prontos_balcao);
        
        
        pthread_mutex_lock(&pratos_prontos_mutex);
            prato_t* prato_local = balcao_prontos[garcom_index];
            garcom_index = (garcom_index + 1) % tam_balcao_global;
        
        pthread_mutex_unlock(&pratos_prontos_mutex);

        sem_post(&espacos_vazios_balcao);
        
        entregar_pedido(prato_local);

        //sem_post(&garcons_livres);
        sem_post(&barreira);
    }  
}

void * produzir_pedido(void * arg){
	pedido_t* pedido = (pedido_t*) arg; // usado no switch apenas para evitar converter
    if (DEBUG != 0) {printf("thread gerenciando pedido num: %d \n",pedido->id);}
    
        sem_wait(&cozinheiros_livres);
        
        switch (pedido->prato)
        {
            case PEDIDO_CARNE:
            interface_fazer_carne((void *) pedido);
            break;

            case PEDIDO_SOPA:
            interface_fazer_sopa((void *)pedido);
            break;

            case PEDIDO_SPAGHETTI:
            interface_fazer_spaghetti((void *)pedido);
            break;

            case PEDIDO__SIZE:
            case PEDIDO_NULL:
                sem_post(&cozinheiros_livres);
            break;
        }
        return NULL;
        

}
// Fazer adaptador de legumes para thread usando struct criada como retorno;
void fazer_sopa(pedido_t* pedido) { // funcao que realmente faz a sopa
    prato_t* prato_atual = create_prato(*pedido);
    legumes_t* legumes = create_legumes();
    agua_t* agua = create_agua();

    pthread_t parte_agua_thread;
    pthread_t parte_legumes_thread;


    if (DEBUG != 0) {printf("Pedido %d: Sopa iniciado\n",pedido->id);}

    /** fervendo agua**/
    pthread_create(&parte_agua_thread, NULL, interface_agua, (void*)agua );
    /** cortando legumes **/
    pthread_create(&parte_legumes_thread, NULL, interface_legumes, (void*)legumes ); 

    /** esperando as tarefas paralelas terminarem **/
    pthread_join(parte_legumes_thread,NULL);
    pthread_join(parte_agua_thread,NULL);

    sem_wait(&bocas_livres);
    caldo_t* caldo = preparar_caldo(agua);
    cozinhar_legumes(legumes, caldo);
    sem_post(&bocas_livres);


    /** fazendo o caldo com a agua fervida depois de ter cortado os legumes **/
    empratar_sopa(legumes, caldo, prato_atual);


    // inserir semaforo do balcao pronto
    //sem_wait(&espacos_vazios_balcao);

    if (DEBUG != 0) {printf("Pedido %d: Pronto, esperando balcao \n",pedido->id);}

    colocar_no_balcao(prato_atual);
    //sem_post(&pratos_prontos_balcao);
    if (DEBUG != 0) {printf("Pedido %d: entregue no balcao \n",pedido->id);}

    notificar_prato_no_balcao(prato_atual);
}

void fazer_carne(pedido_t* pedido) { // funcao que realmente faz a carne
    carne_t* carne = create_carne();
    prato_t* prato = create_prato(*pedido);
    
    if (DEBUG != 0) {printf("Pedido %d: carne iniciado\n",pedido->id);}
    cortar_carne(carne);
    temperar_carne(carne);
    

    if (DEBUG != 0) {printf("Pedido %d: usando boca do fogao e frigideira\n",pedido->id);}

    sem_wait(&frigideira);
    sem_wait(&bocas_livres);

    grelhar_carne(carne);

    sem_post(&frigideira);
    sem_post(&bocas_livres);
    
    empratar_carne(carne, prato);

    if (DEBUG != 0) {printf("Pedido %d: Pronto, esperando balcao \n",pedido->id);}

    //sem_wait(&espacos_vazios_balcao);
    
    colocar_no_balcao(prato);
    //sem_post(&pratos_prontos_balcao);

    notificar_prato_no_balcao(prato);
    //sem_post(&cozinheiros_livres);
}

void fazer_spaghetti(pedido_t* pedido) { // funcao que realmente faz o spaghetti
    
    
    if (DEBUG != 0) {printf("Pedido: Spaghetti iniciado");}
    
    bacon_t* bacon = create_bacon();
    agua_t* agua = create_agua();
    molho_t* molho = create_molho();
    spaghetti_t* massa = create_spaghetti();

    prato_t* prato = create_prato(*pedido);

    pthread_t parte_agua;
    pthread_t parte_molho;
    pthread_t parte_bacon;

    pthread_create(&parte_molho,0, interface_spag_molho ,(void *)molho);

    pthread_create(&parte_bacon,0, interface_spag_bacon , (void *)bacon);
    
    pthread_create(&parte_agua,0, interface_spag_agua,(void*) agua);


    pthread_join(parte_agua,NULL);

    sem_wait(&bocas_livres);
    cozinhar_spaghetti(massa, agua);
    sem_post(&bocas_livres);
    

    //sem_post(&frigideira);
    
    pthread_join(parte_bacon,NULL);
    pthread_join(parte_molho,NULL);


    empratar_spaghetti(massa,molho,bacon,prato);
    
    //sem_wait(&espacos_vazios_balcao);
    colocar_no_balcao(prato);
    //sem_post(&pratos_prontos_balcao);

    notificar_prato_no_balcao(prato);
    sem_post(&cozinheiros_livres);
    }


/** interfaces de comunicacao entre as funcoes de tarefas e 
 * as funcoes das threads (COLOCAR COMENTARIO NO .H LOGO ANTES DA DECLARACAO DAS FUNC) **/


void * interface_fazer_carne(void * arg) {
    pedido_t* pedido = (pedido_t*)arg;
    
    if (DEBUG != 0) {printf("Thread fazendo carne\n");}

    fazer_carne(pedido);
    sem_post(&cozinheiros_livres);
    if (DEBUG != 0) {printf("Thread terminou carne\n");}    
    pthread_exit(NULL);

}
void * interface_fazer_spaghetti(void * arg) {
    pedido_t* pedido = (pedido_t*)arg;
    
    if (DEBUG != 0) {printf("Thread fazendo massa\n");}
    fazer_spaghetti(pedido);
    
    if (DEBUG != 0) {printf("Thread terminou massa\n");}    
    sem_post(&cozinheiros_livres);
    pthread_exit(NULL);

}
void * interface_fazer_sopa(void * arg) {
    pedido_t* pedido = (pedido_t*)arg;
    
    if (DEBUG != 0) {printf("Thread fazendo sopa\n");}
    fazer_sopa(pedido);
    
    if (DEBUG != 0) {printf("Thread terminou sopa\n");}    
    sem_post(&cozinheiros_livres);
    pthread_exit(NULL);
}
/* interface entre threads e tarefas paralelas*/
void * interface_agua (void * arg) {
    agua_t* agua = (agua_t*)arg;
    sem_wait(&bocas_livres);

    ferver_agua(agua);
    sem_post(&bocas_livres);
    pthread_exit(NULL);

}
void * interface_legumes (void * arg) {
    legumes_t* legumes = (legumes_t*)arg;
    cortar_legumes(legumes);
    pthread_exit(NULL);

}
void * interface_spag_agua (void * arg) {
    agua_t* agua = (agua_t*)arg;
    sem_wait(&bocas_livres);

    ferver_agua(agua);
    
    sem_post(&bocas_livres);
    pthread_exit(NULL);
}
void * interface_spag_bacon (void * arg) {
    bacon_t* bacon = (bacon_t*)arg;
    sem_wait(&frigideira);
    sem_wait(&bocas_livres);

    dourar_bacon(bacon);

    sem_post(&frigideira);
    sem_post(&bocas_livres);
    pthread_exit(NULL);

}
void * interface_spag_molho (void * arg) {
    molho_t* molho = (molho_t*)arg;
    sem_wait(&bocas_livres);

    esquentar_molho(molho);
    sem_post(&bocas_livres);
    pthread_exit(NULL);

}

