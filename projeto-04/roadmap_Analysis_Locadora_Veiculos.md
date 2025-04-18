# Análise passo a passo : Respondendo as perguntas de negócio

*As análises serão feitas através das views `VW_Rastreador` e `VW_Clients`, pois os dados estão limpos e processados dentro nelas*

-  **Total de clientes?**

```
SELECT 
	COUNT(DISTINCT(ID)) AS CONT_CLIENTES_VW_Clients
FROM
	VW_Clients

SELECT 
	COUNT(DISTINCT(ID_CLIENTE)) AS CONT_CLIENTES_VW_Rastreador
FROM
	VW_Rastreador
```

-  **Existem clientes não cadastrados? Se sim quais?**

```
/* EXISTEM CLIENTES QUE NÃO ESTÃO CADASTRADOSS! */

-- QUAIS CLIENTES NÃO ESTÃO CADASTRADOS?
SELECT
	ID_CLIENTE
FROM
	VW_Rastreador
WHERE
	ID_CLIENTE NOT IN
					(SELECT 
						C.ID
					FROM
						VW_Clients C
					JOIN VW_Rastreador R
					ON C.ID = R.ID_CLIENTE)
;

/*PARA TRATAR ESSE ERRO TEMOS QUE CADASTRAR OS VALORES DIRETAMENTE NA dbo.CLIENTES */

SELECT
	*
FROM
	[LOCADORA_VEICULOS].[dbo].[Clientes];

-- TRATANDO CLIENTES NAO CADASTRADOS
BEGIN TRAN
INSERT INTO [LOCADORA_VEICULOS].[dbo].[Clientes] (ID)
SELECT
	ID_CLIENTE
FROM
	VW_Rastreador
WHERE
	ID_CLIENTE NOT IN
					(SELECT 
						C.ID
					FROM
						VW_Clients C
					JOIN VW_Rastreador R
					ON C.ID = R.ID_CLIENTE)
;
COMMIT TRAN

/* 
	MESMO QUE A ÚNICA INFORMAÇÃO SEJAM OS ID's A TABELA DE REGISTRO DE CLIENTE FICA COMPLETA,
	SERIA NECESSÁRIO BUSCAR DE OUTRAS FORMAS, PARA PREENCHER CORRETAMENTE A TABELA DIMENSAO.
	NESSE CASO TEMOS PROBLEMAS DE LIMITAÇÃO DO CONJUNTO DE DADOS
*/
```

-  **Faturamento total?**

```
SELECT
	FORMAT(SUM(R.VALOR_LOCAÇAO),'C','pt-Br') AS FATURAMENTO_TOTAL
FROM
	VW_Rastreador R; -- NOMEAMOS A VIEW PARA ENCONTRAR A COLUNA DE VALOR_LOCAÇAO MAIS FACILMENTE

/* FATURAMNETO_TOTAL = R$ 78.594,00*/
```

-  **Percentual de clientes inadimplentes?**

```
-- Declarando variáveis
DECLARE @TOTAL_CLIENTES DECIMAL(5,1)
DECLARE @CLIENTES_NAOPAGO DECIMAL(5,1)
DECLARE @PERCENTUAL_INADIMPLENTES DECIMAL(5,2)

-- Atribuindo valores
SELECT 
	@CLIENTES_NAOPAGO = COUNT(ID_CLIENTE)
FROM 
	VW_Rastreador 
WHERE 
	SITUAÇAO_CADASTRAL = 'NÃO PAGO'

SELECT 
	@TOTAL_CLIENTES = COUNT(ID_CLIENTE)
FROM 
	VW_Rastreador

SET @PERCENTUAL_INADIMPLENTES = (@CLIENTES_NAOPAGO / @TOTAL_CLIENTES) * 100

-- Usando variáveis
SELECT CONVERT(NVARCHAR(10), @PERCENTUAL_INADIMPLENTES) + '%' AS PERCENTUAL_CLIENTES_INADIMPLENTES;

/* PERCENTUAL CLIENTES INADIMPLENTES = 23.33%*/
```

