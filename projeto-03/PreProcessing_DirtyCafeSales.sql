-- CRIAÇÃO BANCO DE DADOS
CREATE DATABASE "PREPARE_PROCESS_DB";

-- INDICANDO O BANCO DE DADOS QUE SERA USADO
USE PREPARE_PROCESS_DB;

-- CRIAÇÃO DE TABELA PARA RECEBER DADOS
CREATE TABLE DirtyCafeSales(
	Transaction_Id VARCHAR(40),
	Item VARCHAR(40),
	Quantity VARCHAR(40),
	Price_Per_Unit VARCHAR(40),
	Total_Spent VARCHAR(40),
	Payment_Method VARCHAR(40),
	Location VARCHAR(40),
	Transaction_Date VARCHAR(40)
);

-- EXTRAÇÃO DOS DADOS DO ARQUIVO .csv
BULK INSERT 
	DirtyCafeSales
FROM 
	'C:\Users\monte\Documents\ANÁLISE DE DADOS\DADOS SUJOS PARA TREINAMENTO\VENDAS DE CAFE - KAGGLE\dirty_cafe_sales.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2
);

-- TRATAMENTO DOS DADOS
SELECT TOP 1000 
	[Transaction_Id]
	,[Item]
	,[Quantity]
    ,[Price_Per_Unit]
    ,[Total_Spent]
    ,[Payment_Method]
    ,[Location]
    ,[Transaction_Date]
 FROM 
[PREPARE_PROCESS_DB].[dbo].[DirtyCafeSales];

-- OBSERVANDO VALORES DUPLICADOS ATRAVÉS DA COLUNA IDENTIFICADORA(Transaction_Id)
SELECT 
	[Transaction_Id], COUNT(*)
FROM 
	[PREPARE_PROCESS_DB].[dbo].[DirtyCafeSales]
GROUP BY 
	[Transaction_Id]
HAVING 
	COUNT(*) > 1;

/*NÃO HÁ VALORES DUPLICADOS*/

-- OBSERVANDO INCONSISTÊNCIAS(VALORES AUSENTES, ERROS DE DIGITAÇÃO, ...)
SELECT TOP 1000 
	[Transaction_Id]
	,[Item]
	,[Quantity]
    ,[Price_Per_Unit]
    ,[Total_Spent]
    ,[Payment_Method]
    ,[Location]
    ,[Transaction_Date]
 FROM 
[PREPARE_PROCESS_DB].[dbo].[DirtyCafeSales];

-- É POSSÍVEL OBSERVAR POR ALTO QUE A TABELA POSSUI MUITOS VALORES INCONSISTENTES

-- VAMOS OBSERVAR MAIS AFUNDO CADA UMA DAZ TABELAS

-- A COLUNA [Transaction_Id] NÃO POSSUI INCONSISTÊNCIAS
SELECT 
	[Transaction_Id]
	,COUNT(*) AS Quantity
FROM 
	[PREPARE_PROCESS_DB].[dbo].[DirtyCafeSales]
GROUP BY
	[Transaction_Id];

-- TODAS AS DEMAIS COLUNAS TEM INCONSISTÊNCIAS ('ERROR','UNKNOWN',NULL)
-- [Item] 
SELECT
	[Item]
	,COUNT(*) AS Quantity
FROM 
	[PREPARE_PROCESS_DB].[dbo].[DirtyCafeSales]
GROUP BY
	[Item];

-- [Quantity]
SELECT
	[Quantity]
	,COUNT(*) AS Quantity
FROM 
	[PREPARE_PROCESS_DB].[dbo].[DirtyCafeSales]
GROUP BY
	[Quantity];

-- [Price_Per_Unit]
SELECT
	[Price_Per_Unit]
	,COUNT(*) AS Quantity
FROM 
	[PREPARE_PROCESS_DB].[dbo].[DirtyCafeSales]
GROUP BY
	[Price_Per_Unit];

-- [Total_Spent]
SELECT
	[Total_Spent]
	,COUNT(*) AS Quantity
FROM 
	[PREPARE_PROCESS_DB].[dbo].[DirtyCafeSales]
GROUP BY
	[Total_Spent];

-- [Total_Spent]
SELECT
	[Payment_Method]
	,COUNT(*) AS Quantity
FROM 
	[PREPARE_PROCESS_DB].[dbo].[DirtyCafeSales]
GROUP BY
	[Payment_Method];

--[Location]
SELECT
	[Location]
	,COUNT(*) AS Quantity
FROM 
	[PREPARE_PROCESS_DB].[dbo].[DirtyCafeSales]
