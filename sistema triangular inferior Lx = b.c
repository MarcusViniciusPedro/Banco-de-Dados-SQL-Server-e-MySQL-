#include <stdio.h>
#include <stdlib.h>

// Definimos um tamanho máximo fixo para a matriz e vetores.
// Isso evita o erro do compilador sem precisar de alocação dinâmica.
#define MAX 500 

/**
 * Função que resolve o sistema triangular inferior Lx = b
 */
void resolverSistemaTriangularInferior(int n, double L[MAX][MAX], double b[MAX], double x[MAX]) {
    for (int i = 0; i < n; i++) {
        // Verifica se a diagonal é nula para evitar divisão por zero
        if (L[i][i] == 0.0) {
            printf("\nErro: A diagonal não pode ser nula. L[%d][%d] é igual a 0.\n", i + 1, i + 1);
            exit(1);
        }

        double soma = 0.0;
        
        // Faz a soma dos elementos conhecidos
        for (int j = 0; j < i; j++) {
            soma = soma + (L[i][j] * x[j]);
        }
        
        // Calcula o valor final do x atual
        x[i] = (b[i] - soma) / L[i][i];
    }
}

int main() {
    int n;
    
    // Declaramos as matrizes e vetores com o tamanho máximo definido lá em cima.
    // O "{0}" garante que toda a matriz comece preenchida com zeros.
    double L[MAX][MAX] = {0}; 
    double b[MAX] = {0};
    double x[MAX] = {0};

    printf("==================================================\n");
    printf("      RESOLUCAO DE SISTEMA TRIANGULAR INFERIOR    \n");
    printf("==================================================\n\n");

    // 1. Pede o tamanho do sistema
    printf("Qual o tamanho (ordem) do sistema? (Maximo %d): ", MAX);
    scanf("%d", &n);

    // Verificação de segurança
    if (n <= 0 || n > MAX) {
        printf("Tamanho invalido! O valor deve estar entre 1 e %d.\n", MAX);
        return 1; // Encerra o programa com erro
    }

    // 2. Recebe os valores da matriz L
    printf("\n--- PREENCHENDO A MATRIZ L ---\n");
    printf("Dica: Como a matriz e triangular inferior, os valores acima da diagonal sao ZERO.\n");
    printf("Portanto, vou pedir apenas os valores da diagonal para baixo.\n\n");

    for (int i = 0; i < n; i++) {
        // O laco 'j' vai apenas ate o 'i' (ou seja, so pega do inicio da linha ate a diagonal)
        for (int j = 0; j <= i; j++) {
            printf("Digite o valor da Linha %d, Coluna %d (L[%d][%d]): ", i + 1, j + 1, i + 1, j + 1);
            scanf("%lf", &L[i][j]);
        }
    }

    // 3. Recebe os valores do vetor b
    printf("\n--- PREENCHENDO O VETOR b (Termos Independentes) ---\n");
    for (int i = 0; i < n; i++) {
        printf("Digite o valor para b[%d]: ", i + 1);
        scanf("%lf", &b[i]);
    }

    // 4. Resolve o sistema chamando a funcao
    resolverSistemaTriangularInferior(n, L, b, x);

    // 5. Mostra o resultado final
    printf("\n==================================================\n");
    printf("               RESULTADO FINAL (VETOR x)          \n");
    printf("==================================================\n");
    for (int i = 0; i < n; i++) {
        printf("x[%d] = %lf\n", i + 1, x[i]);
    }
    printf("==================================================\n");

    return 0;
}
