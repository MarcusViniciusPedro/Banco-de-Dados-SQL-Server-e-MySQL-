-- ============================================================
-- 1. Criação do Banco de Dados
-- ============================================================
CREATE DATABASE db_endereco3;
GO
USE db_endereco3;
GO
-- ============================================================
-- 2. Criação das Tabelas, Relacionamentos e Índices
-- ============================================================

-- Tabela Pais
CREATE TABLE Pais (
Id INT IDENTITY(1,1) NOT NULL,
Nome VARCHAR(100) NOT NULL,
CONSTRAINT PK_Pais PRIMARY KEY (Id)
);

-- Tabela Estado
CREATE TABLE Estado (
Id INT IDENTITY(1,1) NOT NULL,
Nome VARCHAR(100) NOT NULL,
Id_pais INT NOT NULL,
CONSTRAINT PK_Estado PRIMARY KEY (Id),
CONSTRAINT FK_Estado_Pais FOREIGN KEY (Id_pais) REFERENCES Pais(Id)
);

-- Tabela Cidade
CREATE TABLE Cidade (
Id INT IDENTITY(1,1) NOT NULL,
Nome VARCHAR(100) NOT NULL,
Id_estado INT NOT NULL,
CONSTRAINT PK_Cidade PRIMARY KEY (Id),
CONSTRAINT FK_Cidade_Estado FOREIGN KEY (Id_estado) REFERENCES Estado(Id)
);

-- Tabela Endereco
CREATE TABLE Endereco (
Id INT IDENTITY(1,1) NOT NULL,
IdPessoa INT NOT NULL,
Logradouro VARCHAR(150) NOT NULL,
Complemento VARCHAR(50) NULL, -- Não está em negrito no esquema
Bairro VARCHAR(100) NOT NULL,
Cep VARCHAR(10) NOT NULL,
Id_cidade INT NOT NULL,
CONSTRAINT PK_Endereco PRIMARY KEY (Id),
CONSTRAINT FK_Endereco_Cidade FOREIGN KEY (Id_cidade) REFERENCES Cidade(Id)
);

-- ============================================================
-- 3. Populando as Tabelas
-- ============================================================

-- 1 País
INSERT INTO Pais (Nome)
VALUES ('Brasil');

-- 2 Estados
INSERT INTO Estado (Nome, Id_pais)
VALUES ('São Paulo', 1),
('Rio de Janeiro', 1);

-- 2 Cidades para cada estado (Total: 4 cidades)
INSERT INTO Cidade (Nome, Id_estado)
VALUES ('Campinas', 1), -- Id 1 (Estado 1)
('Cananéia', 1), -- Id 2 (Estado 1)
('Cabo Frio', 2), -- Id 3 (Estado 2)
('Niterói', 2); -- Id 4 (Estado 2)

-- 2 Endereços para cada cidade (Total: 8 endereços)
INSERT INTO Endereco (IdPessoa, Logradouro, Complemento, Bairro, Cep, Id_cidade)
VALUES
(101, 'Rua A', 'Apto 12', 'Centro', '13000-000', 1),
(102, 'Rua B', 'Bloco B', 'Canindé', '13000-001', 1),
(103, 'Rua C', 'Casa 1', 'Beira Mar', '11990-000', 2),
(104, 'Rua D', NULL, 'Centro', '11990-001', 2),
(105, 'Rua E', 'Casa 2', 'Passagem', '28900-000', 3),
(106, 'Rua F', 'Apto 101', 'Praia do Forte', '28900-001', 3),
(107, 'Rua G', NULL, 'Icaraí', '24000-000', 4),
(108, 'Rua H', 'Sobrado', 'Centro', '24000-001', 4);

-- 1) Retornar todas as cidades com o nome do seu respectivo estado e país

SELECT c.Nome, e.Nome, p.Nome
FROM Cidade c
LEFT JOIN Estado e
ON c.Id_estado = e.Id
JOIN Pais p
ON e.Id_pais = p.Id

-- 2) Retornar todas as cidades e seus endereços (incluindo cidades recém-criadas que ainda não possuem endereço cadastrado)

SELECT c.Nome, e.Logradouro, e.Bairro
FROM Cidade c
LEFT JOIN endereco e
ON c.Id = e.Id_cidade

INSERT INTO Cidade (Nome, Id_estado)
VALUES ('Fortaleza', 1),
('Brasília', 1)

-- 3) Retornar todos os estados e o nome do país correspondente

SELECT e.Nome, p.Nome
FROM Estado e
INNER JOIN Pais p
ON e.Id_pais = p.Id

-- 4) Trazer todas as cidades e todos os endereços, vinculados ou não

SELECT *
FROM Cidade c
FULL JOIN Endereco e
ON c.Id = e.Id_cidade

-- 5) Categorize o estado em uma região geográfica fictícia/personalizada (usar case)

SELECT e.Nome,
CASE
WHEN Nome IN ('São Paulo', 'Rio de Janeiro')THEN 'Sudeste'
ELSE ''
END AS Nome
FROM Estado e
ORDER BY e.Id