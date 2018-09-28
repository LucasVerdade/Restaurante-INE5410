#include "cozinha.h"
#include <stdlib.h>
#include <pthread.h>

void cozinha_init(int cozinheiros, int bocas, int frigideiras, int garcons, int tam_balcao) {
 sem_init(&pratos_prontos_balcao,NULL,0);
 sem_init(&espacos_vazios_balcao,NULL,tam_balcao);

 sem_init(&frigideiras,NULL,frigideiras);
 sem_init(&bocas_livres,NULL,bocas);

}

void cozinha_destroy(cozinha_t* cozinha) {
	sem_destroy(&pratos_prontos_balcao);
	sem_destroy(&espacos_vazios_balcao);

	sem_destroy(&frigideiras);
	sem_destroy(&bocas_livres);

}

void processar_pedido(pedido_t pedido) {


		
}

void produzir_pedido(pedido_t* pedido){
	switch(pedido->prato){
    case PEDIDO_SPAGHETTI:
        // Definir a receita do Spaghetti atraves das tarefas

    break;
    
    case PEDIDO_SOPA:
        // Definir a receita da sopa atraves das tarefas
    
    break;
    
    case PEDIDO_CARNE:
        // Definir a receita da carne atraves das tarefas
        carne_t* carne = create_carne();
        prato_t* prato = create_prato(*pedido);
        cortar_carne(carne);
        temperar_carne(carne);
        grelhar_carne(carne);
        empratar_carne(carne, prato);
    break;
	
    case PEDIDO__SIZE:
        pedido_prato_to_name(pedido);
    break;

    }
// Fazer adaptador de legumes para thread usando struct criada como retorno;
void fazer_sopa(pedido_t* pedido) {
    prato_t* prato = create_prato(*pedido);
    legumes_t* legumes = create_legumes();
    agua_t* agua = create_agua();

    pthread_t parte_agua_thread;
    pthread_t parte_legumes_thread;

    pthread_create(&parte_agua_thread, NULL, interface_agua, (void*)agua );
    pthread_create(&parte_legumes_thread, NULL, interface_legumes, (void*)legumes );

    pthread_join(&parte_legumes_thread,NULL);
    pthread_join(&parte_agua_thread,NULL);

    pthread_create(&parte_agua_thread, NULL,interface_caldo, (void *)agua);
    pthread_join(&parte_agua_thread,);

    cozinhar_legumes()

}


void fazer_carne(pedido_t* pedido) {
    carne_t* carne = create_carne();
    prato_t* prato = create_prato(*pedido);
    cortar_carne(carne);
    temperar_carne(carne);
    grelhar_carne(carne);
    empratar_carne(carne, prato);
}

void fazer_spaghetti(pedido_t* pedido) {
    agua_t* agua = create_agua();
    molho_t* molho = create_molho();
    spaghetti_t* massa = create_spaghetti();

    prato_t* prato = create_prato();

    pthread_t parte_agua;
    pthread_t parte_molho;
    pthread_t parte_bacon;

    pthread_create(&parte_agua,0, ferver_agua,(void*) agua)



    }


void * interface_pedido(void * arg) {
    pedido_t* pedido = (pedido_t*)arg;
    produzir_pedido(pedido);
}

void * 

