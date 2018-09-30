#include "cozinha.h"
#include "tarefas.h"
#include <stdlib.h>
#include <stdio.h>
#include <pthread.h>
#include <semaphore.h>

#define DEBUG 1

void cozinha_init(int cozinheiros, int bocas, int frigideiras, int garcons, int tam_balcao) {
 sem_init(&pratos_prontos_balcao,0,0);
 sem_init(&espacos_vazios_balcao,0,tam_balcao);
 sem_init(&cozinheiros_livres,0,cozinheiros);
 sem_init(&garcons_livres, 0,garcons);

 sem_init(&frigideira,0,frigideiras);
 sem_init(&bocas_livres,0,bocas);

 pthread_mutex_init(&pratos_prontos_mutex,NULL);

 balcao_prontos = malloc(tam_balcao * sizeof(prato_t));
 
 cozinheiro = malloc(cozinheiros * sizeof(cozinheiro_t));

 num_cozi = cozinheiros;

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
    free(cozinheiro);

}

void processar_pedido (pedido_t* pedido) {
    pthread_t gerencia_cozinheiros;
        if (DEBUG != 0) {printf("Thread gerenciadora de pedidos chamada\n");}
    pthread_create(&gerencia_cozinheiros,0,produzir_pedido, (void *)pedido);
}
void * funcao_garcom(void * arg) {
    while (1) {
        if (DEBUG != 0) {printf("Garçom ocupado");}
        sem_wait(&garcons_livres);

        sem_wait(&pratos_prontos_balcao);
        
        for(int i = 0; i < tam_balcao_global; i++)
        {
            if (balcao_prontos[i].pedido.prato != PEDIDO_NULL){
                pthread_mutex_lock(&pratos_prontos_mutex);
                
                entregar_pedido(&balcao_prontos[i]);
                
                pthread_mutex_unlock(&pratos_prontos_mutex);

                sem_post(&espacos_vazios_balcao);

            }
        }
        sem_post(&garcons_livres);
        
    }
}

void * produzir_pedido(void * arg){
	pedido_t* pedido = (pedido_t*) arg; // usado no switch apenas para evitar converter
    if (DEBUG != 0) {printf("thread gerenciando pedido num: %d \n",pedido->id);}
    
        sem_wait(&cozinheiros_livres);
        for(int i = 0; i < num_cozi; i++)
        {
            cozinheiro_t* coz = &cozinheiro[i];
            if (coz->livre == 1) {
                switch(pedido->prato){

                case PEDIDO_SPAGHETTI:
                    coz->livre = 0;
                    coz->pedido = (pedido_t*)arg;
                    pthread_create(&coz->thread,NULL,interface_fazer_spaghetti, (void * )coz);
                    return NULL;
                break;
                
                case PEDIDO_SOPA:
                    // Definir a receita da sopa atraves das tarefas
                    coz->livre = 0;
                    coz->pedido = (pedido_t*)arg;
                    pthread_create(&coz->thread,NULL,interface_fazer_sopa, (void * )coz);            
                    return NULL;
                break;
                
                case PEDIDO_CARNE:
                    // Definir a receita da carne atraves das tarefas
                    coz->livre = 0;
                    coz->pedido = (pedido_t*)arg;
                    pthread_create(&coz->thread,NULL,interface_fazer_carne, (void * )coz);            
                    return NULL;
                break;
                
                case PEDIDO__SIZE:
                    pedido_prato_to_name(pedido->prato);
                    return NULL;
                break;

                case PEDIDO_NULL:
                    pthread_exit(NULL);
                }   
            } else if (i == (num_cozi-1)) { //reseta caso não consiga pegar a thread
                i =0;
            }

        }
        return NULL;
        

}
// Fazer adaptador de legumes para thread usando struct criada como retorno;
void fazer_sopa(pedido_t* pedido) { // funcao que realmente faz a sopa
    prato_t* prato = create_prato(*pedido);
    legumes_t* legumes = create_legumes();
    agua_t* agua = create_agua();

    pthread_t parte_agua_thread;
    pthread_t parte_legumes_thread;

    sem_wait(&bocas_livres);

    if (DEBUG != 0) {printf("Pedido %d: Sopa iniciado",pedido->id);}

    /** fervendo agua**/
    pthread_create(&parte_agua_thread, NULL, interface_agua, (void*)agua );
    /** cortando legumes **/
    pthread_create(&parte_legumes_thread, NULL, interface_legumes, (void*)legumes ); 

    /** esperando as tarefas paralelas terminarem **/
    pthread_join(parte_legumes_thread,NULL);
    pthread_join(parte_agua_thread,NULL);

    /** fazendo o caldo com a agua fervida depois de ter cortado os legumes **/
    caldo_t* caldo = preparar_caldo(agua);
    cozinhar_legumes(legumes, caldo);
    empratar_sopa(legumes, caldo, prato);


    sem_post(&bocas_livres);
    // inserir semaforo do balcao pronto
    sem_wait(&espacos_vazios_balcao);

    if (DEBUG != 0) {printf("Pedido %d: Pronto, esperando balcao ",pedido->id);}

    // fazer func pra isso !!!!!!!!!!!!!!!!!!!!!!
    for(int i = 0; i < tam_balcao_global; i++)
        {
            if (balcao_prontos[i].pedido.prato == PEDIDO_NULL){
                pthread_mutex_lock(&pratos_prontos_mutex);
                // POSSIVELMENTE ERRO AQUI
                balcao_prontos[i] = *prato;                
                pthread_mutex_unlock(&pratos_prontos_mutex);
                sem_post(&espacos_vazios_balcao);
            }
        }
    sem_post(&pratos_prontos_balcao);

    notificar_prato_no_balcao(prato);
    sem_post(&cozinheiros_livres);
}
void colocar_no_balcao(prato_t* prato){
    for(int i = 0; i < tam_balcao_global; i++)
    {
        if (balcao_prontos[i].pedido.prato == PEDIDO_NULL){
            pthread_mutex_lock(&pratos_prontos_mutex);
            // POSSIVELMENTE ERRO AQUI
            balcao_prontos[i] = *prato;                
            pthread_mutex_unlock(&pratos_prontos_mutex);
            sem_post(&espacos_vazios_balcao);
        }
    }
}

