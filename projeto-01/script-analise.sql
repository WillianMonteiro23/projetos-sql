-- Switching to the Danny's Dinner database

USE SQL_CHALLENGE
GO

-- What is the total amount each customer spent at the restaurant?

SELECT 
	S.CUSTOMER_ID, 
	SUM(M.PRICE) AS CUSTOMER_TOTAL 
FROM DANNYS_DINNER.SALES S
INNER JOIN DANNYS_DINNER.MENU M
ON S.PRODUCT_ID = M.PRODUCT_ID
GROUP BY CUSTOMER_ID
GO

-- Calculating how each customer impacts revenue

SELECT 
    CUSTOMER_ID,
    FORMAT(
        ROUND(
            (SUM(M.PRICE) * 1.0 / (SELECT SUM(M.PRICE) FROM DANNYS_DINNER.SALES S INNER JOIN DANNYS_DINNER.MENU M ON S.PRODUCT_ID = M.PRODUCT_ID) * 100), 
            1), 
        'N1'
    ) AS PERCENTAGE
FROM DANNYS_DINNER.SALES S 
INNER JOIN DANNYS_DINNER.MENU M ON S.PRODUCT_ID = M.PRODUCT_ID
GROUP BY CUSTOMER_ID
GO

--  How many days has each customer visited the restaurant?

SELECT 
	CUSTOMER_ID, 
	COUNT(DISTINCT(ORDER_DATE)) AS VISITED_DAYS 
FROM DANNYS_DINNER.SALES
GROUP BY CUSTOMER_ID
GO

-- What was the first item from the menu purchased by each customer?

WITH FIRST_ITEM AS
(
    SELECT 
        S.CUSTOMER_ID, 
        M.PRODUCT_NAME,
		order_date,
        DENSE_RANK() OVER(PARTITION BY S.CUSTOMER_ID ORDER BY S.ORDER_DATE) AS DS
    FROM DANNYS_DINNER.SALES S
    INNER JOIN DANNYS_DINNER.MENU M ON S.PRODUCT_ID = M.PRODUCT_ID
)

SELECT CUSTOMER_ID,order_date ,PRODUCT_NAME 
FROM FIRST_ITEM
WHERE DS = 1
GO

-- What is the most purchased item on the menu and how many times was it purchased by all customers?

SELECT TOP 1 
		COUNT(S.PRODUCT_ID) AS ITEM_PURCHASED_COUNT,
		M.PRODUCT_NAME 
FROM DANNYS_DINNER.SALES S
INNER JOIN DANNYS_DINNER.MENU M
ON S.PRODUCT_ID = M.PRODUCT_ID
GROUP BY PRODUCT_NAME
ORDER BY ITEM_PURCHASED_COUNT DESC
GO

-- Which item was the most popular for each customer?

WITH MOST_POPULAR_ITEM AS 
	(SELECT 
			S.CUSTOMER_ID, 
			COUNT(S.PRODUCT_ID) AS ITEM_PURCHASED_COUNT, 
			M.PRODUCT_NAME, 
			RANK() OVER(PARTITION BY CUSTOMER_ID ORDER BY COUNT(S.PRODUCT_ID) DESC) AS RANKING
	FROM DANNYS_DINNER.SALES S
	INNER JOIN DANNYS_DINNER.MENU M
	ON S.PRODUCT_ID = M.PRODUCT_ID
	GROUP BY CUSTOMER_ID, PRODUCT_NAME)

SELECT CUSTOMER_ID, PRODUCT_NAME, ITEM_PURCHASED_COUNT FROM MOST_POPULAR_ITEM
WHERE RANKING = 1
GO

-- Which item was purchased first by the customer after they became a member?

