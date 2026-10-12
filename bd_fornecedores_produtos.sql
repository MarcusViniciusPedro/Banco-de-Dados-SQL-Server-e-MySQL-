-- 1.a) Crie o banco de dados
CREATE DATABASE bd_fornecedores_produtos;
USE bd_fornecedores_produtos;

-- 1.b) Crie as tabelas, chaves e relacionamentos necessários – observe que algumas relações tem chaves primarias compostas. 
CREATE TABLE Fornecedor (
    Cod_Fornecedor INT PRIMARY KEY,
    Desc_Fornecedor VARCHAR(60) NOT NULL,
    Rua_Forn VARCHAR(60),
    Numero_Forn INT,
    Bairro_Forn VARCHAR(60),
    CEP_Forn VARCHAR(9),
    Cidade_Forn VARCHAR(60),
    UF_Forn CHAR(2)
);

CREATE TABLE Telefone (
    Cod_Telefone INT PRIMARY KEY,
    Cod_Fornecedor INT,
    Telefone VARCHAR(20) NOT NULL,
    FOREIGN KEY (Cod_Fornecedor) REFERENCES Fornecedor(Cod_Fornecedor) ON DELETE CASCADE
);

CREATE TABLE Produto (
    Cod_Prod INT PRIMARY KEY,
    Cod_Fornecedor INT,
    Desc_Produto VARCHAR(60) NOT NULL,
    Preco_Produto DECIMAL(6,3) NOT NULL,
    Quant_Produto INT DEFAULT 0,
    FOREIGN KEY (Cod_Fornecedor) REFERENCES Fornecedor(Cod_Fornecedor)
);

CREATE TABLE Venda (
    Cod_Venda INT PRIMARY KEY,
    Data_Venda DATE NOT NULL
);

CREATE TABLE Prod_Venda (
    Cod_Prod INT,
    Cod_Venda INT,
    Quantidade_Vendida INT NOT NULL,
    PRIMARY KEY (Cod_Prod, Cod_Venda),
    FOREIGN KEY (Cod_Prod) REFERENCES Produto(Cod_Prod),
    FOREIGN KEY (Cod_Venda) REFERENCES Venda(Cod_Venda)
);

-- 1.c) Insira pelo menos 2 tuplas em cada tabela 
INSERT INTO Fornecedor VALUES (1, 'Distribuidora Alfa', 'Rua das Flores', 100, 'Centro', '12345-678', 'São Paulo', 'SP');
INSERT INTO Fornecedor VALUES (2, 'Comércio Beta', 'Av. Central', 550, 'Bela Vista', '98765-432', 'Campinas', 'SP');

INSERT INTO Telefone VALUES (10, 1, '(11) 99999-1111');
INSERT INTO Telefone VALUES (20, 2, '(19) 98888-2222');

INSERT INTO Produto VALUES (101, 1, 'Teclado Mecânico', 120.500, 45);
INSERT INTO Produto VALUES (102, 2, 'Mouse Sem Fio', 75.000, 80);

INSERT INTO Venda VALUES (1001, '2026-05-20');
INSERT INTO Venda VALUES (1002, '2026-05-22');

INSERT INTO Prod_Venda VALUES (101, 1001, 2);
INSERT INTO Prod_Venda VALUES (102, 1002, 5);

-- 2.a) Crie o banco de dados
CREATE DATABASE bd_gestao_projetos;
USE bd_gestao_projetos;

-- 2.b) Crie as tabelas, chaves e relacionamentos necessários – observe que alguma(s) relação (ões) tem chaves primarias compostas.
CREATE TABLE Departamento (
    num_departamento INT PRIMARY KEY,
    nome_departamento VARCHAR(60) NOT NULL,
    num_gerente INT,
    nome_gerente VARCHAR(60)
);

CREATE TABLE Empregado (
    num_empregado INT PRIMARY KEY,
    nome_empregado VARCHAR(60) NOT NULL,
    num_departamento INT,
    FOREIGN KEY (num_departamento) REFERENCES Departamento(num_departamento)
);

