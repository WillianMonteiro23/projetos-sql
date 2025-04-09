# Tratamento de Dados: Passo a Passo

## 1. Criação do Banco de Dados
O primeiro passo foi criar e conecestar nesse banco de dados para receber a tabela com os dados a serem tratados.

```
CREATE DATABASE PREPARE_PROCESS_DB;
USE PREPARE_PROCESS_DB;
```

## 2. Criação da Tabela
Criamos uma tabela com todas as colunas no formato `VARCHAR(40)` para evitar possíveis erros durante a extração dos dados.

```
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
```

## 3. Importação de Dados
Utilizamos o comando `BULK INSERT` para carregar o arquivo `.csv` na tabela criada.

```
BULK INSERT 
	DirtyCafeSales
FROM 
	'C:\Users\monte\Documents\dirty_cafe_sales.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2
);
```

## 4. Visão Geral dos Dados
Analisamos o conjunto de dados para entender sua estrutura e verificar a integridade inicial.

```
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
```

## 5. Identificação de Inconsistências
Observamos inconsistências significativas em quase todas as colunas:
- Apenas a coluna `TransactionID` não possuía valores inconsistentes.
- As demais colunas apresentavam valores `NULL`, `ERROR` e `UNKNOWN`.

```
SELECT
	[Transaction_Id]
	,COUNT(*) AS Quantity
FROM 
	[PREPARE_PROCESS_DB].[dbo].[DirtyCafeSales]
WHERE [Transaction_Id] NOT LIKE 'TXN%' -- CASO ALGUM CAMPO ESTEJA FORA DO PADRÃO SERÁ MOSTRADO POR ESSE FILTRO
GROUP BY
	[Transaction_Id];

SELECT
	[Item]
	,COUNT(*) AS Quantity
FROM 
	[PREPARE_PROCESS_DB].[dbo].[DirtyCafeSales]
GROUP BY
	[Item];
```

## 6. Consulta Dinâmica de Inconsistências
Criamos uma consulta utilizando `Dynamic SQL` para identificar e observar todas as inconsistências no conjunto de dados. Isso proporcionou uma visão geral do problema.

```
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
```

## 7. Como Tratar os Erros?
Planejamos abordar o tratamento dos erros de uma forma **não agressiva**, para preservar ao máximo as informações úteis.

## 8. Exclusão Total: Abordagem Inicial
Optamos inicialmente por excluir todas as linhas com inconsistências. No entanto:
- Isso reduziu o conjunto de **10.000 registros para 3.089** — uma redução de quase **70%**.
- Concluímos que essa abordagem era muito destrutiva, pois resultaria na perda de informações potencialmente valiosas.

```
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
```

## 9. Criação de Cópia da Tabela
Criamos uma cópia da tabela original por boas práticas e segurança:
- Isso nos permitiu realizar alterações agressivas sem comprometer o conjunto original.
- Utilizamos transações (`BEGIN TRAN`) para garantir consistência, mesmo que o banco não estivesse em uso por outros usuários, correndo o risco de LOCK na tabela usada(a criação de uma tabela cópia auxilia nisso também).

```
SELECT
	*
INTO
	[DirtyCafeSalesCOPY]
FROM
	[PREPARE_PROCESS_DB].[dbo].[DirtyCafeSales];
```

## 10. Análise das Colunas e Possibilidades
### **TransactionID**
A única coluna sem inconsistências foi ignorada nos tratamentos seguintes.

### **Colunas Qualitativas**: `[Payment_Method]`, `[Location]`, `[Transaction_Date]`
Essas colunas foram tratadas padronizando inconsistências como `NULL`. 
- Isso facilitou a análise futura do impacto de valores ausentes no faturamento, sem comprometer a integridade do conjunto.

```
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
```

### **Colunas Numéricas**: `[Quantity]`, `[Price_Per_Unit]`, `[Total_Spent]`
Transformamos todos os valores inconsistentes em `NULL` para evitar problemas de coerção de tipo, preparando as colunas para tratamento e cálculos posteriores.

```
-- A coerção abaixo daria erro
UPDATE [DirtyCafeSalesCOPY]
SET [Quantity] = CAST([Quantity] AS INT)
```

```
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
```

