CREATE DATABASE tb_petshop
USE tb_petshop

CREATE TABLE tb_cliente (
   ClienteID INT IDENTITY(1,1) NOT NULL,
   Nome VARCHAR(100) NOT NULL,
   Sobrenome VARCHAR(100) NOT NULL,
   Telefone VARCHAR(10) NOT NULL,
   Email VARCHAR(50) NOT NULL,
   Endereço VARCHAR(100) NOT NULL,
   PRIMARY KEY (ClienteID)
);

SELECT * FROM tb_cliente;

CREATE TABLE tb_pet (
   PetID INT IDENTITY(1,1) NOT NULL,
   Nome VARCHAR(100) NOT NULL,
   Especie VARCHAR(50) NOT NULL,
   Raca VARCHAR(50) NOT NULL,
   DataNasc DATE NOT NULL,
   ClienteID INT NOT NULL,
   PRIMARY KEY (PetID),
   FOREIGN KEY (ClienteID) REFERENCES tb_cliente (ClienteID)
);

SELECT * FROM tb_pet;

CREATE TABLE tb_servico (
   ServicoID INT IDENTITY(1,1) NOT NULL,
   NomeServico VARCHAR(50) NOT NULL,
   Descricao VARCHAR(500),
   Preco DECIMAL(10,2) NOT NULL,
   PRIMARY KEY (ServicoID)
);

SELECT * FROM tb_servico;

CREATE TABLE tb_ordemservico (
   OrdemServicoID INT IDENTITY(1,1) NOT NULL,
   PetID INT NOT NULL,
   ServicoID INT NOT NULL,
   DataOrdem DATE NOT NULL,
   Status VARCHAR(20) NOT NULL,
   PRIMARY KEY (OrdemServicoID),
   FOREIGN KEY (PetID) REFERENCES tb_pet (PetID),
   FOREIGN KEY (ServicoID) REFERENCES tb_servico (ServicoID)
);

SELECT * FROM tb_ordemservico;

INSERT INTO tb_cliente VALUES ('Marcus','Pedro','95637-5950','marcusviniciuspedro11@gmail.com','Rua Canário 134'),
                             ('Roberto','Barroso','44444-4444','roberto.barroso@gmail.com','Rua Benjamin 45'),
                             ('Bill','Gates','12345-6789','bill.gates@gmail.com','Rua bill 6785')

INSERT INTO tb_pet VALUES ('Floquinho','Cachorro','Lhasa','2020-03-04',1),
                         ('Bidu','Gato','Não Identificado','2019-04-05',2),
                         ('Bill Junior','Cachorro','Golden','2020-05-12',3)

INSERT INTO tb_servico VALUES ('Tosa','Tosar até a segunda camada de pelos',150.34),
                             ('Vacina','Vacina da Raiva',205.67)
                          
INSERT INTO tb_ordemservico VALUES (2,1,'2025-10-23','CONCLUÍDO'),
                                  (1,2,'2026-03-15','EM ANÁLISE')

--b) Crie uma consulta que retorne todos os dados do pet e o nome do cliente, cujo nome do cliente seja Bill Gates

SELECT p.PetID, p.Nome, p.Especie, p.Raca, p.DataNasc, p.ClienteID, c.Nome, c.Sobrenome FROM tb_pet p, tb_cliente c WHERE c.Nome = 'Bill' AND c.Sobrenome = 'Gates' AND p.ClienteID = 3;

--c) Crie uma consulta para listar todos os clientes e os pets que eles possuem

SELECT p.Nome AS NomePet, c.Nome AS NomeCliente FROM tb_pet p, tb_cliente c WHERE p.ClienteID = c.ClienteID;

--d) Elabore uma consulta nomes dos clientes, seus pets e as ordens de serviço associadas a esses pets, agrupando pelo cliente

SELECT c.Nome, p.Nome, o.OrdemServicoID FROM tb_cliente c, tb_pet p, tb_ordemservico o WHERE o.PetID = p.PetID AND c.ClienteID = p.ClienteID;

--e) Desenvolva uma função que retorna uma tabela de pets de uma espécie específica e que nasceram antes de uma determinada data, ou seja, a espécie e a data devem ser passadas por parâmetro

GO
CREATE OR ALTER FUNCTION fn_pet_especie (@especie VARCHAR(50), @data DATE)
RETURNS TABLE
BEGIN
   SELECT
END

--f) Crie uma stored procedure que receve o id do cliente como parâmetro e lista nome e sobrenome do cliente, nome do pet, nome do serviço, data da ordem de serviço e o valor do serviço

GO
CREATE OR ALTER PROCEDURE chamada_procedure (@id INT) AS
BEGIN
   SELECT Nome, Sobrenome
END

--g) Crie uma procedure que cadastre os dados de um cliente

GO
CREATE OR ALTER PROCEDURE cadastro_procedure (@Nome VARCHAR(100), @Sobrenome VARCHAR(100), @Telefone VARCHAR(11), @Email VARCHAR(50), @Endereco VARCHAR(50))
AS
BEGIN
   INSERT INTO tb_cliente VALUES (@Nome, @Sobrenome, @Telefone, @Email, @Endereco)
END

EXEC cadastro_procedure @Nome = 'Marcelo', @Sobrenome = 'Francisco', @Telefone = '11445-6677', @Email = 'marcelo-francisco@gmail.com', @Endereco = 'Rua Belga';
SELECT * FROM tb_cliente

--h) Usando a estrutura select/case, aplicando-a na tabela ordem de serviços, com base nas condições estabelecidadas pelo status

SELECT OrdemServicoID, PetID, ServicoID, DataOrdem, Status,
   CASE
       WHEN Status = 'CONCLUÍDO' THEN 'Serviço Finalizado com Sucesso'
       WHEN Status = 'EM ANÁLISE' THEN 'Aguardando Início do Serviço'
       WHEN Status = 'AGENDADO' THEN 'Serviço Marcado para Data Futura'
       WHEN Status = 'CANCELADO' THEN 'Serviço Cancelado pelo Cliente/Petshop'
       ELSE 'Status Desconhecido ou Inválido'
   END AS ResultadoStatus
FROM tb_ordemservico