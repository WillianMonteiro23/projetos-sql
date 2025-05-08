-- CONECTANDO AO BANCO
USE BRAZILIAN_ECOMMERCE_OLIST;

-- CRIAÇÃO DE QUERYS PARA POWER BI

-- TABELA FATO
-- fSales
CREATE VIEW fSales AS(
SELECT
	DISTINCT(od.order_id),
	od.order_status,
	od.order_purchase_timestamp,
	od.order_estimated_delivery_date,
	od.order_delivered_customer_date, 
	pd.payment_type,
	pd.payment_value,
	ord.review_score,
	cd.customer_id,
	prd.product_id,
	sd.seller_id
FROM olist_orders_dataset od
INNER JOIN olist_customers_dataset cd
ON od.customer_id = cd.customer_id
INNER JOIN olist_order_payments_dataset pd
ON od.order_id = pd.order_id
INNER JOIN olist_order_reviews_dataset ord
ON od.order_id = ord.order_id
INNER JOIN olist_order_items_dataset oid
ON od.order_id = oid.order_id
INNER JOIN olist_products_dataset prd
ON oid.product_id = prd.product_id
INNER JOIN olist_sellers_dataset sd
ON oid.seller_id = sd.seller_id);

-- TABELAS DIMENSÕES
--dCustomers
CREATE VIEW dCustomers AS(
SELECT DISTINCT
	customer_id,
	customer_city,
	customer_state
FROM
	olist_customers_dataset);

--dSellers
CREATE VIEW dSellers AS(
SELECT DISTINCT
	seller_id,
	seller_city,
	seller_state
FROM
	olist_sellers_dataset);

--dProducts
CREATE VIEW dProducts AS(
SELECT DISTINCT
	product_id,
	product_category_name
FROM
	olist_products_dataset);

