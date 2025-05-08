-- CRIANDO BANCO DE DADOS
CREATE DATABASE BRAZILIAN_ECOMMERCE_OLIST;

-- CONECTANDO AO BANCO
USE BRAZILIAN_ECOMMERCE_OLIST;

-- EXTRAÇÃO DAS TABELAS VIA IMPORT FLAT FILE

-- VISAO GERAL DAS TABELAS

-- ANALISE DE INCONSISTENCIAS olist_customers_dataset

SELECT TOP 5
	*
FROM
	BRAZILIAN_ECOMMERCE_OLIST.dbo.olist_customers_dataset;

-- TIPOS DAS COLUNAS TABELA
SELECT 
    COLUMN_NAME, 
    DATA_TYPE 
FROM 
    INFORMATION_SCHEMA.COLUMNS 
WHERE 
    TABLE_NAME = 'olist_customers_dataset';

-- EXISTE DUPLICADOS NA TABELA?
SELECT 
	COUNT(*) AS contagem,
	customer_id
FROM
	BRAZILIAN_ECOMMERCE_OLIST.dbo.olist_customers_dataset
GROUP BY 
	customer_id
HAVING
	COUNT(*) > 1;

-- EXISTEM VALORES NULL?
SELECT 
	customer_id
FROM
	BRAZILIAN_ECOMMERCE_OLIST.dbo.olist_customers_dataset
WHERE
	customer_id IS NULL;

-- ANALISANDO COLUNAS customer_city E customer_state
SELECT DISTINCT
	customer_city
FROM
	BRAZILIAN_ECOMMERCE_OLIST.dbo.olist_customers_dataset
WHERE
	customer_city <> TRIM(customer_city); -- SE EXISTIR ESPAÇOS NO NOME DA CIDADE CONSEGUIMOS OBSERVAR

SELECT DISTINCT
	customer_state
FROM
	BRAZILIAN_ECOMMERCE_OLIST.dbo.olist_customers_dataset
WHERE
	customer_state <> TRIM(customer_state); -- OBSERVANDO POSSIVEIS ESPAÇOS NOS ESTADOS

-- olist_order_items_dataset
SELECT TOP 5
	*
FROM
	BRAZILIAN_ECOMMERCE_OLIST.dbo.olist_order_items_dataset;

-- TIPOS DAS COLUNAS TABELA
SELECT 
    COLUMN_NAME, 
    DATA_TYPE 
FROM 
    INFORMATION_SCHEMA.COLUMNS 
WHERE 
    TABLE_NAME = 'olist_order_items_dataset';

-- ESSA TABELA PODE TER VALORES DUPLICADOS, JÁ QUE PODEMOS COMPRAR VARIOS PRODUTOS EM UM UNICO PEDIDO

-- EXISTEM VALORES NULL?
SELECT
	order_id,
	price,
	freight_value
FROM
	BRAZILIAN_ECOMMERCE_OLIST.dbo.olist_order_items_dataset
WHERE
	order_id IS NULL OR
	price IS NULL OR 
	freight_value IS NULL;

-- olist_order_payments_dataset
SELECT TOP 5
	*
FROM
	BRAZILIAN_ECOMMERCE_OLIST.dbo.olist_order_payments_dataset;

-- TIPOS DAS COLUNAS TABELA
SELECT 
    COLUMN_NAME, 
    DATA_TYPE 
FROM 
    INFORMATION_SCHEMA.COLUMNS 
WHERE 
    TABLE_NAME = 'olist_order_payments_dataset';

-- ESSA TABELA PERMITE VALORES DUPLICADOS VISTO QUE O CLIENTE PODE UTILIZAR MAIS DE UM METODO DE PAGAMENTO

-- EXSTEM VALORES NULL?
SELECT
	order_id,
	payment_installments,
	payment_value
FROM 
	BRAZILIAN_ECOMMERCE_OLIST.dbo.olist_order_payments_dataset
WHERE
	order_id IS NULL OR
	payment_installments IS NULL OR
	payment_value IS NULL

-- olist_order_reviews_dataset

SELECT TOP 5
	*
FROM
	BRAZILIAN_ECOMMERCE_OLIST.dbo.olist_order_reviews_dataset;

-- TIPOS DAS COLUNAS TABELA
SELECT 
    COLUMN_NAME, 
    DATA_TYPE 
FROM 
    INFORMATION_SCHEMA.COLUMNS 
WHERE 
    TABLE_NAME = 'olist_order_reviews_dataset';

