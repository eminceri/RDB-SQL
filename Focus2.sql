select * from product.stock

-- stock tablosunda ki ürünler hangi mağazalarda satılıyor?
select * from product.stock order by product_id

-- stock tablosunda ki ürünler kaç mağazada satılıyor?
select product_id, count(store_id) dukkan_sayısı from product.stock group by product_id order by product_id

-- Stock tablosunda kaç farklı ürün var?
select count(distinct product_id) from product.stock 

-- Stock tablosunda her bir mağazada kaç tane farklı ürün var.
select store_id, count(distinct product_id) from product.stock group by store_id

-- Stock tablosunda her bir mağazada toplam ürün sayısı
select store_id,  sum(quantity) toplam_ürün from product.stock group by store_id

-- product tablosunda kaç farklı ürün var?
select count(product_id) from product.product

-- hem product hem de stock tablosundaki ürünler nelerdir?
select distinct B.product_id
from product.product A, product.stock B
where A.product_id = B.product_id

Select A.product_id from product.product A
inner join product.stock B on a.product_id = B.product_id

select product_id from product.product
where product_id in (
select product_id from product.stock)

select product_id From product.product
intersect
select product_id from product.stock

-- 2018'in mart ayı müşterileri ile 2019 mart ayındaki müşterilerden hangileri aynı kişilerdir?

select* from sale.orders
where datepart(month,order_date) = 3 and DATEPART(year,order_date) = 2018
intersect
select* from sale.orders
where datepart(month,order_date) = 3 and DATEPART(year,order_date) = 2019
--(sonuç 0 çıktı)

select customer_id from sale.orders
where DATEPART(year,order_date) = 2018
intersect
select customer_id from sale.orders
where datepart(month,order_date) = 4 and DATEPART(year,order_date) = 2019
--(intersect kullanılırken seçilen her bilgi aynı olmalıdır.)

-- product tablosunda olup stock tablosunda olmayan ürünleri listeleyiniz.
select product_id
from product.product
except                -- hariç anlamında
select product_id
from product.stock

select distinct A.product_id
from product.product A left join product.stock B
on A.product_id = b.product_id 
where B.product_id is null


-- product tablosunda olup stock tablosunda olmayan ürünleri listeleyiniz.
-- sorgusu sonunda çokan NULL değerlerin yerine "store bilgisi mevcut değildir." yazdıralım
select distinct A.product_id,B.store_id -- Null ları görelim
from product.product A left join product.stock B
on A.product_id = b.product_id 
where B.product_id is null

select isnull(null, 'ürün yok')

select coalesce('fatih', null, 'samet', null) -- null olmayan ilk değeri getirir.

select case when 'ahmet' is null then 'cart'  else 'ahmet null değildir' end
-- çözüm1
select A.product_id, isnull(str(B.store_id, 30),'store bilgisi mevcut değildir.') stok_durumu
from product.product A left join product.stock B
on A.product_id = b.product_id 
where B.product_id is null

-- çözüm2
select A.product_id, isnull(cast(B.store_id as varchar (30)),'store bilgisi mevcut değildir.') stok_durumu
from product.product A left join product.stock B
on A.product_id = b.product_id 
where B.product_id is null

-- a tablosundaki product_id ile b tablosundaki product_id leri ayrı ayrı sayalım.
select count(distinct A.product_id) A_table, count(distinct B.product_id) B_table
from product.product A left join product.stock B
on A.product_id = b.product_id 

-- çözüm2 window function ile yapalım
select distinct count(A.product_id) over() A_table, count(B.product_id) over() B_table
from product.product A 
left join product.stock B
on A.product_id = b.product_id -- uniqe olmaz içteki değerler. bu nedenle ana tablo uniqe leştirilmeli.

select distinct count(table_a) over() , count(table_b) over() 
from (
select distinct A.product_id table_a, B.product_id table_b
from product.product A 
left join product.stock B
on A.product_id = b.product_id)
product_a

-- customer tablosundaki müşterileri statelere göre sayınız.
select [state], count(customer_id) number_of_customers from sale.customer
group by [state] order by [state] 

-- çözüm2 windows function ile yapalım
select distinct [state] , count(customer_id) over(partition by [state]) -- partition by ile grupladık
from sale.customer


-- customer tablosundaki müşterileri city'lere göre sayınız.
select distinct [state], city, count(customer_id) num_of_customers 
from sale.customer group by [state], city order by city

--çözüm2 windows function ile yapalım
select distinct [state], city , count(customer_id) over(partition by [state], [city])  num_of_customers
from sale.customer

-- eyaletleri de gösteren sütun ilave edelim.
SELECT DISTINCT state, city, count(customer_id) OVER(PARTITION BY state, city) as number_of_customer_2,
				count(customer_id) OVER(PARTITION BY state) as number_of_customer_3				
FROM sale.customer






