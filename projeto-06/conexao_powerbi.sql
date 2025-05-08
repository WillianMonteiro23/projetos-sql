-- CONECTANDO NA DATABASE
USE MARKETX;

-- TEMOS A TABELA FATO VERIFICADA SEM INCONSISTENCIAS(ANALISAMOS ANTERIORMENTE)

-- PRECISAMOS CRIAR AS TABELAS DIMENSÕES

-- COM BASE NOS DADOS PODEMOS EXTRAIR 3 DIMENSOES(dProduto, dFuncionario, dCalendario)

-- dProduto
CREATE VIEW dProduto AS
SELECT DISTINCT
	cdProduto,
	Produto,
	[Grupo Produto],
	[Linha Produto]
FROM	
	[MARKETX].[dbo].[Vendas];


-- dFuncionario(VENDEDOR, SUPERVISOR OU GERENTE)
CREATE VIEW dFuncionario AS
SELECT DISTINCT
	Vendedor,
	Supervisor,
	Gerente,
	[Equipe Vendas]
FROM
	[MARKETX].[dbo].[Vendas];

-- dCalendario
CREATE VIEW dCalendario AS
SELECT
    DISTINCT
    CONVERT(DATE, DataEmissao) AS [Data],
    YEAR(DataEmissao) AS Ano,
    MONTH(DataEmissao) AS Mes,
    DATENAME(MONTH, DataEmissao) AS NomeMes,
    DAY(DataEmissao) AS Dia,
    DATEPART(WEEKDAY, DataEmissao) AS DiaSemana,
    DATENAME(WEEKDAY, DataEmissao) AS NomeDiaSemana,
    DATEPART(QUARTER, DataEmissao) AS Trimestre,
    CASE 
        WHEN MONTH(DataEmissao) <= 6 THEN 1 ELSE 2 
    END AS Semestre,
    DATEPART(DAYOFYEAR, DataEmissao) AS DiaDoAno,
    DATEPART(WEEK, DataEmissao) AS SemanaDoAno,
    CASE 
        WHEN DATEPART(WEEKDAY, DataEmissao) IN (1, 7) THEN 1 ELSE 0 
    END AS FinalDeSemana
FROM [MARKETX].[dbo].[Vendas]
WHERE DataEmissao IS NOT NULL;