## 11. Transformação de Tipos de Dados
Convertendo `[Quantity]`, `[Price_Per_Unit]` e `[Total_Spent]` para tipos numéricos, conseguimos realizar cálculos para inferir valores ausentes. Alteramos também o time de `[Transaction_Date]` de varchar para date.

```
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

```

## 12. Reconstrução de Dados Ausentes
### **`Price_Per_Unit`**
- Utilizamos uma tabela auxiliar com os valores unitários de cada produto para preencher valores ausentes na coluna.

```
SELECT DISTINCT
	[Item]
	,[Price_Per_Unit]
FROM
	[DirtyCafeSalesCOPY]
WHERE
	[Item] NOT IN ('ERROR','UNKNOWN') AND
	[Price_Per_Unit] IS NOT NULL;
```

- Resultado: Reduzimos de **533 valores `NULL` para 54**.

```
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
```

- Aplicamos a fórmula: `Total_Spent / Quantity = Price_Per_Unit` para preencher os valores restantes.
- Resultado: Reduzimos de **54 para apenas 6 valores `NULL`**.

```
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
```

### **`Item`**
- Utilizamos a coluna `Price_Per_Unit` para inferir valores ausentes na coluna `Item`.
  - Apenas produtos com preços unitários exclusivos foram considerados, excluindo itens como **Cake**, **Juice**, **Sandwich** e **Smoothie**, que possuem preços iguais.
- Resultado: Reduzimos de **969 valores `NULL` para 480**.

```
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
```

### **`Quantity` e `Total_Spent`**
- Usamos a correlação: `Quantity * Price_Per_Unit = Total_Spent` para tratar ambas as colunas.
- Resultados:
  - `Quantity`: **456 → 23 valores `NULL`**.

```
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
```

  - `Total_Spent`: **479 → 23 valores `NULL`**.

```
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
```
## 13. Exclusão de Linhas Irrelevantes
Excluímos **178 registros** que apresentavam inconsistências em praticamente todas as colunas, sendo incapazes de agregar valor às análises.
    - Conseguimos verificar as linhas irrelevantes no conjunto com o código abaixo.

```
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
---
```

    - Excluindo linhas irrelevantes no conjunto.

```
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
```

# Comparativo de Resultados

### **Conjunto Original: `DirtyCafeSales`**
| Coluna            | Total Registros | Inconsistências |
|--------------------|-----------------|-----------------|
| Transaction_Id     | 10.000          | 0               |
| Item               | 10.000          | 969             |
| Quantity           | 10.000          | 479             |
| Price_Per_Unit     | 10.000          | 533             |
| Total_Spent        | 10.000          | 502             |
| Payment_Method     | 10.000          | 3.178           |
| Location           | 10.000          | 3.961           |
| Transaction_Date   | 10.000          | 460             |

### **Tratamento Agressivo**
- Após a remoção de todas as inconsistências, sobraram apenas **3.089 registros** — abordagem muito destrutiva.

### **Conjunto Tratado: `DirtyCafeSalesCOPY`**
| Coluna            | Total Registros | Inconsistências |
|--------------------|-----------------|-----------------|
| Transaction_Id     | 9.822           | 0               |
| Item               | 9.822           | 394             |
| Quantity           | 9.822           | 10              |
| Price_Per_Unit     | 9.822           | 15              |
| Total_Spent        | 9.822           | 10              |
| Payment_Method     | 9.822           | 3.027           |
| Location           | 9.822           | 3.806           |
| Transaction_Date   | 9.822           | 381             |

---

# Conclusão
A diferença é clara:
- Reduzimos as inconsistências drasticamente, preservando ao máximo os registros úteis.
- Ao invés de excluir registros de forma agressiva, utilizamos correlações e inferências para preencher dados ausentes.
- Mantivemos apenas 178 linhas irrelevantes como excluídas, garantindo que o restante do conjunto permaneça rico em informações para análises futuras.

Mesmo com valores `NULL`, as colunas ainda oferecem dados relevantes para análise, como:
- Total vendido.
- Produtos mais vendidos.
- Análise temporal.
- Quantidade.
- Método de pagamento.
- Localização.

Essa abordagem garante que possamos extrair **insights valiosos** sem comprometer a integridade dos dados.