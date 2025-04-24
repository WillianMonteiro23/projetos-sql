-- Criação BD para receber dados
CREATE DATABASE ABC_XYZ;

-- Extração via SQL Server Import and Export Wizard

-- Conectando ao banco de dados 
USE ABC_XYZ;

-- Visualizando dados
SELECT TOP 10
	*
FROM
	[ABC_XYZ].[dbo].[abc_xyz_dataset];

-- EDA

-- VERIFICANDO REGISTROS DUPLICADOS
SELECT 
	[Item_ID],
	COUNT(*) AS CONTAGEM
FROM
	[ABC_XYZ].[dbo].[abc_xyz_dataset]
GROUP BY
	[Item_ID]
HAVING
	COUNT(*) > 1;

-- VERIFICANDO NULOS
SELECT 
	[Item_ID]
FROM
	[ABC_XYZ].[dbo].[abc_xyz_dataset]
WHERE 
	[Item_ID] IS NULL;

SELECT 
	[Item_Name]
FROM
	[ABC_XYZ].[dbo].[abc_xyz_dataset]
WHERE 
	[Item_Name] IS NULL;

SELECT 
	[Category]
FROM
	[ABC_XYZ].[dbo].[abc_xyz_dataset]
WHERE 
	[Category] IS NULL;

-- VERIFICANDO INCONSISTENCIAS NOS DADOS(ERROS DE DIGITAÇÃO, ESPAÇOS, ETC)

SELECT DISTINCT
	[Item_Name]
FROM
	[ABC_XYZ].[dbo].[abc_xyz_dataset];

SELECT 
	[Item_Name]
FROM 
	[ABC_XYZ].[dbo].[abc_xyz_dataset]
WHERE [Item_Name] LIKE ' %' OR [Item_Name] LIKE '% ';

SELECT DISTINCT
	[Category]
FROM
	[ABC_XYZ].[dbo].[abc_xyz_dataset];

SELECT 
	[Category]
FROM 
	[ABC_XYZ].[dbo].[abc_xyz_dataset]
WHERE [Category] LIKE ' %' OR [Category] LIKE '% ';

-- VALIDAÇÃO DE DADOS

-- VALIDANDO DEMANDA(MENSAL x ANUAL)
WITH Demanda_Calculada AS(
SELECT 
	(CAST(TB.Jan_Demand AS INT) + 
	CAST(TB.Feb_Demand AS INT) + 
	CAST(TB.Mar_Demand AS INT) + 
	CAST(TB.Apr_Demand AS INT) +
	CAST(TB.May_Demand AS INT) + 
	CAST(TB.Jun_Demand AS INT) + 
	CAST(TB.Jul_Demand AS INT) + 
	CAST(TB.Aug_Demand AS INT) +
	CAST(TB.Sep_Demand AS INT) +
    CAST(TB.Oct_Demand AS INT) +
    CAST(TB.Nov_Demand AS INT) +
    CAST(TB.Dec_Demand AS INT)) AS Total_Demanda,
	TB.Total_Annual_Units
FROM 
	[ABC_XYZ].[dbo].[abc_xyz_dataset] TB
)
SELECT
	Total_Demanda,
	Total_Annual_Units
FROM
	Demanda_Calculada
WHERE
	Total_Demanda <> Total_Annual_Units;

-- VALIDANDO TOTAL VENDAS
WITH Total_Vendas AS(
SELECT 
	(CAST(TB.Total_Annual_Units AS INT) * CAST(TB.Price_Per_Unit AS INT)) AS Faturamento,
	TB.Total_Sales_Value
FROM 
	[ABC_XYZ].[dbo].[abc_xyz_dataset] TB
)
SELECT
	Faturamento,
	Total_Sales_Value
FROM
	Total_Vendas
WHERE
	Faturamento != Total_Sales_Value;


-- ANALISE ABC

-- ORDENANDO OS ITENS POR FATURAMENTO
SELECT
	TB.Item_Name,
	TB.Category,
	CAST(TB.Total_Sales_Value AS INT) AS Total_Sales_Value
FROM
	[ABC_XYZ].[dbo].[abc_xyz_dataset] TB
ORDER BY
	Total_Sales_Value DESC

-- ABC POR PRODUTOS
WITH Receita_Ordenada AS( -- TABELA TEMPORARIA PARA RECEBER DADOS ACUMULADOS
	SELECT
		TB.Item_Name,
		TB.Category,
		SUM(CAST(TB.Total_Sales_Value AS FLOAT)) OVER () as Receita_Total_Geral, -- RECEITA TOTAL GERAL
		SUM(CAST(TB.Total_Sales_Value AS FLOAT)) OVER (ORDER BY CAST(TB.Total_Sales_Value AS FLOAT) DESC) AS Receita_Acumulada -- RECEITA ACUMULADA ITEM A ITEM
	FROM 
		[ABC_XYZ].[dbo].[abc_xyz_dataset] TB
)
SELECT
	*,
	(Receita_Acumulada / Receita_Total_Geral) AS Percentual_Acumulado, -- CALCULANDO PERCENTUAL ACUMULADO
	CASE
		WHEN (Receita_Acumulada / Receita_Total_Geral) <= 0.8 THEN 'A' -- CALCULANDO ITENS QUE GERAM ATÉ 80% DO FATURAMENTO
		WHEN (Receita_Acumulada / Receita_Total_Geral) <= 0.95 THEN 'B' -- CALCULANDO ITENS QUE GERAM 15% DO FATURAMENTO
		ELSE 'C' -- CALCULANDO OS ITENS QUE GERAM 5% DOS FATURAMENTO
	END AS Classificacao_ABC
