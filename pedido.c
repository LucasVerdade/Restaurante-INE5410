#include "pedido.h"
#include "tarefas.h"
#include <stdlib.h>
#include <string.h>
#include <stdio.h>

const char* pedido_prato_names[] = {
    "<PEDIDO NULO>",
    "SPAGHETTI",
    "SOPA",
    "CARNE"
};

pedido_prato_t pedido_prato_from_name(const char* name) {
    for (int i = 0; i < PEDIDO__SIZE; ++i) {
        if (strcmp(name, pedido_prato_names[i]) == 0)
            return (pedido_prato_t)i;
    }
    return PEDIDO_NULL;
}

const char* pedido_prato_to_name(pedido_prato_t pedido) {
    if (pedido >= PEDIDO__SIZE) {
        fprintf(stderr, "pedido_prato_t %d é inválido!\n", pedido);
        abort();
    }
    return pedido_prato_names[pedido];
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
        destroy(carne);
    break;
	
    case PEDIDO__SIZE:
        pedido_prato_to_name(pedido);
    break;

    }

}
