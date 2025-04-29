## Análises Realizadas

**Faturamento Bruto Geral**

```
SELECT
	ROUND(SUM(QtdItens * ValorUnitario),2) AS [Faturamento Bruto]
FROM
	[MARKETX].[dbo].[Vendas];
```

**Total de Itens Vendidos**

```
SELECT
	SUM(QtdItens) AS [Total Itens Vendidos]
FROM
	[MARKETX].[dbo].[Vendas];
```

**Top Vendedores por Quantidade Vendida e Top Vendedores por Faturamento**

```
-- quantidade vendida
SELECT
	Vendedor,
	SUM(QtdItens) AS [Total Itens Vendidos] 
FROM
	[MARKETX].[dbo].[Vendas]
GROUP BY Vendedor
ORDER BY SUM(QtdItens) DESC;

-- faturamento
SELECT
	Vendedor,
	ROUND(SUM(QtdItens * ValorUnitario),2) AS [Faturamento Bruto] 
FROM
	[MARKETX].[dbo].[Vendas]
GROUP BY Vendedor
ORDER BY SUM(QtdItens * ValorUnitario) DESC;
```

**Faturamento por Equipe de Vendas**

```
SELECT
	[Equipe Vendas],
	ROUND(SUM(QtdItens * ValorUnitario),2) AS [Faturamento Bruto] 
FROM
	[MARKETX].[dbo].[Vendas]
GROUP BY [Equipe Vendas]
ORDER BY SUM(QtdItens * ValorUnitario) DESC;
```

**Influência de cada equipe de vendas no faturamento**

```
WITH Influencia_Equipe AS (
	SELECT DISTINCT
		[Equipe Vendas],
		SUM(QtdItens * ValorUnitario) OVER() AS Faturamento_Total,
		SUM(QtdItens * ValorUnitario) OVER(PARTITION BY [Equipe Vendas]) AS Faturamento_Equipe
	FROM
		[MARKETX].[dbo].[Vendas]
)
SELECT
	[Equipe Vendas],
	(Faturamento_Equipe / Faturamento_Total) * 100 AS '%Faturamento'
FROM
	Influencia_Equipe
ORDER BY
	(Faturamento_Equipe / Faturamento_Total) * 100 DESC;
```

**Análise ABC de Produtos**

```
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
```