FROM
	Receita_Ordenada;
/* 20% DOS SEUS PRODUTOS CORRESPONDEM A 80% DO SEU FATURAMENTO, 30% DOS SEUS PRODUTOS CORRESPONDEM A 15% DO SEU FATURAMENTO,
50% DOS SEUS PRODUTOS CORRESPONDEM A 5% DO SEU FATURAMENTO, VOCE DEVE TER TODOS, MAS EM UMA PROPORÇÃO EQUIVALENTE, PARA OTIMIZAR
SEU ESTOQUE


ESSA QUERY NOS AJUDA A OBSERVAR ISSO, QUAIS PRODUTOS ESTÃO EM CADA FAIXA, A, B OU C*/


-- CLASSIFICAR XYZ
WITH DemandaLonga AS (
  SELECT
    Item_ID,
    Item_Name,
    Mes,
    CAST(Demanda AS FLOAT) AS Demanda
  FROM 
	[ABC_XYZ].[dbo].[abc_xyz_dataset]
  UNPIVOT (
    Demanda FOR Mes IN ( -- PARA CADA COLUNA DE MES, COLOQUE O NOME DA COLUNA NO MES E O VALOR EM DEMANDA
      Jan_Demand, Feb_Demand, Mar_Demand, Apr_Demand, May_Demand, Jun_Demand,
      Jul_Demand, Aug_Demand, Sep_Demand, Oct_Demand, Nov_Demand, Dec_Demand
    )
  ) AS Unpivoted
),
Estatisticas AS (
  SELECT
    Item_ID,
    Item_Name,
    AVG(Demanda) AS Media_Demanda,
    STDEV(Demanda) AS Desvio_Padrao
  FROM DemandaLonga
  GROUP BY Item_ID, Item_Name
)
SELECT 
	*,
	Desvio_Padrao / Media_Demanda AS Coeficiente_Variacao,
	CASE
		WHEN Desvio_Padrao IS NULL OR Media_Demanda = 0 THEN 'Sem dados'
		WHEN Desvio_Padrao / Media_Demanda < 0.5 THEN 'X'
		WHEN Desvio_Padrao / Media_Demanda BETWEEN 0.5 AND 1 THEN 'Y'
		ELSE 'Z'
	END AS Classificacao_XYZ
FROM 
	Estatisticas
ORDER BY 
	Classificacao_XYZ, Media_Demanda DESC;


-- ANALISE ABC-XYZ
WITH Receita_Ordenada AS(
	SELECT
		TB.Item_ID,
		TB.Item_Name,
		TB.Category,
		SUM(CAST(TB.Total_Sales_Value AS FLOAT)) OVER () AS Receita_Geral,
		SUM(CAST(TB.Total_Sales_Value AS FLOAT)) OVER (ORDER BY CAST(TB.Total_Sales_Value AS FLOAT) DESC) AS Receita_Acumulada
	FROM
		[ABC_XYZ].[dbo].[abc_xyz_dataset] TB
),
DemandaLonga AS(
	SELECT
		Item_ID,
		Item_Name,
		Category,
		Mes,
		CAST(Demanda AS FLOAT) AS Demanda
	FROM
		[ABC_XYZ].[dbo].[abc_xyz_dataset]
	 UNPIVOT (
        Demanda FOR Mes IN (
            Jan_Demand, Feb_Demand, Mar_Demand, Apr_Demand, May_Demand, Jun_Demand,
            Jul_Demand, Aug_Demand, Sep_Demand, Oct_Demand, Nov_Demand, Dec_Demand
        )
    ) AS Unpivoted
),
Estatisticas AS(
	SELECT
		DL.Item_ID,
		AVG(DL.Demanda) AS Media_Demanda,
		STDEV(DL.Demanda) AS Desvio_Padrao
	FROM 
		DemandaLonga DL
	GROUP BY 
		DL.Item_ID
)
SELECT 
	R.Item_Name,
	R.Category,
	CASE
		WHEN Receita_Acumulada / Receita_Geral <= 0.8 THEN 'A'
		WHEN Receita_Acumulada / Receita_Geral <= 0.95 THEN 'B'
		ELSE 'C' 
	END AS Classificacao_ABC,
	CASE
        WHEN E.Desvio_Padrao IS NULL OR E.Media_Demanda = 0 THEN 'Sem dados'
        WHEN E.Desvio_Padrao / E.Media_Demanda < 0.5 THEN 'X'
        WHEN E.Desvio_Padrao / E.Media_Demanda BETWEEN 0.5 AND 1 THEN 'Y'
        ELSE 'Z'
    END AS Classificacao_XYZ
FROM
	Receita_Ordenada R
INNER JOIN	
	Estatisticas E
ON 
	R.Item_ID = E.Item_ID
ORDER BY 
    Classificacao_ABC, Classificacao_XYZ, E.Media_Demanda DESC;