GROUP BY
	[Location];

-- [Transaction_Date]
SELECT
	[Transaction_Date]
	,COUNT(*) AS Quantity
FROM 
	[PREPARE_PROCESS_DB].[dbo].[DirtyCafeSales]
GROUP BY
	[Transaction_Date]
ORDER BY [Transaction_Date] ASC;

-- PODEMOS OBSERVAR A QUANTIDADE DE INCONSISTENCIAS DENTRO DA TABELA ABAIXO
DECLARE @tableName NVARCHAR(MAX) = 'DirtyCafeSales'; -- Nome da tabela
DECLARE @schemaName NVARCHAR(MAX) = 'dbo'; -- Esquema da tabela
DECLARE @sql NVARCHAR(MAX);

SET @sql = '';

-- Obter as colunas da tabela
SELECT @sql = @sql + 
    'SELECT ''' + COLUMN_NAME + ''' AS Coluna, ' +
    'COUNT(*) AS Total, ' +
    'SUM(CASE WHEN [' + COLUMN_NAME + '] IN (''ERROR'', ''UNKNOWN'') OR [' + COLUMN_NAME + 
	'] IS NULL THEN 1 ELSE 0 END) AS Inconsistencias ' +
    'FROM [' + @schemaName + '].[' + @tableName + '] UNION ALL '
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = @tableName AND TABLE_SCHEMA = @schemaName;

-- Remover o último "UNION ALL"
SET @sql = LEFT(@sql, LEN(@sql) - 10);

-- Executar o script dinâmico
EXEC sp_executesql @sql;

/* UTILIZAMOS SELECT DISTINCT EM UM PRIMEIRO MOMENTO PARA PODERMOS OBSERVAR AS INCONSISTENCIAS
TANTO ERROS, DESCONHECIDOS, AUSENTES QUANTO INCONSISTÊNCIAS DE ERRO DE DIGITAÇÃO, ESPAÇOS
DESNCESSÁRIOS...*/

-- TRATANDO INCONSISTÊNCIAS

SELECT *
FROM [PREPARE_PROCESS_DB].[dbo].[DirtyCafeSales]
WHERE NOT (
    [Item] IN ('ERROR', 'UNKNOWN') OR [Item] IS NULL OR
    [Quantity] IN ('ERROR', 'UNKNOWN') OR [Quantity] IS NULL OR
    [Price_Per_Unit] IN ('ERROR', 'UNKNOWN') OR [Price_Per_Unit] IS NULL OR
	[Total_Spent] IN ('ERROR', 'UNKNOWN') OR [Total_Spent] IS NULL OR
	[Payment_Method] IN ('ERROR', 'UNKNOWN') OR [Payment_Method] IS NULL OR
	[Location] IN ('ERROR', 'UNKNOWN') OR [Location] IS NULL OR
	[Transaction_Date] IN ('ERROR', 'UNKNOWN') OR [Transaction_Date] IS NULL
);

-- CRIAÇÃO DE VIEW
-- TRATANDO TIPOS E INCONSISTÊNCIAS DE MANEIRA NÃO AGRESSIVA(SEM ALTERAR A BASE DE DADOS)
CREATE VIEW VW_FilteredDirtyCafeSales AS
SELECT
	[Transaction_Id]
	,[Item]
	,CAST([Quantity] AS FLOAT) AS Quantity
    ,CAST([Price_Per_Unit] AS FLOAT) AS Price_Per_Unit
    ,CAST([Total_Spent] AS FLOAT) AS Total_Spent
    ,[Payment_Method]
    ,[Location]
    ,CAST([Transaction_Date] AS DATE) AS Transaction_Date
FROM [PREPARE_PROCESS_DB].[dbo].[DirtyCafeSales]
WHERE NOT (
    [Item] IN ('ERROR', 'UNKNOWN') OR [Item] IS NULL OR
    [Quantity] IN ('ERROR', 'UNKNOWN') OR [Quantity] IS NULL OR
    [Price_Per_Unit] IN ('ERROR', 'UNKNOWN') OR [Price_Per_Unit] IS NULL OR
    [Total_Spent] IN ('ERROR', 'UNKNOWN') OR [Total_Spent] IS NULL OR
    [Payment_Method] IN ('ERROR', 'UNKNOWN') OR [Payment_Method] IS NULL OR
    [Location] IN ('ERROR', 'UNKNOWN') OR [Location] IS NULL OR
    [Transaction_Date] IN ('ERROR', 'UNKNOWN') OR [Transaction_Date] IS NULL
);