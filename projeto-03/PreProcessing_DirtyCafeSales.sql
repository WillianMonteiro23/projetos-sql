-- CRIAÇÃO BANCO DE DADOS
CREATE DATABASE PREPARE_PROCESS_DB;

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
SELECT TOP 100
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
HAVING -- EM AGRUPAMENTOS O FILTRO EM VEZ DE WHERE USAMOS HAVING
	COUNT(*) > 1;

/*NÃO HÁ VALORES DUPLICADOS*/

-- OBSERVANDO INCONSISTÊNCIAS(VALORES AUSENTES, ERROS DE DIGITAÇÃO, ...)
SELECT TOP 100 
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

-- VAMOS OBSERVAR MAIS AFUNDO CADA UMA DAS COLUNAS

-- SABEMOS QUE A COLUNA [Transaction_Id] POSSUI UM PADRÃO, COMEÇA SEMPRE COM TXN
-- A COLUNA [Transaction_Id] NÃO POSSUI INCONSISTÊNCIAS

SELECT
	[Transaction_Id]
	,COUNT(*) AS Quantity
FROM 
	[PREPARE_PROCESS_DB].[dbo].[DirtyCafeSales]
WHERE 
	[Transaction_Id] NOT LIKE 'TXN%' -- CASO ALGUM CAMPO ESTEJA FORA DO PADRÃO SERÁ MOSTRADO POR ESSE FILTRO
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

-- [Payment_Method]
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

-- TRATANDO INCONSISTÊNCIAS (MANEIRA AGRESSIVA)
/* ------------------ERRADA------------------- */
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

-- CRIANDO TABELA CÓPIA
SELECT
	*
INTO
	[DirtyCafeSalesCOPY]
FROM
	[PREPARE_PROCESS_DB].[dbo].[DirtyCafeSales];

-- TRATANDO COLUNAS [Payment_Method],[Location],[Transaction_Date]

-- [Payment_Method]
SELECT 
	[Payment_Method], 
	COUNT(*) 
FROM 
	[DirtyCafeSalesCOPY] 
GROUP BY 
	[Payment_Method];

BEGIN TRAN
UPDATE [DirtyCafeSalesCOPY]
SET [Payment_Method] = NULL
WHERE [Payment_Method] IN ('ERROR','UNKNOWN');
COMMIT TRAN

-- [Location]
SELECT
	[Location]
	,COUNT(*)
FROM 
	[DirtyCafeSalesCOPY]
GROUP BY
	[Location];

BEGIN TRAN
UPDATE [DirtyCafeSalesCOPY]
SET [Location] = NULL
WHERE [Location] IN ('ERROR','UNKNOWN');
COMMIT TRAN

-- [Transaction_Date]
SELECT 
	[Transaction_Date]
	,COUNT(*)
FROM
	[DirtyCafeSalesCOPY]
GROUP BY
	[Transaction_Date]
ORDER BY COUNT(*) DESC;

BEGIN TRAN
UPDATE [DirtyCafeSalesCOPY]
SET [Transaction_Date] = NULL
WHERE [Transaction_Date] IN ('ERROR','UNKNOWN');
COMMIT TRAN


-- NÃO CONSEGUIMOS FAZER A COERÇÃO PARA ENCONTRAR OS VALORES DAS DEMAIS COLUNAS
-- PRECISAMOS TRATAR TODAS AS INCONSISTENCIAS COMO NULL, PARA CONVERTERMOS OS DADOS EM TIPOS NUMÉRICOS
-- NULL NÃO GERA ERRO
UPDATE [DirtyCafeSalesCOPY]
SET [Quantity] = CAST([Quantity] AS INT)
/* Mensagem 245, Nível 16, Estado 1, Linha 245
Falha ao converter o varchar valor 'ERROR' para o tipo de dados int.
*/

-- [Quantity]
SELECT 
	[Quantity]
	,COUNT(*)
FROM
	[DirtyCafeSalesCOPY]
GROUP BY
	[Quantity];