WITH FIRST_ITEM_AFTER_BECAME_MEMBER AS
	(SELECT 
			S.CUSTOMER_ID,
			M.PRODUCT_NAME,
			ORDER_DATE,
			JOIN_DATE,
			ROW_NUMBER() OVER(PARTITION BY S.CUSTOMER_ID ORDER BY ORDER_DATE) AS FIRST_ITEM
	FROM DANNYS_DINNER.SALES S
	INNER JOIN DANNYS_DINNER.MENU M
	ON S.PRODUCT_ID = M.PRODUCT_ID
	INNER JOIN DANNYS_DINNER.MEMBERS MB
	ON S.CUSTOMER_ID = MB.CUSTOMER_ID
	WHERE ORDER_DATE >= JOIN_DATE)

SELECT CUSTOMER_ID, ORDER_DATE ,JOIN_DATE, PRODUCT_NAME FROM FIRST_ITEM_AFTER_BECAME_MEMBER
WHERE FIRST_ITEM = 1
GO

-- Which item was purchased just before the customer became a member?

WITH FIRST_ITEM_BEFORE_BECAME_MEMBER AS
	(SELECT 
			S.CUSTOMER_ID, 
			M.PRODUCT_NAME, 
			DENSE_RANK() OVER(PARTITION BY S.CUSTOMER_ID ORDER BY ORDER_DATE DESC) AS RANKING 
	FROM DANNYS_DINNER.SALES S
	INNER JOIN DANNYS_DINNER.MENU M
	ON S.PRODUCT_ID = M.PRODUCT_ID
	INNER JOIN DANNYS_DINNER.MEMBERS MB
	ON S.CUSTOMER_ID = MB.CUSTOMER_ID
	WHERE ORDER_DATE < JOIN_DATE)

SELECT CUSTOMER_ID, PRODUCT_NAME FROM FIRST_ITEM_BEFORE_BECAME_MEMBER
WHERE RANKING = 1
GO

-- What is the total items and amount spent for each member before they became a member?

SELECT 
	S.CUSTOMER_ID, 
	COUNT(M.PRODUCT_ID) AS TOTAL_ITEMS, 
	SUM(M.PRICE) TOTAL_AMOUNT 
FROM DANNYS_DINNER.SALES S
INNER JOIN DANNYS_DINNER.MENU M
ON S.PRODUCT_ID = M.PRODUCT_ID
INNER JOIN DANNYS_DINNER.MEMBERS MB
ON S.CUSTOMER_ID = MB.CUSTOMER_ID
WHERE ORDER_DATE < JOIN_DATE
GROUP BY S.CUSTOMER_ID
GO

-- Total items and amount spent after becoming a member

SELECT 
    MB.CUSTOMER_ID,
    BEFORE_TOTAL.CUSTOMER_TOTAL AS TOTAL_BEFORE_MEMBERSHIP,
    AFTER_TOTAL.CUSTOMER_TOTAL  AS TOTAL_AFTER_MEMBERSHIP,
    (AFTER_TOTAL.CUSTOMER_TOTAL  - BEFORE_TOTAL.CUSTOMER_TOTAL) AS [DIFFERENCE]
FROM 
    DANNYS_DINNER.MEMBERS MB
LEFT JOIN (
    SELECT 
        S.CUSTOMER_ID, 
        SUM(M.PRICE) AS CUSTOMER_TOTAL 
    FROM DANNYS_DINNER.SALES S
    INNER JOIN DANNYS_DINNER.MENU M ON S.PRODUCT_ID = M.PRODUCT_ID
    WHERE S.ORDER_DATE < (SELECT JOIN_DATE FROM DANNYS_DINNER.MEMBERS WHERE CUSTOMER_ID = S.CUSTOMER_ID)
    GROUP BY S.CUSTOMER_ID
) BEFORE_TOTAL ON MB.CUSTOMER_ID = BEFORE_TOTAL.CUSTOMER_ID
LEFT JOIN (
    SELECT 
        S.CUSTOMER_ID, 
        SUM(M.PRICE) AS CUSTOMER_TOTAL 
    FROM DANNYS_DINNER.SALES S
    INNER JOIN DANNYS_DINNER.MENU M ON S.PRODUCT_ID = M.PRODUCT_ID
    WHERE S.ORDER_DATE >= (SELECT JOIN_DATE FROM DANNYS_DINNER.MEMBERS WHERE CUSTOMER_ID = S.CUSTOMER_ID)
    GROUP BY S.CUSTOMER_ID
) AFTER_TOTAL ON MB.CUSTOMER_ID = AFTER_TOTAL.CUSTOMER_ID;
GO
			
