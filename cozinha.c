#include "cozinha.h"
#include <stdlib.h>
#include <semaphore.h>
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
	// criar semaforo de acesso ao fogao p os cozinheiros
	// criar semaforo para acesso ao bacao de pedidos prontos


		
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