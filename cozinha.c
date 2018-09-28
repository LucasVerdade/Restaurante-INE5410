#include "cozinha.h"
#include <stdlib.h>
#include <pthread.h>

void cozinha_init(int cozinheiros, int bocas, int frigideiras, int garcons, int tam_balcao) {
 sem_init(&pratos_prontos_balcao,NULL,0);
 sem_init(&espacos_vazios_balcao,NULL,tam_balcao);

 sem_init(&frigideiras,NULL,frigideiras);
 sem_init(&bocas_livres,NULL,bocas);

}

void cozinha_destroy() {
	sem_destroy(&pratos_prontos_balcao);
	sem_destroy(&espacos_vazios_balcao);

	sem_destroy(&frigideiras);
	sem_destroy(&bocas_livres);

}

void processar_pedido (pedido_t pedido) {
// funcao chamada na main
    

    /* NAO USAR ESSE CODIGO AQUI
    for(int i = 0; i < n_cozinheiros; i++)
    {
        if (&cozinheiro[i]->livre)
        {
            &cozinheiro[i]->livre = false;
            /** pega as 3 bocas e a frigideira necessarias para o pedido **/
            sem_wait(&frigideiras);
            
            for(int i = 0; i < 3; i++) 
            {sem_wait(&bocas_livres);}
            
            pthread_create(&cozinheiro[i],NULL,interface_pedido,(void *)pedido);
            
            pthread
            return;
        }
        pthread_mutex_lock(&mutex_pedidos);


    }*/
    
}


void produzir_pedido(pedido_t* pedido){
	switch(pedido->prato){
    case PEDIDO_SPAGHETTI:
        
    break;
    
    case PEDIDO_SOPA:
        // Definir a receita da sopa atraves das tarefas
    
    break;
    
    case PEDIDO_CARNE:
        // Definir a receita da carne atraves das tarefas
    break;
	
    case PEDIDO__SIZE:
        pedido_prato_to_name(pedido);
    break;

    }
// Fazer adaptador de legumes para thread usando struct criada como retorno;
void fazer_sopa(pedido_t* pedido) { // funcao que realmente faz a sopa
    prato_t* prato = create_prato(*pedido);
    legumes_t* legumes = create_legumes();
    agua_t* agua = create_agua();

    pthread_t parte_agua_thread;
    pthread_t parte_legumes_thread;

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
}


void fazer_carne(pedido_t* pedido) { // funcao que realmente faz a carne
    carne_t* carne = create_carne();
    prato_t* prato = create_prato(*pedido);
    cortar_carne(carne);
    temperar_carne(carne);
    grelhar_carne(carne);
    empratar_carne(carne, prato);
}

void fazer_spaghetti(pedido_t* pedido) { // funcao que realmente faz o spaghetti
    agua_t* agua = create_agua();
    molho_t* molho = create_molho();
    spaghetti_t* massa = create_spaghetti();

    prato_t* prato = create_prato();

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
    }


/** interfaces de comunicacao entre as funcoes de tarefas e 
 * as funcoes das threads (COLOCAR COMENTARIO NO .H LOGO ANTES DA DECLARACAO DAS FUNC) **/


void * interface_pedido(void * arg) {
    pedido_t* pedido = (pedido_t*)arg;

    produzir_pedido(pedido);
}

void * interface_agua (void * arg) {
    agua_t* agua = (agua_t*)arg;
    ferver_agua(agua);
}
void * interface_legumes (void * arg) {
    legumes_t* legumes = (legumes_t*)arg;
}
void * interface_spag_agua (void * arg) {
    agua_t* agua = (agua_t*)arg;
    ferver_agua(agua);
}
void * interface_spag_bacon (void * arg) {
    bacon_t* bacon = (bacon_t*)arg;
    dourar_bacon(bacon);
}
void * interface_spag_molho (void * arg) {
    molho_t* molho = (molho_t*)arg;
    esquentar_molho(molho);
}