-- ESSA TABELA PERMITE DUPLICADOS VISTO QUE UM CLIENTE PODE FAZER MAIS DE UMA AVALIAÇAO

-- EXISTEM VALORES NULL?
SELECT
	review_id,
	review_score
FROM 
	BRAZILIAN_ECOMMERCE_OLIST.dbo.olist_order_reviews_dataset
WHERE
	review_id IS NULL OR
	review_score IS NULL;

-- olist_products_dataset
SELECT TOP 5
	*
FROM 
	BRAZILIAN_ECOMMERCE_OLIST.dbo.olist_products_dataset;

-- TIPOS DAS COLUNAS TABELA
SELECT 
    COLUMN_NAME, 
    DATA_TYPE 
FROM 
    INFORMATION_SCHEMA.COLUMNS 
WHERE 
    TABLE_NAME = 'olist_products_dataset';

-- EXISTEM VALORES DUPLICADOS?
SELECT
	product_id,
	COUNT(product_id) AS contagem
FROM 
	BRAZILIAN_ECOMMERCE_OLIST.dbo.olist_products_dataset
GROUP BY
	product_id
HAVING
	COUNT(product_id) > 1;

-- ANALISANDO INCONSISTENCIAS product_category_name?
SELECT DISTINCT -- PODEMOS OBSERVAR CADA CATEGORIA DISTINTAMENTE
	product_category_name
FROM 
	BRAZILIAN_ECOMMERCE_OLIST.dbo.olist_products_dataset 

-- OBSERVANDO ESPAÇOS INCONSISTENTES NOS DADOS
SELECT DISTINCT
	product_category_name
FROM 
	BRAZILIAN_ECOMMERCE_OLIST.dbo.olist_products_dataset 
WHERE
	product_category_name != TRIM(product_category_name);

-- olist_sellers_dataset
SELECT TOP 5
	*
FROM 
	BRAZILIAN_ECOMMERCE_OLIST.dbo.olist_sellers_dataset;

-- TIPOS DAS COLUNAS TABELA
SELECT 
    COLUMN_NAME, 
    DATA_TYPE 
FROM 
    INFORMATION_SCHEMA.COLUMNS 
WHERE 
    TABLE_NAME = 'olist_sellers_dataset';

-- EXISTEM VALORES DUPLICADOS?
SELECT
	seller_id,
	COUNT(seller_id) AS contagem
FROM 
	BRAZILIAN_ECOMMERCE_OLIST.dbo.olist_sellers_dataset
GROUP BY
	seller_id
HAVING
	COUNT(seller_id) > 1;

-- OBSERVANDO ESPAÇOS INCONSISTENTES NOS DADOS
SELECT DISTINCT
	seller_city,
	seller_state
FROM 
	BRAZILIAN_ECOMMERCE_OLIST.dbo.olist_sellers_dataset 
WHERE
	seller_city != TRIM(seller_city) OR 
	seller_state != TRIM(seller_state) OR
	seller_city IS NULL OR
	seller_state IS NULL;

-- olist_orders_dataset
SELECT TOP 5
	*
FROM 
	BRAZILIAN_ECOMMERCE_OLIST.dbo.olist_orders_dataset;

-- TIPOS DAS COLUNAS TABELA
SELECT 
    COLUMN_NAME, 
    DATA_TYPE 
FROM 
    INFORMATION_SCHEMA.COLUMNS 
WHERE 
    TABLE_NAME = 'olist_orders_dataset';

SELECT
	order_id,
	COUNT(order_id) AS contagem
FROM 
	BRAZILIAN_ECOMMERCE_OLIST.dbo.olist_orders_dataset
GROUP BY
	order_id
HAVING
	COUNT(order_id) > 1;

-- OBSERVANDO INCONSISTENCIAS EM order_status
SELECT DISTINCT
	order_status
FROM 
	BRAZILIAN_ECOMMERCE_OLIST.dbo.olist_orders_dataset;

/*
  OBSERVAMOS TODOS OS DADOS DAS TABELAS E TODOS APRESENTAM BOAS CONDIÇÕES PARA ANALISE DOS DADOS
  APENAS TABELAS QUE PERMITEM DUPLICADOS EXISTEM DADOS DESSA FORMA, NÃO EXISTEM ESPAÇOS NOS DADOS,
  POUCOS DADOS NULL SAO OBSERVADOS E EM COLUNAS ESPECIFICAS QUE NÃO IRAO AFETAR AS ANALISES, OS DADOS
  SE ENCONTRAM NOS FORMATOS CORRETOS PARA EFETUARMOS AS ANALISES
*/
