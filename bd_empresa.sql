--a) Crie o banco de dados e as relações completas com todos os atributos, chaves
--e respectivos relacionamentos; insira pelo menos 2 tuplas em cada relação (1,5
--pontos)
CREATE DATABASE bd_empresa;
USE bd_empresa;

CREATE TABLE Departamento (
   CodDep INT IDENTITY(1,1) NOT NULL,
   Descricao VARCHAR(100),
   PRIMARY KEY (CodDep)
)

CREATE TABLE Funcionario (
   codEmp INT IDENTITY (1,1) NOT NULL,
   CodDep INT NOT NULL,
   Nome VARCHAR(50),
   Salario FLOAT,
   Idade VARCHAR(3),
   PRIMARY KEY (codEmp),
   FOREIGN KEY (CodDep) REFERENCES Departamento (CodDep)
)

CREATE TABLE Projeto (
   CodProj INT IDENTITY(1,1) NOT NULL,
   Descricao VARCHAR(100),
   PRIMARY KEY (CodProj)
)

CREATE TABLE ProjetoFunc (
   codProjetoFunc INT IDENTITY(1,1) NOT NULL,
   codEmp INT NULL,
   CodProj INT NOT NULL,
   DataInicio Date,
   DataFim Date,
   PRIMARY KEY (codProjetoFunc),
   FOREIGN KEY (codEmp) REFERENCES Funcionario (codEmp),
   FOREIGN KEY (CodProj) REFERENCES Projeto (CodProj)
)

INSERT INTO Departamento VALUES ('Pesquisa'), ('Contabilidade'), ('Recursos Humanos');
INSERT INTO Funcionario VALUES (5, 'Agostinho Carrara', 40505, 56),(3, 'Mauro Ramos', 3000, 18),(1, 'Mauricio de Souza', 15000, 43), (2, 'Murilo Mauro de Murco', 2000, 21);
INSERT INTO Projeto VALUES ('Balanço Anual'), ('Desenvolvimento de Dinâmicas');
INSERT INTO ProjetoFunc VALUES (1, 1, '2026-02-21', '2026-10-01'), (2, 2, '2025-01-23', '2026-01-23');

--b) Exiba o nome do funcionário, o departamento ao qual ele pertence e a data de
--finalização da sua participação em um projeto específico (0,5 ponto)

SELECT f.nome AS Funcionario, d.Descricao AS Departamento, pf.DataFim AS Finalização, p.Descricao AS Projeto
FROM Funcionario f, Departamento d, ProjetoFunc pf
JOIN Projeto p ON p.CodProj = pf.CodProj
WHERE D.CodDep = f.CodDep AND f.codEmp = pf.codEmp

--c) Exiba todos os dados de funcionários e nome do departamento, somente para
--os empregados que pertençam ao departamento de "Pesquisa" (0,5 ponto)

SELECT f.*, d.Descricao AS Departamento
FROM Departamento d
JOIN Funcionario f ON d.CodDep = f.CodDep
WHERE d.Descricao = 'Pesquisa'

--d) Crie uma stored procedure que receba o código do funcionário e retorne todos
--os dados dos empregados e o nome do departamento. (0,5 ponto)

GO
CREATE PROCEDURE sp_funcionario (@cod INT) AS
BEGIN
   SELECT *
   FROM Funcionario
   WHERE codEmp = @cod;
END;


EXEC sp_funcionario @cod = 1

-- e) Crie uma função com 2 parâmetros de entrada, que retorna uma tabela de
--funcionários cujos salários estão dentro de dois intervalos especificados (estes
--intervalos serão determinados pelos parâmetros) (0,5 ponto)

GO
CREATE FUNCTION dbo.intervaloFuncionario (@sal1 FLOAT, @sal2 FLOAT)
RETURNS TABLE
AS
RETURN
(   SELECT *
   FROM Funcionario
   WHERE Salario > @sal1 AND Salario < @sal2
);
GO

SELECT * FROM dbo.intervaloFuncionario(1000, 10000)

--f) Crie uma consulta que retorne todos os dados de funcionário, a descrição do
--departamento, descrição do projeto, data de início e data final da execução do
--projeto (0,5 ponto)

SELECT f.*, d.Descricao, p.Descricao, pf.DataInicio, pf.DataFim
FROM Funcionario f
JOIN Departamento d ON f.CodDep = d.CodDep
JOIN ProjetoFunc pf ON f.codEmp = pf.codEmp
JOIN Projeto p ON pf.CodProj = p.CodProj

--g) Use a estrutura SELECT/CASE para uma consulta que categoriza os
--funcionários com base em suas idades: (0,5 ponto)
--idade < 18  'Adolescente'
--Idade = 18  'Juventude
--Idade > 18 e idade <= 30  'Adulto Jovem'
--Idade > 30 e idade <= 40  ‘Adulto’
--Caso contrário  'Meia idade ou Terceira Idade'

SELECT Nome, Idade,
CASE
   WHEN Idade < 18 THEN 'Adolescente'
   WHEN Idade = 18 THEN 'Juventude'
   WHEN Idade > 18 AND Idade <= 30 THEN 'Adulto Jovem'
   WHEN Idade > 30 And Idade <= 40 THEN 'Adulto'
   ELSE 'Meia idade ou Terceira Idade'
   END AS Categorização
FROM Funcionario

--h) Crie uma Stored Procedure que seja capaz de cadastrar 1 funcionário na
--respectiva tabela. (0,5 ponto)

GO
CREATE PROCEDURE sp_cadastramento (@CodDep INT, @Nome VARCHAR(50), @Salario FLOAT, @Idade VARCHAR(3)) AS
BEGIN
   INSERT INTO Funcionario VALUES (@CodDep, @Nome, @Salario, @Idade)
END;

EXEC sp_cadastramento @CodDep = 5, @Nome = 'Marcelo Lucio de Nobrega', @Salario = 3678, @Idade = 29

SELECT * FROM Funcionario