-- If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?

SELECT
	CUSTOMER_ID,
	SUM(CASE
			WHEN PRODUCT_NAME = 'sushi' THEN PRICE * 10 * 2
			ELSE PRICE * 10 
		END) AS POINTS
FROM DANNYS_DINNER.SALES S
INNER JOIN DANNYS_DINNER.MENU M
ON S.PRODUCT_ID = M.PRODUCT_ID
GROUP BY CUSTOMER_ID
GO

/* In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - 
how many points do customer A and B have at the end of January? */

WITH POINTS AS
	(SELECT 
			S.CUSTOMER_ID,
			S.ORDER_DATE,
			M.PRODUCT_NAME,
			M.PRICE,
			JOIN_DATE,
			DATEADD(DAY, 6, JOIN_DATE) AS LAST_DAY_FIRST_WEEK
	FROM DANNYS_DINNER.SALES S
	INNER JOIN DANNYS_DINNER.MENU M
	ON S.PRODUCT_ID = M.PRODUCT_ID
	INNER JOIN DANNYS_DINNER.MEMBERS MB
	ON S.CUSTOMER_ID = MB.CUSTOMER_ID)
SELECT
	CUSTOMER_ID,
	SUM(CASE
			WHEN PRODUCT_NAME = 'sushi' THEN PRICE * 10 * 2
			WHEN ORDER_DATE >= JOIN_DATE AND ORDER_DATE < LAST_DAY_FIRST_WEEK THEN PRICE * 10 * 2
			ELSE PRICE * 10
		END) AS POINTS
FROM POINTS
WHERE ORDER_DATE < '2021-02-01'
GROUP BY CUSTOMER_ID
GO

-- Bonus Questions

/*The following questions are related creating basic data tables that Danny and his team can use to 
quickly derive insights without needing to join the underlying tables using SQL.
Create a table with available data: customer_id,	order_date,	product_name,	price,	member*/

CREATE VIEW VW_BASIC_DATA_TABLE AS
SELECT 
	S.CUSTOMER_ID, 
	S.ORDER_DATE, 
	M.PRODUCT_NAME, 
	M.PRICE,
	(CASE
		WHEN S.CUSTOMER_ID = MB.CUSTOMER_ID AND ORDER_DATE >= JOIN_DATE THEN 'Y'
		ELSE 'N'
	END) AS MEMBER
FROM DANNYS_DINNER.SALES S
INNER JOIN DANNYS_DINNER.MENU M
ON S.PRODUCT_ID = M.PRODUCT_ID
FULL JOIN DANNYS_DINNER.MEMBERS MB
ON S.CUSTOMER_ID = MB.CUSTOMER_ID
GO

SELECT CUSTOMER_ID, ORDER_DATE, PRODUCT_NAME, MEMBER FROM VW_BASIC_DATA_TABLE
GO

-- Rank All The Things

/*Danny also requires further information about the ranking of customer products, but he purposely does 
not need the ranking for non-member purchases so he expects null ranking values for the records when customers 
are not yet part of the loyalty program.*/

SELECT 
	*,
	(CASE
		WHEN MEMBER = 'Y' THEN RANK() OVER(PARTITION BY CUSTOMER_ID, MEMBER ORDER BY ORDER_DATE)
		ELSE NULL
	END) AS RANKING
FROM VW_BASIC_DATA_TABLE
GO
