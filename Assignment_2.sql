

USE SampleRetail

CREATE VIEW [CUSTOMER_PRODUCT]  -- Burada Customer_id, First_name, Last_name s�tunlar�n� bir tabloda create ettik
AS                            -- Ama product_name i '2TB Red 5400 rpm SATA III 3.5 Internal NAS HDD' olanlar� sorgulatt�k

SELECT	distinct D.customer_id, D.first_name, D.last_name
FROM	product.product A, sale.order_item B, sale.orders C, sale.customer D
WHERE	A.product_id=B.product_id
AND		B.order_id = C.order_id
AND		C.customer_id = D.customer_id
AND		A.product_name = '2TB Red 5400 rpm SATA III 3.5 Internal NAS HDD'

SELECT * FROM [dbo].[CUSTOMER_PRODUCT]



create view [First_pr] -- Daha sonra [First_pr] ad�nda bizden istenilen First_product s�tununu create ettik
AS                     -- Ama product_name i 'Polk Audio - 50 W Woofer - Black' olanlar� sorgulatt�k

SELECT  C.customer_id AS First_product
FROM	product.product A, [sale].[order_item] B, [sale].[orders] C 
WHERE	B.product_id = 13
AND     B.order_id = C.order_id
AND		A.product_name = 'Polk Audio - 50 W Woofer - Black'


create view [Second_pr] -- Burada da [Second_pr] ad�nda bizden istenilen Second_product s�tununu Create ettik
AS						-- Ama product_name i 'SB-2000 12 500W Subwoofer (Piano Gloss Black)' olanlar� sorgulatt�k 

SELECT  C.customer_id AS Second_product
FROM	product.product A, [sale].[order_item] B, [sale].[orders] C 
WHERE	B.product_id = 21
AND     B.order_id = C.order_id
AND		A.product_name = 'SB-2000 12 500W Subwoofer (Piano Gloss Black)'

create view [Third_pr] -- Burada isr [Third_pr] ad�nda bizden istenilen Third_product s�tununu Create ettik
AS					   -- Ama product_name i 'Virtually Invisible 891 In-Wall Speakers (Pair)' olanlar� sorgulatt�k

SELECT  C.customer_id AS Third_product
FROM	product.product A, [sale].[order_item] B, [sale].[orders] C 
WHERE	B.product_id = 16
AND     B.order_id = C.order_id
AND		A.product_name = 'Virtually Invisible 891 In-Wall Speakers (Pair)'


----------- S�tunlar� birbirine ba�lama b�l�m� ------------


CREATE VIEW [Table_0] -- Daha sonra ise yukar�da 4 tane Create etti�imiz VIEW lar [CUSTOMER_PRODUCT], [First_pr], [Second_pr], [Third_pr] 
AS                    -- Bu 4 VIEW i birbirlerine ba�lad�k

SELECT *
FROM [CUSTOMER_PRODUCT] A
LEFT JOIN [First_pr] B
ON A.customer_id = B.First_product
LEFT JOIN [Second_pr] C
ON A.customer_id = C.Second_product
LEFT JOIN [Third_pr] D
ON A.customer_id = D.Third_product


CREATE VIEW [Table_null] -- Burda ise b�t�n tablor birle�mi� halde ve NULL �eklinde 
AS

SELECT customer_id, first_name, last_name,
 
 STR (First_product) AS First_product,
 STR (Second_product) AS Second_product,
 STR (Third_product) AS Third_product

FROM [Table_0]


CREATE VIEW [Table_result] -- Ve son olarak [Table_result] VIEW i Create ettik ve say�sal de�elere 'Yes', NULL de�erlere 'No' dedik
AS

SELECT customer_id, first_name, last_name,
 
ISNULL(NULLIF (ISNULL(STR(A.First_product), 'No'), STR(A.First_product)), 'Yes') AS First_product,
ISNULL(NULLIF (ISNULL(STR(A.Second_product), 'No'), STR(A.Second_product)), 'Yes') AS Second_product,
ISNULL(NULLIF (ISNULL(STR(A.Third_product), 'No'), STR(A.Third_product)), 'Yes') AS Third_product

 
FROM [Table_0] A

SELECT * FROM [Table_result]  -- SONU� 