void fazer_carne(pedido_t* pedido) { // funcao que realmente faz a carne
    carne_t* carne = create_carne();
    prato_t* prato = create_prato(*pedido);
    
    if (DEBUG != 0) {printf("Pedido: carne iniciado");}
    cortar_carne(carne);
    temperar_carne(carne);
    
    sem_wait(&frigideira);
    sem_wait(&bocas_livres);

    if (DEBUG != 0) {printf("Pedido: usando boca do fogao e frigideira");}

    grelhar_carne(carne);

    empratar_carne(carne, prato);

    if (DEBUG != 0) {printf("Pedido %d: Pronto, esperando balcao ",pedido->id);}

    sem_post(&frigideira);
    sem_post(&bocas_livres);
    
    sem_wait(&espacos_vazios_balcao);
    sem_post(&pratos_prontos_balcao);

    notificar_prato_no_balcao(prato);
    sem_post(&cozinheiros_livres);
}

void fazer_spaghetti(pedido_t* pedido) { // funcao que realmente faz o spaghetti
    
    sem_wait(&frigideira);
    
    sem_wait(&bocas_livres);
    sem_wait(&bocas_livres);
    sem_wait(&bocas_livres);
    if (DEBUG != 0) {printf("Pedido: Spaghetti iniciado");}
    
    bacon_t* bacon = create_bacon();
    agua_t* agua = create_agua();
    molho_t* molho = create_molho();
    spaghetti_t* massa = create_spaghetti();

    prato_t* prato = create_prato(*pedido);

    pthread_t parte_agua;
    pthread_t parte_molho;
    pthread_t parte_bacon;

    pthread_create(&parte_agua,0, interface_spag_agua,(void*) agua);
    pthread_create(&parte_molho,0, interface_spag_molho ,(void *)molho);
    pthread_create(&parte_bacon,0, interface_spag_bacon , (void *)bacon);
    
    pthread_join(parte_agua,NULL);
    cozinhar_spaghetti(massa, agua);

    pthread_join(parte_molho,NULL);
    pthread_join(parte_bacon,NULL);

    empratar_spaghetti(massa,molho,bacon,prato);
    
    sem_post(&frigideira);

    sem_post(&bocas_livres);
    sem_post(&bocas_livres);
    sem_post(&bocas_livres);
    
    sem_wait(&espacos_vazios_balcao);
    sem_post(&pratos_prontos_balcao);

    notificar_prato_no_balcao(prato);
    sem_post(&cozinheiros_livres);
    }


/** interfaces de comunicacao entre as funcoes de tarefas e 
 * as funcoes das threads (COLOCAR COMENTARIO NO .H LOGO ANTES DA DECLARACAO DAS FUNC) **/


void * interface_fazer_carne(void * arg) {
    cozinheiro_t* coz = (cozinheiro_t*)arg;
    if (DEBUG != 0) {printf("Thread fazendo carne");}

    fazer_carne(coz->pedido);
    if (DEBUG != 0) {printf("Thread terminou carne");}    
    coz->livre = 1;
    pthread_exit(NULL);

}
void * interface_fazer_spaghetti(void * arg) {
    cozinheiro_t* coz = (cozinheiro_t*)arg;
    if (DEBUG != 0) {printf("Thread fazendo massa");}
    fazer_spaghetti(coz->pedido);
    if (DEBUG != 0) {printf("Thread terminou massa");}    
    coz->livre = 1;
    pthread_exit(NULL);

}
void * interface_fazer_sopa(void * arg) {
    cozinheiro_t* coz = (cozinheiro_t*)arg;
    if (DEBUG != 0) {printf("Thread fazendo sopa");}
    fazer_sopa(coz->pedido);
    if (DEBUG != 0) {printf("Thread terminou sopa");}    
    coz->livre = 1;
    sem_post(&cozinheiros_livres);
    pthread_exit(NULL);
}
/* interface entre threads e tarefas paralelas*/
void * interface_agua (void * arg) {
    agua_t* agua = (agua_t*)arg;
    ferver_agua(agua);
    pthread_exit(NULL);

}
void * interface_legumes (void * arg) {
    legumes_t* legumes = (legumes_t*)arg;
    cortar_legumes(legumes);
    pthread_exit(NULL);

}
void * interface_spag_agua (void * arg) {
    agua_t* agua = (agua_t*)arg;
    ferver_agua(agua);
    pthread_exit(NULL);
}
void * interface_spag_bacon (void * arg) {
    bacon_t* bacon = (bacon_t*)arg;
    dourar_bacon(bacon);
    pthread_exit(NULL);

}
void * interface_spag_molho (void * arg) {
    molho_t* molho = (molho_t*)arg;
    esquentar_molho(molho);
    pthread_exit(NULL);

}