-  **Recebíveis inadimplentes?**

```
SELECT
	FORMAT(SUM(R.VALOR_LOCAÇAO),'C','pt-Br') AS TOTAL_INADIMPLENTE
FROM
	VW_Rastreador R
WHERE 
	R.SITUAÇAO_CADASTRAL = 'NÃO PAGO';

/* RECEBÍVEIS INADIMPLENTES = R$ 18.860,00 */
```

-  **Faturamento ao longo dos anos?**

```
SELECT
	YEAR(R.ANO) AS ANO,
	FORMAT(SUM(R.VALOR_LOCAÇAO),'C','pt-Br') AS FATURAMENTO_TOTAL
FROM
	VW_Rastreador R
GROUP BY
	YEAR(R.ANO)
ORDER BY
	(SUM(R.VALOR_LOCAÇAO)) DESC;

/* FATURAMENTO AO LONGO DOS ANOS
	2015	R$ 34.872,00
	2019	R$ 20.016,00
	2016	R$ 16.538,00
	2014	R$ 3.874,00
	2017	R$ 3.294,00
*/
```

-  **Marcas mais locadas?**

```
SELECT
	R.MARCA,
	COUNT(R.ID_CLIENTE) AS QUANTIDADE
FROM
	VW_Rastreador R
GROUP BY
	R.MARCA
ORDER BY
	QUANTIDADE DESC;

/* MARCAS MAIS LOCADAS 
	MARCA	11
	TOYOTA	4
	VOLKSWAGEN	4
	RENAULT	2
	CHEVROLET	2
	FIAT	2
	FORD	2
	LAND_ROVER	2
	KIA	1
*/
```
### PROBLEMA! Pois a marca mais locada é justamente a marca que não foi registrada, perdemos informação relevante! Mais um caso que abrange o limite dos nossos dados

-  **Cidades mais locatárias?**

```
SELECT
	C.CIDADE,
	COUNT(R.ID_CLIENTE) AS QUANTIDADE
FROM
	VW_Rastreador R
INNER JOIN VW_Clients C
ON R.ID_CLIENTE = C.ID
GROUP BY
	C.CIDADE
ORDER BY
	QUANTIDADE DESC;

/*	CIDADES MAIS LOCATÁRIAS
	OSASCO	11
	SÃO PAULO	9
	BARUERI	7
*/
```

-  **Top 5 clientes (com maior valor total de locação)?**

```
SELECT TOP 5
	C.NOME,
	FORMAT(SUM(R.VALOR_LOCAÇAO),'C','pt-Br') AS TOTAL_GASTO
FROM
	VW_Rastreador R
INNER JOIN VW_Clients C
ON R.ID_CLIENTE = C.ID
GROUP BY
	C.NOME
ORDER BY
	SUM(R.VALOR_LOCAÇAO) DESC;

/* TOP 5 CLIENTES(CLIENTES COM MAIOR VALOR TOTAL DE LOCAÇÃO)
	Daniele	R$ 19.748,00
	Pietro	R$ 11.284,00
	Thomas	R$ 10.574,00
	Augusto	R$ 7.396,00
	Nathan	R$ 4.778,00
*/
```

-  **Tabela com nome, marca, modelo, valor de locação e ano?**

```
SELECT
	C.NOME,
	R.MARCA,
	R.MODELO,
	FORMAT(R.VALOR_LOCAÇAO,'C','pt-Br') AS VALOR_LOCACAO,
	YEAR(ANO) AS ANO
FROM
	VW_Rastreador R
INNER JOIN VW_Clients C
ON R.ID_CLIENTE = C.ID
```

<div align='center'>
  <img src="https://github.com/WillianMonteiro23/projetos-sql/blob/main/projeto-04/images/12.png" width="50%"/>
</div>