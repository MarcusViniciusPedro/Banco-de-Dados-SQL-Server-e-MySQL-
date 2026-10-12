CREATE DATABASE bd_empresa_cargo
USE bd_empresa_cargo

CREATE TABLE tb_cargo (
    IdCargo INT,
    NomeCargo VARCHAR(100),
    Valor FLOAT,
    PRIMARY KEY (IdCargo)
);

CREATE TABLE tb_funcionario (
    IdFunc INT,
    IdCargo INT,
    NomeFunc VARCHAR(100),
    SalarioFunc FLOAT,
    PRIMARY KEY (IdFunc),
    FOREIGN KEY (IdCargo) REFERENCES tb_cargo (IdCargo)
);

INSERT INTO tb_cargo VALUES 
(1, 'Programador Junior', 3500),
(2, 'Web Designer Pleno', 5500),
(3, 'Programador Pleno', 7200),
(4, 'DBA Junior', 6300),
(5, 'Programador Senior', 6100);

INSERT INTO tb_funcionario VALUES 
(11, 5, 'Jose da Silva', 6100),
(33, 2, 'Mario Jobbs', 5500),
(44, 3, 'Francisco Brasil', 7200),
(55, 4, 'Maria da Silva', 6300),
(66, 1, 'Carlos de Santos', 3500),
(77, 1, 'Jose Gates', 3500);

-- 1 - Aplicando o SELECT/CASE de forma geral, retorne o nome do funcionario, salario do
-- funcionario e classificação da faixa salarial, a saber:
-- para salário até 4000 a faixa salarial será “Salário baixo”;
-- para salário até 6000 a faixa salarial será “Salário Médio”;
-- para slarios acima de 6000 a faixa será “salário alto”

SELECT NomeFunc, SalarioFunc,
    CASE
        WHEN SalarioFunc <= 4000 THEN 'Salário Baixo'
        WHEN SalarioFunc <= 6000 THEN 'Salário Médio'
        ELSE 'Salário Alto'
    END AS FaixaSalarial
FROM tb_funcionario;

-- 2 – Usando o CASE com WHEN e sem a cláusula ELSE, retorne o nome do funcionario, salario do
-- funcionario e status do reajuste
-- para salário até 4000 o status do reajuste será “salario rejustado”;
-- para salario até 6000 o status do resjuste será “salário não reajustado

SELECT nomefunc, salariofunc,
    CASE
        WHEN salariofunc <= 4000 THEN 'Salário Reajustado'
        WHEN salariofunc <= 6000 THEN 'Salário não Reajustado'
    END AS StatusReajustados
FROM tb_funcionario;

-- 3 - Usando o CASE como expressão de pesquisa, retorne o NomeCargo, valor e o nivel do cargo:
-- para nome do cargo de Programador Junior o nível será “Iniciante”;
-- para nome do cargo de Web Designer Pleno o nível será “Experiente”;
-- para nome do cargo de Analista Senior o nível será “Avançado”;

SELECT nomecargo, valor,
    CASE
        WHEN nomecargo = 'Programador Junior' THEN 'Iniciante'
        WHEN nomecargo = 'Web Designer Pleno' THEN 'Experiente'
        WHEN nomecargo = 'Analista Senior' THEN 'Avançado'
    END AS NivelCargo
FROM tb_cargo;

-- 4 - Usando uma expressão CASE dentro de outra CASE: Cases aninhadas, retorne NomeFunc,
-- SalarioFunc e categoria aninhadas. Observe o diagrama abaixo para processar os cases:

SELECT nomefunc, salariofunc,
    CASE
        WHEN salariofunc <= 6000 THEN
            CASE
                WHEN salariofunc < 4000 THEN 'Abaixo de 4k'
                ELSE 'Entre 4k e 6k'
            END
        ELSE 'Acima de 6k'
    END AS CategoriasAninhadas
FROM tb_funcionario;

-- 5 - Usando uma expressão CASE com GROUP BY, que retorne 3 colunas: faixa salarial, total de
-- funcionários e soma dos salários. Verifique inicialmente se o Salario do Funcionario for
-- menor que R$ 6.000,00, o funcionário é classificado como 'Salários Baixos/Médios', caso contrário
-- (se for igual ou superior a R$ 6.000,00), ele é classificado como 'Salários Altos' – estes dados farão
-- parte da coluna faixa salarial. Em seguida conte (COUNT) o numero de funcionários dentro de cada
-- faixa e este dado fará parte da coluna total de funcionários. Posteriormente some (SUM) os salários
-- dentro de cada faixa, que fará parte da coluna soma dos salários. Depois agrupe os dados pela
-- classificação da faixa salarial, ou seja . 'Salários Baixos/Médios' e 'Salários Altos'.

SELECT 
    CASE
        WHEN salariofunc < 6000 THEN 'Salários Baixos/Médios'
        ELSE 'Salários Altos'
    END AS FaixaSalarial,
    COUNT(*) AS TotalFuncionarios,
    SUM(salariofunc) AS SomaSalarios
FROM tb_funcionario
GROUP BY
    CASE
        WHEN salariofunc < 6000 THEN 'Salários Baixos/Médios'
        ELSE 'Salários Altos'
    END;

-- 6 – crie uma stored procedure que recebe um idcargo e retorne TODOS os dados de TODOS os
-- funcionários associados a ele.

GO
CREATE OR ALTER PROCEDURE sp_procedure_funcionarios @IdCargo INT
AS
BEGIN
    SELECT * 
    FROM tb_funcionario
    WHERE IdCargo = @IdCargo;
END;

EXEC sp_procedure_funcionarios @IdCargo = 2

-- 7 – crie uma sp para reajustar o salário de um funcionario, que receba como parâmetro o codigo do
-- funcionario e o novo salário e faça as atualizações necessárias na tabela e deve mostrar todos os
-- dados do funcionario beneficiado.

GO
CREATE OR ALTER PROCEDURE sp_procedure_salarios @IdFuncionario INT, @novoSalario FLOAT
AS
BEGIN
    UPDATE tb_funcionario
    SET SalarioFunc = @novoSalario
    WHERE IdFunc = @IdFuncionario;

    SELECT *
    FROM tb_funcionario
    WHERE IdFunc = @IdFuncionario;
END;

EXEC sp_procedure_salarios @IdFuncionario = 11, @novoSalario = 10000

-- 8 – crie uma função que retorne o número de funcionário que ocupam um determinado Idcargo, que
-- deve ser recebido como parâmetro

GO
CREATE OR ALTER FUNCTION fn_total_funcionarios_Id (@Idcargo INT)
RETURNS INT
AS 
BEGIN
    DECLARE @total INT;

    SELECT @total = COUNT(*)
    FROM tb_funcionario
    WHERE IdCargo = @Idcargo;

    RETURN @total;
END;
GO

SELECT dbo.fn_total_funcionarios_Id(2) AS QtdFuncionarios

-- 9 – crie uma função que retorna o nome do cargo que tem o maior valor de salário e o valor
-- correspondente do cargo – é necessário usar JOIN.

GO
CREATE OR ALTER FUNCTION fn_cargo_valor()
RETURNS TABLE
AS
RETURN 
    (
    SELECT TOP 1
        c.NomeCargo,
        c.valor
    FROM tb_cargo c
    INNER JOIN tb_funcionario f ON c.IdCargo = f.IdCargo
    ORDER BY c.Valor DESC
    );
GO

SELECT * FROM dbo.fn_cargo_valor();