BEGIN TRAN
UPDATE [DirtyCafeSalesCOPY]
SET [Quantity] = NULL
WHERE [Quantity] IN ('ERROR','UNKNOWN');
COMMIT TRAN

-- [Price_Per_Unit]
SELECT 
	[Price_Per_Unit]
	,COUNT(*)
FROM
	[DirtyCafeSalesCOPY]
GROUP BY
	[Price_Per_Unit];

BEGIN TRAN
UPDATE [DirtyCafeSalesCOPY]
SET [Price_Per_Unit] = NULL
WHERE [Price_Per_Unit] IN ('ERROR','UNKNOWN');
COMMIT TRAN

-- [Total_Spent]
SELECT 
	[Total_Spent]
	,COUNT(*)
FROM
	[DirtyCafeSalesCOPY]
GROUP BY
	[Total_Spent];

BEGIN TRAN
UPDATE [DirtyCafeSalesCOPY]
SET [Total_Spent] = NULL
WHERE [Total_Spent] IN ('ERROR','UNKNOWN');
COMMIT TRAN

-- [Item]
SELECT 
	[Item]
	,COUNT(*)
FROM
	[DirtyCafeSalesCOPY]
GROUP BY
	[Item];

BEGIN TRAN
UPDATE [DirtyCafeSalesCOPY]
SET [Item] = NULL
WHERE [Item] IN ('ERROR','UNKNOWN');
COMMIT TRAN

-- [Quantity],[Price_Per_Unit],[Total_Spent] COM ESSAS TRATADAS, COM SOMENTE VALORES NULL
-- PODEMOS CONVERTER OS DADOS DENTRO DESSAS COLUNAS EM TIPOS NUMÉRICOS(PARA CRIAR CALCULOS)

-- [Quantity]
SELECT 
	SUM([Quantity]) SUM_Quantity
FROM 
	[DirtyCafeSalesCOPY];
-- O COMANDO ACIMA DA ERRO EM UM PRIMEIRO MOMENTO

	/*Mensagem 8117, Nível 16, Estado 1, Linha 302
O tipo de dados de operando varchar é inválido para o operador sum.
*/

BEGIN TRAN
ALTER TABLE [DirtyCafeSalesCOPY]
ALTER COLUMN [Quantity] FLOAT;

ALTER TABLE [DirtyCafeSalesCOPY]
ALTER COLUMN [Price_Per_Unit] FLOAT;

ALTER TABLE [DirtyCafeSalesCOPY]
ALTER COLUMN [Total_Spent] FLOAT;

ALTER TABLE [DirtyCafeSalesCOPY]
ALTER COLUMN [Transaction_Date] DATE;

EXEC sp_help 'DirtyCafeSalesCOPY'; -- stored procedure embutida que fornece informações detalhadas sobre a tabela especificada
COMMIT TRAN

SELECT * FROM [DirtyCafeSalesCOPY];

-- EXTRAÇÃO TABELA PRODUTOS/PRECO UNITARIO
SELECT DISTINCT
	[Item]
	,[Price_Per_Unit]
FROM
	[DirtyCafeSalesCOPY]
WHERE
	[Item] NOT IN ('ERROR','UNKNOWN') AND
	[Price_Per_Unit] IS NOT NULL;

-- DE -> PARA  DE [Price_Per_Unit]: COM O NOME DO ITEM CONSEGUIMOS DETERMINAR O Price_Per_Unit
-- ATUALIZANDO VALORES [Price_Per_Unit]

SELECT
	[Price_Per_Unit]
	,COUNT(*)
FROM
	[DirtyCafeSalesCOPY]
GROUP BY 
	[Price_Per_Unit];

-- NULL	533 NA COLUNA [Price_Per_Unit] ANTES DO TRATAMENTO

