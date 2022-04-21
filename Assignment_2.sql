

USE SampleRetail

CREATE VIEW [CUSTOMER_PRODUCT]  -- Burada Customer_id, First_name, Last_name sütunlarýný bir tabloda create ettik
AS                            -- Ama product_name i '2TB Red 5400 rpm SATA III 3.5 Internal NAS HDD' olanlarý sorgulattýk

SELECT	distinct D.customer_id, D.first_name, D.last_name
FROM	product.product A, sale.order_item B, sale.orders C, sale.customer D
WHERE	A.product_id=B.product_id
AND		B.order_id = C.order_id
AND		C.customer_id = D.customer_id
AND		A.product_name = '2TB Red 5400 rpm SATA III 3.5 Internal NAS HDD'

SELECT * FROM [dbo].[CUSTOMER_PRODUCT]



create view [First_pr] -- Daha sonra [First_pr] adýnda bizden istenilen First_product sütununu create ettik
AS                     -- Ama product_name i 'Polk Audio - 50 W Woofer - Black' olanlarý sorgulattýk

SELECT  C.customer_id AS First_product
FROM	product.product A, [sale].[order_item] B, [sale].[orders] C 
WHERE	B.product_id = 13
AND     B.order_id = C.order_id
AND		A.product_name = 'Polk Audio - 50 W Woofer - Black'


create view [Second_pr] -- Burada da [Second_pr] adýnda bizden istenilen Second_product sütununu Create ettik
AS						-- Ama product_name i 'SB-2000 12 500W Subwoofer (Piano Gloss Black)' olanlarý sorgulattýk 

SELECT  C.customer_id AS Second_product
FROM	product.product A, [sale].[order_item] B, [sale].[orders] C 
WHERE	B.product_id = 21
AND     B.order_id = C.order_id
AND		A.product_name = 'SB-2000 12 500W Subwoofer (Piano Gloss Black)'

create view [Third_pr] -- Burada isr [Third_pr] adýnda bizden istenilen Third_product sütununu Create ettik
AS					   -- Ama product_name i 'Virtually Invisible 891 In-Wall Speakers (Pair)' olanlarý sorgulattýk

SELECT  C.customer_id AS Third_product
FROM	product.product A, [sale].[order_item] B, [sale].[orders] C 
WHERE	B.product_id = 16
AND     B.order_id = C.order_id
AND		A.product_name = 'Virtually Invisible 891 In-Wall Speakers (Pair)'


----------- Sütunlarý birbirine baðlama bölümü ------------


CREATE VIEW [Table_0] -- Daha sonra ise yukarýda 4 tane Create ettiðimiz VIEW lar [CUSTOMER_PRODUCT], [First_pr], [Second_pr], [Third_pr] 
AS                    -- Bu 4 VIEW i birbirlerine baðladýk

SELECT *
FROM [CUSTOMER_PRODUCT] A
LEFT JOIN [First_pr] B
ON A.customer_id = B.First_product
LEFT JOIN [Second_pr] C
ON A.customer_id = C.Second_product
LEFT JOIN [Third_pr] D
ON A.customer_id = D.Third_product


CREATE VIEW [Table_null] -- Burda ise bütün tablor birleþmiþ halde ve NULL þeklinde 
AS

SELECT customer_id, first_name, last_name,
 
 STR (First_product) AS First_product,
 STR (Second_product) AS Second_product,
 STR (Third_product) AS Third_product

FROM [Table_0]


CREATE VIEW [Table_result] -- Ve son olarak [Table_result] VIEW i Create ettik ve sayýsal deðelere 'Yes', NULL deðerlere 'No' dedik
AS

SELECT customer_id, first_name, last_name,
 
ISNULL(NULLIF (ISNULL(STR(A.First_product), 'No'), STR(A.First_product)), 'Yes') AS First_product,
ISNULL(NULLIF (ISNULL(STR(A.Second_product), 'No'), STR(A.Second_product)), 'Yes') AS Second_product,
ISNULL(NULLIF (ISNULL(STR(A.Third_product), 'No'), STR(A.Third_product)), 'Yes') AS Third_product

 
FROM [Table_0] A

SELECT * FROM [Table_result]  -- SONUÇ 


