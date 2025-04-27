-- CRIAÇÃO DATABSE PARA RECEBER DADOS
CREATE DATABASE MARKETX;

-- CONECTANDO NA DATABASE
USE MARKETX;

-- EXTRAÇÃO VIA SQL SERVER IMPORT AND EXPORT WIZARD

/* TIVEMOS QUE TRANSFORMAR OS ARQUIVOS EXCEL DE .xlsx PARA .xls POIS TEMOS PROBLEMAS QUANTO AO DRIVE OLEDB DO SQLSERVER
ELE NÃO CONSEGUE FAZER A EXTRAÇÃO DE PLANILHAS EXCEL A PARTIR DE 2003, ESSA É UMA SOLUÇÃO RAPIDA PARA OBTERMOS OS DADOS*/

SELECT TOP 10 
	* 
FROM 
	[MARKETX].[dbo].[Planilha1$];


-- RENOMEANDO TABELAS

EXEC sp_rename 'Planilha1$', 'Vendas';


SELECT TOP 10 
	* 
FROM 
	[MARKETX].[dbo].[Vendas];


-- EDA VENDAS

-- VERIFICANDO TIPOS DAS COLUNAS
SELECT 
    COLUMN_NAME, 
    DATA_TYPE 
FROM 
    INFORMATION_SCHEMA.COLUMNS 
WHERE 
    TABLE_NAME = 'Vendas';


-- VERIFICANDO INCONSISTENCIAS NA COLUNA PRODUTO 
SELECT DISTINCT
	Produto
FROM
	[MARKETX].[dbo].[Vendas];

-- VALIDANDO CdProduto E Produto
SELECT
	CdProduto,
	TRIM(RIGHT(Produto, 4)) AS Validador
FROM
	[MARKETX].[dbo].[Vendas]
WHERE
	CdProduto <> TRIM(RIGHT(Produto, 4))

-- VERIFICANDO Grupo Produto
SELECT DISTINCT
	[Grupo Produto]
FROM
	[MARKETX].[dbo].[Vendas];

-- VERIFICANDO
SELECT DISTINCT
	[Linha Produto]
FROM
	[MARKETX].[dbo].[Vendas];

-- VERIFICANDO Vendedor
SELECT DISTINCT
	Vendedor,
	CdVendedor
FROM
	[MARKETX].[dbo].[Vendas];

-- VERIFICANDO Supervisor
SELECT DISTINCT
	Supervisor
FROM
	[MARKETX].[dbo].[Vendas];

-- VERIFICANDO Gerente
SELECT DISTINCT
	Gerente
FROM
	[MARKETX].[dbo].[Vendas];

-- VERIFICANDO Equipe de Vendas
SELECT DISTINCT
	[Equipe Vendas]
FROM
	[MARKETX].[dbo].[Vendas];



-- FATURAMENTO TOTAL
SELECT
	ROUND(SUM(QtdItens * ValorUnitario),2) AS [Faturamento Bruto]
FROM
	[MARKETX].[dbo].[Vendas];

-- QUANTIDADE TOTAL DE ITENS VENDIDOS
SELECT
	SUM(QtdItens) AS [Total Itens Vendidos]
FROM
	[MARKETX].[dbo].[Vendas];

-- QUANTIDADE DE ITENS VENDIDOS X FATURAMENTO GERADO POR VENDEDOR
SELECT
	Vendedor,
	SUM(QtdItens) AS [Total Itens Vendidos] 
FROM
	[MARKETX].[dbo].[Vendas]
GROUP BY Vendedor
ORDER BY SUM(QtdItens) DESC;

SELECT
	Vendedor,
	ROUND(SUM(QtdItens * ValorUnitario),2) AS [Faturamento Bruto] 
FROM
	[MARKETX].[dbo].[Vendas]
GROUP BY Vendedor
ORDER BY SUM(QtdItens * ValorUnitario) DESC;

-- FATURAMENTO POR EQUIPES DE VENDAS
SELECT
	[Equipe Vendas],
	ROUND(SUM(QtdItens * ValorUnitario),2) AS [Faturamento Bruto] 
FROM
	[MARKETX].[dbo].[Vendas]
GROUP BY [Equipe Vendas]
ORDER BY SUM(QtdItens * ValorUnitario) DESC;



-- ANALISE ABC POR GRUPO DE PRODUTOS
WITH ReceitaPorGrupo AS (
    SELECT
        [Grupo Produto],
        [Linha Produto],
        SUM(QtdItens * ValorUnitario) AS Receita
    FROM [MARKETX].[dbo].[Vendas]
    GROUP BY [Grupo Produto], [Linha Produto]
),
ReceitaOrdenada AS(
	SELECT
		[Grupo Produto],
		[Linha Produto],
		SUM(Receita) OVER () AS Receita_Geral,
		SUM(Receita) OVER (ORDER BY Receita DESC) AS Receita_Acumulada
	FROM ReceitaPorGrupo
)
SELECT
	*,
	(Receita_Acumulada / Receita_Geral) AS Percentual_Acumulado,
	CASE
		WHEN (Receita_Acumulada / Receita_Geral) <= 0.8 THEN 'A'
		WHEN (Receita_Acumulada / Receita_Geral) <=0.95 THEN 'B'
		ELSE 'C'
	END AS Classificacao_ABC
FROM
	ReceitaOrdenada;



