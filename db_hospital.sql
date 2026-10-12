--a) Inicialmente, crie o banco de dados, tabelas, relacionamentos;
CREATE DATABASE db_hospital
USE db_hospital

CREATE TABLE tb_paciente (
	IdPaciente INTEGER IDENTITY(1,1) NOT NULL,
	Nome VARCHAR(50) NOT NULL,
	DataNasc DATE NOT NULL,
	Endereco VARCHAR(100) NOT NULL,
	Telefone VARCHAR(11),
	DadosDemog VARCHAR(100),
	PRIMARY KEY (IdPaciente)
)

CREATE TABLE tb_diagnostico (
	IdDiagnostico INTEGER IDENTITY(1,1) NOT NULL,
	IdPaciente INTEGER NOT NULL,
	CondicaoMedic VARCHAR(100),
	DataDiag DATE NOT NULL,
	PRIMARY KEY (IdDiagnostico),
	FOREIGN KEY (IdPaciente) REFERENCES tb_paciente (IdPaciente)
)

CREATE TABLE tb_medicamento (
	IdMedicamento INTEGER IDENTITY(1,1) NOT NULL,
	IdPaciente INTEGER NOT NULL,
	NomeMedic VARCHAR(50) NOT NULL,
	Dosagem DECIMAL(10,2) NOT NULL,
	Instrucao VARCHAR(500),
	PRIMARY KEY (IdMedicamento),
	FOREIGN KEY (IdPaciente) REFERENCES tb_paciente (IdPaciente)
)

CREATE TABLE tb_resultado_laboratorio (
	IdResultado INTEGER IDENTITY(1,1) NOT NULL,
	IdPaciente INTEGER NOT NULL,
	Teste VARCHAR(20) NOT NULL,
	Valor DECIMAL(10,2) NOT NULL,
	DataResul DATE NOT NULL,
	PRIMARY KEY (IdResultado),
	FOREIGN KEY (IdPaciente) REFERENCES tb_paciente (IdPaciente)
)

CREATE TABLE tb_plano_tratamento (
	IdPlano INTEGER IDENTITY(1,1) NOT NULL,
	IdPaciente INTEGER NOT NULL,
	IdDiagnostico INTEGER NOT NULL,
	Tratamento VARCHAR(200),
	DataInicio DATE,
	PRIMARY KEY (IdPlano),
	FOREIGN KEY (IdPaciente) REFERENCES tb_paciente (IdPaciente),
	FOREIGN KEY (IdDiagnostico) REFERENCES tb_diagnostico (IdDiagnostico)
)

--b) Insira 3 registros em cada tabela;
INSERT INTO tb_paciente (Nome, DataNasc, Endereco, Telefone, DadosDemog) VALUES
('Carlos Eduardo Silva', '1985-03-15', 'Rua das Flores, 123 - São Paulo/SP', '11987654321', 'Masculino, Casado'),
('Ana Maria Santos', '1992-07-22', 'Av. Brasil, 456 - Rio de Janeiro/RJ', '21976543210', 'Feminino, Solteira'),
('João Pedro Pereira', '1970-11-05', 'Rua XV de Novembro, 789 - Curitiba/PR', '41965432109', 'Masculino, Divorciado');

INSERT INTO tb_diagnostico (IdPaciente, CondicaoMedic, DataDiag) VALUES
(1, 'Hipertensão Arterial Sistêmica', '2024-01-10'),
(2, 'Diabetes Mellitus Tipo 2', '2024-02-15'),
(3, 'Hipercolesterolemia', '2024-03-01');

INSERT INTO tb_medicamento (IdPaciente, NomeMedic, Dosagem, Instrucao) VALUES
(1, 'Losartana Potássica', 50.00, 'Tomar 1 comprimido via oral pela manhã todos os dias.'),
(2, 'Metformina', 850.00, 'Tomar 1 comprimido via oral após as refeições principais (almoço e jantar).'),
(3, 'Sinvastatina', 20.00, 'Tomar 1 comprimido via oral à noite, antes de dormir.');

INSERT INTO tb_resultado_laboratorio (IdPaciente, Teste, Valor, DataResul) VALUES
(1, 'Glicemia em Jejum', 95.50, '2024-01-12'),
(2, 'Hemoglobina Glicada', 7.20, '2024-02-18'),
(3, 'Colesterol Total', 240.00, '2024-03-05');

INSERT INTO tb_plano_tratamento (IdPaciente, IdDiagnostico, Tratamento, DataInicio) VALUES
(1, 1, 'Controle pressórico contínuo com medicação diária e redução do consumo de sódio.', '2024-01-15'),
(2, 2, 'Reeducação alimentar, prática diária de atividade física e controle glicêmico.', '2024-02-20'),
(3, 3, 'Uso contínuo de estatina associado a dieta com restrição de gorduras saturadas.', '2024-03-10');

--c) Crie uma procedure que insira um novo diagnóstico para um paciente, atualizando a tabela
--Diagnósticos;

GO
CREATE OR ALTER PROCEDURE proc_novo_diagnostico @IdPaciente INTEGER, @CondicaoMedic VARCHAR(100), @DataDiag DATE AS
BEGIN
	INSERT INTO tb_diagnostico VALUES (@IdPaciente, @CondicaoMedic, @DataDiag);
END;

EXEC proc_novo_diagnostico @IdPaciente = 2, @CondicaoMedic = 'Esclerose Múltipla', @DataDiag = '2025-03-05';

--d) Crie uma função que retorne o número total de diagnósticos associados a um determinado paciente
--da clínica – o paciente deve ser informado via parâmetro.

