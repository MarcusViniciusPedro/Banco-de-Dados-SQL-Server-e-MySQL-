#include <stdio.h>
#include <stdlib.h>

#define MAX 500

/**
 * Função que resolve o sistema triangular superior Ux = b (Retrosubstituição)
 */
void resolverSistemaTriangularSuperior(int n, double U[MAX][MAX], double b[MAX], double x[MAX]) {
    // Variáveis declaradas no início para compatibilidade com C89
    int i, j;
    double soma;

    // Percorre as linhas de baixo para cima (de n-1 até 0)
    for (i = n - 1; i >= 0; i--) {
        // Verifica se a diagonal é nula para evitar divisão por zero
        if (U[i][i] == 0.0) {
            printf("\nErro: A diagonal não pode ser nula. U[%d][%d] é igual a 0.\n", i + 1, i + 1);
            exit(1);
        }

        soma = 0.0;
        
        // Soma os elementos conhecidos que estão à direita da diagonal
        for (j = i + 1; j < n; j++) {
            soma = soma + (U[i][j] * x[j]);
        }
        
        // Aplica a fórmula: x_i = (b_i - soma) / U_ii
        x[i] = (b[i] - soma) / U[i][i];
    }
}

int main() {
    // Declaração de todas as variáveis no início da main
    int n, i, j;
    
    double U[MAX][MAX] = {0}; 
    double b[MAX] = {0};
    double x[MAX] = {0};

    printf("==================================================\n");
    printf("      RESOLUCAO DE SISTEMA TRIANGULAR SUPERIOR    \n");
    printf("==================================================\n\n");

    // 1. Pede o tamanho do sistema
    printf("Qual o tamanho (ordem) do sistema? (Maximo %d): ", MAX);
    scanf("%d", &n);

    if (n <= 0 || n > MAX) {
        printf("Tamanho invalido! O valor deve estar entre 1 e %d.\n", MAX);
        return 1;
    }

    // 2. Recebe os valores da matriz U (Triangular Superior)
    printf("\n--- PREENCHENDO A MATRIZ U ---\n");
    printf("Dica: Como a matriz e triangular superior, os valores abaixo da diagonal sao ZERO.\n");
    printf("Portanto, vou pedir apenas os valores da diagonal para a direita.\n\n");

    for (i = 0; i < n; i++) {
        for (j = i; j < n; j++) {
            printf("Digite o valor da Linha %d, Coluna %d (U[%d][%d]): ", i + 1, j + 1, i + 1, j + 1);
            scanf("%lf", &U[i][j]);
        }
    }

    // 3. Recebe os valores do vetor b
    printf("\n--- PREENCHENDO O VETOR b (Termos Independentes) ---\n");
    for (i = 0; i < n; i++) {
        printf("Digite o valor para b[%d]: ", i + 1);
        scanf("%lf", &b[i]);
    }

    // 4. Resolve o sistema chamando a funcao
    resolverSistemaTriangularSuperior(n, U, b, x);

    // 5. Mostra o resultado final
    printf("\n==================================================\n");
    printf("               RESULTADO FINAL (VETOR x)          \n");
    printf("==================================================\n");
    for (i = 0; i < n; i++) {
        printf("x[%d] = %lf\n", i + 1, x[i]);
    }
    printf("==================================================\n");

    return 0;
}