BEGIN TRAN
UPDATE [DirtyCafeSalesCOPY]
SET [Price_Per_Unit] = 
    CASE 
        WHEN  [Item] = 'Coffee' THEN 2
		WHEN [Item] = 'Tea' THEN (1.5)
        WHEN [Item] = 'Cookie' THEN 1
		WHEN  [Item] = 'Salad' THEN 5
		WHEN  [Item] = 'Sandwich' THEN 4
		WHEN  [Item] = 'Smoothie' THEN 4
		WHEN  [Item] = 'Cake' THEN 3
		WHEN  [Item] = 'Juice' THEN 3
        ELSE [Price_Per_Unit] -- Mantém os outros valores inalterados
	END;
COMMIT TRAN
-- NULL	54 NA COLUNA [Price_Per_Unit] DEPOIS DO TRATAMENTO ACIMA

-- TRATANDO PRICE_PER_UNIT COM TOTAL/QUANTIDADE
-- ABAIXO PODEMOS OBSERVAR O COMANDO QUE DEMONSTRA QUE EM 48 REGISTROS PODEMOS TRATAR COM CORRELAÇÃO
SELECT
	* 
FROM 
	[DirtyCafeSalesCOPY] 
WHERE
	[Price_Per_Unit] IS NULL AND
	[Total_Spent] IS NOT NULL AND
	[Quantity] IS NOT NULL;

BEGIN TRAN
UPDATE [DirtyCafeSalesCOPY]
SET [Price_Per_Unit] = 
    CASE
        WHEN  
			[Price_Per_Unit] IS NULL AND
			[Total_Spent] IS NOT NULL AND
			[Quantity] IS NOT NULL 
			THEN ([Total_Spent] / [Quantity])
        ELSE [Price_Per_Unit] -- Mantém os outros valores inalterados
	END;
COMMIT TRAN

-- DE -> PARA DE [Item] : CONSEGUIMOS CORRELACIONAR OS PRODUTOS COFFE, TEA, SALAD E COOKIE POIS TEM VALORES DISTINTOS
SELECT
	[Item]
	,COUNT(*)
FROM
	[DirtyCafeSalesCOPY]
GROUP BY 
	[Item];

-- NULL	969 NA COLUNA ITEM

BEGIN TRAN
UPDATE [DirtyCafeSalesCOPY]
SET [Item] = 
    CASE 
        WHEN  [Price_Per_Unit] = 2 THEN 'Coffee'
		WHEN [Price_Per_Unit] = (1.5)  THEN 'Tea'
        WHEN [Price_Per_Unit] = 1 THEN 'Cookie'
		WHEN  [Price_Per_Unit] = 5 THEN 'Salad'
        ELSE [Item] -- Mantém os outros valores inalterados
	END;
COMMIT TRAN

-- TRATANDO COLUNA QUANTITY
-- OBSERVANDO ABAIXO CONSEGUIMOS ENTENDER QUE EXISTEM 456 LINHAS QUE PODEMOS TRATAR CORRELACIONANDO COLUNAS
SELECT
	[Quantity]
	,[Price_Per_Unit]
	,[Total_Spent]
FROM
	[DirtyCafeSalesCOPY]
WHERE
	[Quantity] IS NULL AND
	[Price_Per_Unit] IS NOT NULL AND
	[Total_Spent] IS NOT NULL;

BEGIN TRAN
UPDATE [DirtyCafeSalesCOPY]
SET [Quantity] =
	CASE
		WHEN
			[Quantity] IS NULL AND
			[Price_Per_Unit] IS NOT NULL AND
			[Total_Spent] IS NOT NULL
			THEN ([Total_Spent] / [Price_Per_Unit])
			ELSE [Quantity]
		END;
COMMIT TRAN
-- DE 456 FOMOS PARA APENAS 23 VALORES NULL

-- TRATANDO TOTAL_SPENT
-- OBSERVANDO ABAIXO CONSEGUIMOS ENTENDER QUE EXISTEM 479 LINHAS QUE PODEMOS TRATAR CORRELACIONANDO COLUNAS
SELECT
	[Quantity]
	,[Price_Per_Unit]
	,[Total_Spent]
FROM
	[DirtyCafeSalesCOPY]