CREATE TABLE Projeto (
    num_projeto INT PRIMARY KEY,
    nome_projeto VARCHAR(60) NOT NULL,
    data_inicio_projeto DATE,
    dias_duracao_projeto INT,
    data_fim_projeto DATE,
    num_horas_trabalhadas_projeto INT,
    valor_por_hora_projeto DECIMAL(10,2),
    custo_total_projeto DECIMAL(10,2),
    num_departamento INT,
    FOREIGN KEY (num_departamento) REFERENCES Departamento(num_departamento)
);

-- 2.c) Insira pelo menos 2 tuplas em cada tabela
INSERT INTO Departamento VALUES (10, 'Tecnologia da Informação', 201, 'Marcos Souza');
INSERT INTO Departamento VALUES (20, 'Recursos Humanos', 202, 'Ana Costa');
INSERT INTO Departamento VALUES (30, 'Financeiro', 201, 'Marcos Souza');
INSERT INTO Departamento VALUES (40, 'Comercial', 204, 'Roberto Lima');

INSERT INTO Empregado VALUES (103, 'João Silva', 10);
INSERT INTO Empregado VALUES (104, 'Carlos Costa', 10);
INSERT INTO Empregado VALUES (105, 'Maria Souza Costa', 20);
INSERT INTO Empregado VALUES (106, 'Fernanda Almeida', 30);

INSERT INTO Projeto VALUES (1, 'Modernização do Sistema', '2026-01-15', 45, '2026-03-01', 80, 160.00, 12800.00, 10);
INSERT INTO Projeto VALUES (2, 'Portal de Benefícios', '2026-03-10', 60, '2026-05-10', 30, 150.00, 4500.00, 20);
INSERT INTO Projeto VALUES (3, 'Auditoria Anual', '2026-02-05', 20, '2026-02-25', 50, 120.00, 6000.00, 30);
INSERT INTO Projeto VALUES (4, 'Expansão de Mercado', '2026-05-01', 110, '2026-08-20', 140, 150.00, 21000.00, 40);

-- 2.d) Retornar todos os dados da tabela departamento
SELECT * FROM Departamento;

-- 2.e) Consultar os projetos cujo custo total é superior a R$ 10.000,00.
SELECT * FROM Projeto 
WHERE custo_total_projeto > 10000.00;

-- 2.f) Listar os projetos que possuem menos de 50 dias de duração.
SELECT * FROM Projeto 
WHERE dias_duracao_projeto < 50;

-- 2.g) Filtrar os projetos que têm 40 ou mais horas trabalhadas e no máximo 150 horas trabalhadas.
SELECT * FROM Projeto 
WHERE num_horas_trabalhadas_projeto BETWEEN 40 AND 150;

-- 2.h) Consultar projetos com data de início dentro do primeiro bimestre de 2026.
SELECT * FROM Projeto 
WHERE data_inicio_projeto BETWEEN '2026-01-01' AND '2026-02-28';

-- 2.i) Retornar empregados cujo nome possua o sobrenome/texto "Costa".
SELECT * FROM Empregado 
WHERE nome_empregado LIKE '%Costa%';

-- 2.j) Selecionar os empregados que estão alocados nos departamentos 10 ou 30.
SELECT * FROM Empregado 
WHERE num_departamento IN (10, 30);

-- 2.k) Buscar projetos que não pertençam aos departamentos 20 ou 30.
SELECT * FROM Projeto 
WHERE num_departamento NOT IN (20, 30);

-- 2.l) Listar empregados que são gerenciados pelo 'Marcos Souza' ou que tenham o número de empregado igual a 103.
SELECT E.* FROM Empregado E
JOIN Departamento D ON E.num_departamento = D.num_departamento
WHERE D.nome_gerente = 'Marcos Souza' OR E.num_empregado = 103;

-- 2.m) Retornar os projetos onde o valor por hora trabalhado é diferente de R$ 150,00.
SELECT * FROM Projeto 
WHERE valor_por_hora_projeto <> 150.00;