GO
CREATE OR ALTER FUNCTION func_total_diagnostico (@IdPaciente INTEGER)
RETURNS INTEGER
AS 
BEGIN
	DECLARE @Total INT;

	SELECT @Total = COUNT(*)
	FROM tb_diagnostico
	WHERE IdPaciente = @IdPaciente;
	RETURN @Total;
END;
GO

SELECT dbo.func_total_diagnostico(2) AS Total_Diagnosticos;

--e) Crie uma função que receberá o nome da condição médica (diagnóstico) como parâmetro e
--retornará uma tabela contendo os dados dos pacientes que possuem o diagnóstico informado.

GO
CREATE OR ALTER FUNCTION func_pacientes_por_diagnostico (@CondicaoMedic VARCHAR(100))
RETURNS TABLE
AS
RETURN
(
	SELECT 
		p.IdPaciente,
		p.Nome,
		p.DataNasc,
		p.Endereco,
		p.Telefone,
		p.DadosDemog,
		d.CondicaoMedic,
		d.DataDiag
	FROM tb_paciente p
	INNER JOIN tb_diagnostico d ON p.IdPaciente = d.IdPaciente
	WHERE d.CondicaoMedic LIKE '%' + @CondicaoMedic + '%'
);
GO

SELECT * FROM dbo.func_pacientes_por_diagnostico('Hipercolesterolemia')

--f) Desenvolva um trigger disparado após um INSERT em Diagnósticos, exibindo uma mensagem e
--mais os detalhes/dados do diagnóstico inserido.

GO
CREATE OR ALTER TRIGGER trg_after_insert_diagnostico
ON tb_diagnostico
AFTER INSERT
AS
BEGIN
	SET NOCOUNT ON;

	PRINT '---------------------------------------------------';
	PRINT 'NOVO DIAGNÓSTICO REGISTRADO COM SUCESSO!';
	PRINT '---------------------------------------------------';

	SELECT 
		i.IdDiagnostico,
		p.Nome AS Paciente,
		i.CondicaoMedic AS Condicao_Medica,
		i.DataDiag AS Data_Diagnostico
	FROM inserted i
	INNER JOIN tb_paciente p ON i.IdPaciente = p.IdPaciente;
END;
GO

INSERT INTO tb_diagnostico (IdPaciente, CondicaoMedic, DataDiag) 
VALUES (3, 'Insuficiência Renal', '2022-10-10');

SELECT * FROM tb_diagnostico

--g) Crie um trigger que ao ser inserido um registro em resultado de laboratório, mostre uma mensagem
--com a soma dos valores devidos pelo paciente inserido – somando todos os registros que existirem
--para aquele paciente.

GO
CREATE OR ALTER TRIGGER trg_after_insert_resultado_lab
ON tb_resultado_laboratorio
AFTER INSERT
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @IdPaciente INT;
	DECLARE @NomePaciente VARCHAR(50);
	DECLARE @SomaTotal DECIMAL(10,2);

	SELECT TOP 1 @IdPaciente = i.IdPaciente, @NomePaciente = p.Nome
	FROM inserted i
	INNER JOIN tb_paciente p ON i.IdPaciente = p.IdPaciente;

	SELECT @SomaTotal = SUM(Valor)
	FROM tb_resultado_laboratorio
	WHERE IdPaciente = @IdPaciente;

	PRINT '---------------------------------------------------';
	PRINT 'NOVO EXAME DE LABORATÓRIO INSERIDO!';
	PRINT 'Paciente: ' + @NomePaciente;
	PRINT 'Soma total devida em exames acumulados: R$ ' + CAST(@SomaTotal AS VARCHAR(20));
	PRINT '---------------------------------------------------';
END;
GO

INSERT INTO tb_resultado_laboratorio (IdPaciente, Teste, Valor, DataResul) 
VALUES (2, 'Abdomen-Total', 90.00, '2024-10-11');

SELECT * FROM tb_resultado_laboratorio

--h) Crie uma visão que mostra o nome do paciente, a condição médica diagnosticada e o plano de
--tratamento. Obs.: este tipo de mineração de dados é bem útil para uma clínica gerenciar o histórico
--de diagnósticos e tratamentos de clientes

GO
CREATE OR ALTER VIEW vw_paciente_diagnostico_tratamento AS
SELECT 
	p.Nome AS NomePaciente,
	d.CondicaoMedic AS CondicaoMedica,
	pt.Tratamento,
	pt.DataInicio
FROM tb_paciente p
INNER JOIN tb_diagnostico d ON p.IdPaciente = d.IdPaciente
INNER JOIN tb_plano_tratamento pt ON d.IdDiagnostico = pt.IdDiagnostico;
GO

SELECT * FROM vw_paciente_diagnostico_tratamento;

--i) Faça uma view que retorne o nome do Paciente, a condição médica diagnosticada e ainda
--acrescentando os dados da tabela resultado: teste, valor e data.

GO
CREATE OR ALTER VIEW vw_paciente_diagnostico_laboratorio AS
SELECT 
	p.Nome AS NomePaciente,
	d.CondicaoMedic AS CondicaoMedica,
	r.Teste,
	r.Valor,
	r.DataResul AS DataResultado
FROM tb_paciente p
INNER JOIN tb_diagnostico d ON p.IdPaciente = d.IdPaciente
INNER JOIN tb_resultado_laboratorio r ON p.IdPaciente = r.IdPaciente;
GO

SELECT * FROM vw_paciente_diagnostico_laboratorio;