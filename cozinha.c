#include "cozinha.h"
#include "tarefas.h"
#include <stdlib.h>
#include <pthread.h>
#include <semaphore.h>

void cozinha_init(int cozinheiros, int bocas, int frigideiras, int garcons, int tam_balcao) {
 sem_init(&pratos_prontos_balcao,0,0);
 sem_init(&espacos_vazios_balcao,0,tam_balcao);

 sem_init(&frigideira,0,frigideiras);
 sem_init(&bocas_livres,0,bocas);

 sem_init(&cozinheiros_livres,0,cozinheiros);

 balcao_prontos = malloc(tam_balcao * sizeof(prato_t));
 
 cozinheiro = malloc(cozinheiros * sizeof(cozinheiro_t));

 num_cozi = cozinheiros;
 
 
}

void cozinha_destroy() {
	sem_destroy(&pratos_prontos_balcao);
	sem_destroy(&espacos_vazios_balcao);

    sem_destroy(&cozinheiros_livres);
	sem_destroy(&frigideira);
	sem_destroy(&bocas_livres);

    free(balcao_prontos);
    free(cozinheiro);
    free(num_cozi);

}

void processar_pedido (pedido_t* pedido) {
    pthread_t gerencia_cozinheiros;
    pthread_create(&gerencia_cozinheiros,0,produzir_pedido, (void *)pedido);
}
void * funcao_garcom(void * arg) {
    prato_t* prato = (prato_t*) arg;
    
    sem_wait(&balcao_prontos);
    sem_post(&espacos_vazios_balcao);
    entregar_pedido(prato);
}

void * produzir_pedido(void * arg){
	pedido_t* pedido = (pedido_t*) arg;

    sem_wait(&cozinheiros_livres);
    for(int i = 0; i < num_cozi; i++)
    {
        cozinheiro_t* coz = &cozinheiro[i];
        if (coz->livre == 1) {
            switch(pedido->prato){

            case PEDIDO_SPAGHETTI:
                coz->livre = 0;
                pthread_create(&coz->thread,NULL,interface_fazer_spaghetti, (void * )pedido);
            break;
            
            case PEDIDO_SOPA:
                // Definir a receita da sopa atraves das tarefas
                coz->livre = 0;
                pthread_create(&coz->thread,NULL,interface_fazer_sopa, (void * )pedido);            
            break;
            
            case PEDIDO_CARNE:
                // Definir a receita da carne atraves das tarefas
                coz->livre = 0;
                pthread_create(coz->thread,NULL,interface_fazer_carne, (void * )pedido);            
            break;
            
            case PEDIDO__SIZE:
                pedido_prato_to_name(pedido);
            break;

    }
        }
    }
    

    
}
// Fazer adaptador de legumes para thread usando struct criada como retorno;
void fazer_sopa(pedido_t* pedido) { // funcao que realmente faz a sopa
    prato_t* prato = create_prato(*pedido);
    legumes_t* legumes = create_legumes();
    agua_t* agua = create_agua();

    pthread_t parte_agua_thread;
    pthread_t parte_legumes_thread;

    sem_wait(&bocas_livres);
    /** fervendo agua**/
    pthread_create(&parte_agua_thread, NULL, interface_agua, (void*)agua );
    /** cortando legumes **/
    pthread_create(&parte_legumes_thread, NULL, interface_legumes, (void*)legumes ); 

    /** esperando as tarefas paralelas terminarem **/
    pthread_join(&parte_legumes_thread,NULL);
    pthread_join(&parte_agua_thread,NULL);

    /** fazendo o caldo com a agua fervida depois de ter cortado os legumes **/
    caldo_t* caldo = preparar_caldo(agua);
    cozinhar_legumes(legumes, caldo);
    empratar_sopa(legumes, caldo, prato);

    sem_post(&bocas_livres);
    // inserir semaforo do balcao pronto
    notificar_prato_no_balcao(prato);
    sem_post(&cozinheiros_livres);
    
}


void fazer_carne(pedido_t pedido) { // funcao que realmente faz a carne
    
    carne_t* carne = create_carne();
    prato_t* prato = create_prato(pedido);
    
    cortar_carne(carne);
    temperar_carne(carne);
    
    sem_wait(&frigideira);
    sem_wait(&bocas_livres);

    grelhar_carne(carne);

    empratar_carne(carne, prato);

    sem_post(&frigideira);
    sem_post(&bocas_livres);
    
    sem_post(&balcao_prontos);
    sem_wait(&espacos_vazios_balcao);

    notificar_prato_no_balcao(prato);
    sem_post(&cozinheiros_livres);
}

void fazer_spaghetti(pedido_t* pedido) { // funcao que realmente faz o spaghetti
    sem_wait(&frigideira);
    
    sem_wait(&bocas_livres);
    sem_wait(&bocas_livres);
    sem_wait(&bocas_livres);
    
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
    
    pthread_join(&parte_agua,NULL);
    cozinhar_spaghetti(massa, agua);

    pthread_join(&parte_molho,NULL);
    pthread_join(&parte_bacon,NULL);

    empratar_spaghetti(massa,molho,bacon,prato);
    
    sem_post(&frigideira);

    sem_post(&bocas_livres);
    sem_post(&bocas_livres);
    sem_post(&bocas_livres);
    
    sem_wait(&balcao_prontos);
    notificar_prato_no_balcao(prato);
    }


/** interfaces de comunicacao entre as funcoes de tarefas e 
 * as funcoes das threads (COLOCAR COMENTARIO NO .H LOGO ANTES DA DECLARACAO DAS FUNC) **/


void * interface_fazer_carne(void * arg) {
    pedido_t* pedido = (pedido_t*)arg;
    fazer_carne(*pedido);
    pthread_exit(NULL);

}
void * interface_fazer_spaghetti(void * arg) {
    pedido_t* pedido = (pedido_t*)arg;
    fazer_spaghetti(pedido);
    pthread_exit(NULL);

}
void * interface_fazer_sopa(void * arg) {
    pedido_t* pedido = (pedido_t*)arg;

    fazer_sopa(pedido);
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