WHERE
	[Total_Spent] IS NULL AND
	[Price_Per_Unit] IS NOT NULL AND
	[Quantity] IS NOT NULL;

BEGIN TRAN
UPDATE [DirtyCafeSalesCOPY]
SET [Total_Spent] =
	CASE
		WHEN [Total_Spent] IS NULL AND
		[Price_Per_Unit] IS NOT NULL AND
		[Quantity] IS NOT NULL
		THEN ([Quantity] * [Price_Per_Unit])
		ELSE [Total_Spent]
	END;
COMMIT TRAN
-- DE 479 FOMOS PARA APENAS 23 VALORES NULL

-- VERIFICANDO SE EXISTEM COLUNAS COMPLEMENTE IRRELEVANTES
-- COLUNAS QUE POSSUEM TANTAS INCONSISTENCIAS QUE NÃO CONSEGUIMOS, IREMOS REMOVE-LAS
SELECT 
	*
FROM 
	[DirtyCafeSalesCOPY]
WHERE (
    CASE 
        WHEN [Transaction_Id] IS NULL THEN 1 ELSE 0 END +
        CASE 
        WHEN [Item] IS NULL THEN 1 ELSE 0 END +
        CASE 
        WHEN [Quantity] IS NULL THEN 1 ELSE 0 END +
        CASE 
        WHEN [Price_Per_Unit] IS NULL THEN 1 ELSE 0 END +
        CASE 
        WHEN [Total_Spent] IS NULL THEN 1 ELSE 0 END +
		CASE 
        WHEN [Payment_Method] IS NULL THEN 1 ELSE 0 END +
		CASE 
        WHEN [Location] IS NULL THEN 1 ELSE 0 END +
		CASE 
        WHEN [Transaction_Date] IS NULL THEN 1 ELSE 0 
		END -- Adicione mais colunas conforme necessário
    ) >= 3;

BEGIN TRAN
DELETE FROM [DirtyCafeSalesCOPY]
WHERE (
    CASE 
        WHEN [Transaction_Id] IS NULL THEN 1 ELSE 0 END +
        CASE 
        WHEN [Item] IS NULL THEN 1 ELSE 0 END +
        CASE 
        WHEN [Quantity] IS NULL THEN 1 ELSE 0 END +
        CASE 
        WHEN [Price_Per_Unit] IS NULL THEN 1 ELSE 0 END +
        CASE 
        WHEN [Total_Spent] IS NULL THEN 1 ELSE 0 END +
		CASE 
        WHEN [Payment_Method] IS NULL THEN 1 ELSE 0 END +
		CASE 
        WHEN [Location] IS NULL THEN 1 ELSE 0 END +
		CASE 
        WHEN [Transaction_Date] IS NULL THEN 1 ELSE 0 
		END -- Adicione mais colunas conforme necessário
    ) >= 3;
COMMIT TRAN


-- OBSERVANDO AS INCONSISTENCIAS DO CONJUNTO DE DADOS
DECLARE @tableName NVARCHAR(MAX) = 'DirtyCafeSalesCOPY'; -- Nome da tabela
DECLARE @schemaName NVARCHAR(MAX) = 'dbo'; -- Esquema da tabela
DECLARE @sql NVARCHAR(MAX);

SET @sql = '';

-- Obter as colunas da tabela
SELECT @sql = @sql + 
    'SELECT ''' + COLUMN_NAME + ''' AS Coluna, ' +
    'COUNT(*) AS Total, ' +
    'SUM(CASE WHEN [' + COLUMN_NAME + '] IS NULL THEN 1 ELSE 0 END) AS Inconsistencias ' +
    'FROM [' + @schemaName + '].[' + @tableName + '] UNION ALL '
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = @tableName AND TABLE_SCHEMA = @schemaName;

-- Remover o último "UNION ALL"
SET @sql = LEFT(@sql, LEN(@sql) - 10);

-- Executar o script dinâmico
EXEC sp_executesql @sql;

