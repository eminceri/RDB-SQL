---
select * -- top 5* vs diyerek istedigimiz row sayilarini cagirabiliriz 
from sale.customer


SELECT top 5 *
FROM  sale.orders


--cust_id si 259 olan musterinin adini soyadini dondur

SELECT b.first_name , b.last_name
FROM sale.orders a , sale.customer b 
WHERE a.customer_id = b.customer_id AND
      b.customer_id = 259


SELECT last_name , first_name
FROM sale.customer
WHERE customer_id = 259 



---order_item tablosunda 
--order_id si 10 olan urunleri getirin 

SELECT product_id
from sale.order_item
WHERE order_id = 10

--bunun hangi urun oldugunu gorelim

SELECT product_name
from product.product
WHERE product_id = (SELECT product_id
                   from sale.order_item
                   WHERE order_id = 10)


--join ile 
SELECT product_name
from sale.order_item a, product.product b 
WHERE a.product_id = b.product_id AND
      a.order_id = 10                   

--product tablosuna baktik
SELECT *
FROM product.product    
--burda product taplosunda fiyati ne yuksek olan 10 row u istedik
----product_name ve id leri de gelsin
SELECT top 10 product_name ,list_price
from product.product
ORDER BY list_price DESC 


SELECT order_id 
FROM product.product a, sale.order_item b 
WHERE a.product_id = b.product_id
   and a.product_id IN (SELECT top 10 product_id
                     from product.product
                     ORDER BY list_price DESC )

--- burasi hata veirir.Burda subquery de top i sildigimiz icin bize hata verdi.
---orderby top yada offset ile beraber olur sa subquery olarak calisir

SELECT order_id 
FROM product.product a, sale.order_item b 
WHERE a.product_id = b.product_id
   and a.product_id IN (SELECT  product_id
                     from product.product
                     ORDER BY list_price DESC )    --burasi hata dondu   



--order_item
--order_item da kac tane satir oldugunu getirir.

SELECT count(*) --count un icine ne yazarsa yazsin hep bize row sayisi doner
FROM sale.order_item

SELECT count(distinct discount)
FROM sale.order_item

--kac farkli order var 
SELECT count(distinct order_id)
FROM sale.order_item


--herbir siparisteki item sayisi
SELECT order_id , MAX(item_id) AS count_item
FROM sale.order_item
GROUP BY order_id 
ORDER BY order_id

---max yerine count da kullanabiliriz.
SELECT order_id , count (item_id) AS count_item
FROM sale.order_item
GROUP BY order_id 
ORDER BY order_id

--herbir siparisteki en yuksek fiyatli urunu cagiralim

SELECT  order_id , MAX(list_price) as max_price
FROM sale.order_item
GROUP BY order_id


--herbir sipariste en cok siparis edilen urunun adi 
   ---burasi bize her order in max satildigi sayiyi gosteirir
SELECT order_id , MAX(quantity) as MAX_quantity
FROM sale.order_item
GROUP BY order_id ;

--ben bu sekilde yeni bir tablo olusturuyorum
WITH table_1 as(
                SELECT order_id, MAX(quantity) as MAX_quantity
                FROM sale.order_item
                 GROUP BY order_id )
---burda da yukarda olusturdugumuz tablo ile yine order_item i join yapacagiz.
SELECT b.order_id,table_1.MAX_quantity , b.product_id
FROM table_1 , sale.order_item b 
WHERE table_1.MAX_quantity = b.quantity
     AND table_1.order_id = b.order_id


---  
--Davi techno retail den siparis verilen siparisler  
SELECT*
FROM sale.store
--once Davi nin tum bilgilerini bulalim
SELECT *
FROM sale.store 
WHERE store_name = 'Davi techno Retail'



SELECT *
FROM sale.store 
WHERE store_name = 'Davi techno Retail'

--storename i Davi olan order_id ve stor_id getir.Yani Davi den verilen siparisler
SELECT b.order_id , a.store_id,a.store_name
FROM sale.store a, sale.orders b 
WHERE a.store_id = b.store_id
     AND store_name= 'Davi techno Retail'


--2018-01 de Davi den verilen siparisler 

SELECT a.store_id,b.order_id, a.store_name, b.order_date
FROM  sale.store a, sale.orders b 
WHERE a.store_id = b.store_id
AND a.store_name = 'Davi techno Retail'
AND MONTH(b.order_date) = 1
AND YEAR(b.order_date) = 2018


-- davi techno mağazasından 2018'in 1. ayında verilen sipariş sayısı nedir?

SELECT COUNT(order_id)
FROM  sale.store a, sale.orders b 
WHERE a.store_id = b.store_id
AND a.store_name = 'Davi techno Retail'
AND MONTH(b.order_date) = 1
AND YEAR(b.order_date) = 2018


--2018-01 de Davi den toplam kac gun siparis almis.Farkli gunleri eleyelim 

SELECT COUNT(distinct day(b.order_date))
FROM  sale.store a, sale.orders b 
WHERE a.store_id = b.store_id
AND a.store_name = 'Davi techno Retail'
AND MONTH(b.order_date) = 1
AND YEAR(b.order_date) = 2018


---sale.orders table a bakalim yine
SELECT top 100*
FROM sale.orders

--2018 yilinda verilen siparisler
  --bu sekilde bize sadece aylara gore siparisleri gosterdi.
  --aylara gore grouplayip
SELECT COUNT(order_id) as toplam_siparis ,MONTH(order_date) aylara_gore
FROM sale.orders
WHERE YEAR(order_date) = 2018 
GROUP BY MONTH(order_date)



SELECT order_date, MONTH(order_date) aylara_gore
FROM sale.orders
WHERE YEAR(order_date) = 2018 


--burda da aylara gore toplam siparis sayisini bulduk
SELECT COUNT(order_date) as toplam_siparis ,MONTH(order_date) aylara_gore
FROM sale.orders
WHERE YEAR(order_date) = 2018 
GROUP BY MONTH(order_date)

---2018 yilinda 50 siparisden fazla siparis verilen aylar 
--agg islemi sonucu olusan sutuna filtre uygulamak istiyorsam having ile 
   --yapmamiz gerek .eger agg yaptigimiz 

SELECT COUNT(order_date) as toplam_siparis ,MONTH(order_date) aylara_gore
FROM sale.orders
WHERE YEAR(order_date) = 2018 
GROUP BY MONTH(order_date)
HAVING COUNT(order_id) >50 -- yada burda having yerine where den sonra subquery
                            -- olarak da yapilabilirdi.