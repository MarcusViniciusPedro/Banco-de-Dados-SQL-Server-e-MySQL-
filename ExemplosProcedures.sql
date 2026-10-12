-- 1. Faça uma SP que retorne a mйdia da quantidade em estoque de todos os produtos

CREATE OR ALTER PROCEDURE sp_procedure_media AS
BEGIN
   SELECT avg(quantidade_estoque)
   FROM tb_produto
   WHERE quantidade_estoque > 0
END

EXEC sp_procedure_media

-- 2. Faça uma SP que retorne todos os vendedores que realizaram vendas cujo nome tenha em sua parte %dr%

CREATE OR ALTER PROCEDURE sp_procedure_vendedores AS
BEGIN
   SELECT f.IdFuncionario, f.NomeFuncionario, v.IdVendas
   FROM tb_Funcionario f
   INNER JOIN tb_vendas v
   ON v.IdVendas > 0 AND f.NomeFuncionario LIKE '%dr%'
END

EXEC sp_procedure_vendedores

-- 3. Faça uma SP que dado a PK de produto mostre quantas vendas foram realizadas por ele

CREATE OR ALTER PROCEDURE sp_procedure_vendas @pk_produto INTEGER
AS
BEGIN
   SELECT p.pk_produto, COUNT(i.fk_venda)
   FROM tb_produto p
   INNER JOIN tb_itens i
   ON p.pk_produto = i.fk_produto
   WHERE @pk_produto = p.pk_produto
   GROUP BY p.pk_produto
END

EXEC sp_procedure_vendas @pk_produto = 3

-- 4. Faça uma SP que dado a PK de uma loja mostre a quantidade de vendas realizadas para ela

CREATE OR ALTER PROCEDURE sp_procedure_lojas @pk_loja INTEGER
AS
BEGIN
   SELECT l.pk_loja, COUNT(v.pk_venda)
   FROM tb_loja l
   INNER JOIN tb_venda v
   ON l.pk_loja = v.fk_loja
   WHERE @pk_loja = l.pk_loja
   GROUP BY l.pk_loja
END

EXEC sp_procedure_lojas @pk_loja = 2

-- 5. Faça uma SP que retorne o total de vendas de uma loja informada por parâmetro. Se a loja não realizou venda, exiba uma mensagem.

CREATE OR ALTER PROCEDURE sp_procedure_totalvendas @pk_totalloja INTEGER
AS
BEGIN
   IF (@pk_totalloja IS NOT NULL)
       SELECT l.pk_loja, COUNT(v.pk_venda), l.nome
       FROM tb_loja l
       LEFT JOIN tb_venda v
       ON l.pk_loja = v.fk_loja
       WHERE @pk_totalloja = l.pk_loja
       GROUP BY l.pk_loja, l.nome
   ELSE
   BEGIN
       PRINT 'A loja não realizou vendas'
   END
END

EXEC sp_procedure_totalvendas @pk_totalloja = 0