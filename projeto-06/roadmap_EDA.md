## EDA

**Verificando tipos das colunas**

```
SELECT 
    COLUMN_NAME, 
    DATA_TYPE 
FROM 
    INFORMATION_SCHEMA.COLUMNS 
WHERE 
    TABLE_NAME = 'Vendas';
```

**Verificando Inconsistências nas colunas**

```
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
```