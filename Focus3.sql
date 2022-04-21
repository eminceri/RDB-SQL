select * from [sale].[customer]

-- Soru 1:her bir şehirdeki müşteri sayımız kaçtır?
select city, count(distinct customer_id) as number_of_customer 
from sale.customer
group by city
order by number_of_customer desc

-- Soru 2:New york eyaletindeki şehirlerde kaçar müşteri var?
select city, count(distinct customer_id) as number_of_customer 
from sale.customer
where sale.customer.state = 'NY'
group by city

-- Soru 3:California eyaletindeki şehirlerden en fazla 40 müşteri olan şehirler?

select city, count(distinct customer_id) as number_of_customer 
from sale.customer
where sale.customer.state = 'CA'
group by city
Having count(distinct customer_id) < 41

-- Soru 4 :California eyaletindeki şehirlerden en fazla 40 müşterisi 
-- olan şehirlerdeki Müşteriler kimlerdir?

Select customer_id, first_name, last_name, city
from sale.customer
WHERE city in (
	select city
	from sale.customer
	where sale.customer.state = 'CA'
	group by city
	Having count(distinct customer_id) < 40)

-- 2. Join ile
select B.city, first_name, last_name
From sale.customer B
join (
select city, count(distinct customer_id) as number_of_customer 
from sale.customer
where sale.customer.state = 'CA'
group by city
Having count(distinct customer_id) < 41) A

on B.city = A.city
order by city

-- Soru 5: window function ile kaliforniyadaki şehirlerin müşteri sayısını bulunuz.
select distinct city, count(customer_id) over (partition by city)
from sale.customer a
where [state] = 'CA'


-- 2. normal yolla
select city, count(customer_id)
From sale.customer
where [state] = 'CA'
group by city

-- Soru 6:müşterilerin isimlerini de yazdıralım.
select distinct city, first_name, last_name, count(customer_id) over (partition by city) as cnt_cust
from sale.customer a
where [state] = 'CA'

-- Soru 7: Bu müşterilerin sipariş sayısını da sütun olarak ilave edelim.
select distinct a.city, a.first_name, a.last_name, count(a.customer_id) over (partition by a.city) as cnt_cust, 
											  count(b.order_id) over (partition by b.customer_id) as cnt_of_order
from sale.customer a, sale.orders b
where [state] = 'CA' and a.customer_id = b.customer_id

-- Soru 8: Müşterilerin customer_id ve sipariş ettiği ürün sayısı
select Distinct A.customer_id, sum(B.quantity) over(partition by A.customer_id) num_of_orders
from sale.orders A, sale.order_item B
where A.order_id=B.order_id
order by num_of_orders Desc

-- Soru 9: Müşterilerin customer_id ve sipariş ettiği ürün sayısına göre row_id verelim.
SELECT ROW_NUMBER() over(order by num_of_orders desc) as row_id, *
FROM 
(
select Distinct A.customer_id, sum(B.quantity) over(partition by A.customer_id) num_of_orders
from sale.orders A, sale.order_item B
where A.order_id=B.order_id
) A

-- Soru 10: row_id'e göre 40 ve 50'nci müşterileri iste
Select customer_id, row_id
from
(SELECT ROW_NUMBER() over(order by num_of_orders desc) as row_id, *
FROM 
(
select Distinct A.customer_id, sum(B.quantity) over(partition by A.customer_id) num_of_orders
from sale.orders A, sale.order_item B
where A.order_id=B.order_id
) A 
) B
where row_id = 40 or row_id = 50

-- Soru 11: Aynı ürün sayısına sahip müşterilere aynı row_id veriniz.
SELECT DENSE_RANK() over(order by num_of_orders desc) as row_id, *
FROM 
(
select Distinct A.customer_id, sum(B.quantity) over(partition by A.customer_id) num_of_orders
from sale.orders A, sale.order_item B
where A.order_id=B.order_id
) A 

-- Soru 12: Aynı ürün sayısına sahip müşterilere aynı row_id veriniz ve sipariş miktarı en yüksek olan 3 siparişi(uniqe) veren müşteriler?

Select customer_id, row_id
from(
SELECT DENSE_RANK() over(order by num_of_orders desc) as row_id, *
FROM 
(
select Distinct A.customer_id, sum(B.quantity) over(partition by A.customer_id) num_of_orders
from sale.orders A, sale.order_item B
where A.order_id=B.order_id
) A
) B
where row_id < 4

-- Soru 13: Her bir müşterinin; siparişleri ve sipariş tarihleri.
select customer_id, order_id, order_date
from sale.orders
order by customer_id

-- Soru 14: ad-ve soyadı da ilave edelim.
select A.customer_id, B.first_name, B.last_name, A.order_id, A.order_date
from sale.orders A, sale.customer B
Where A.customer_id = B.customer_id
order by A.customer_id

-- Soru 15: Birden fazla sipariş veren müşteri için siparişler arası tarih farkını bir sütun olarak ilave ediniz.
select A.customer_id, B.first_name, B.last_name, A.order_id, A.order_date,
Lead(A.order_date) over (partition by A.Customer_id order by A.order_id) Next_order, 
DATEDIFF(DAY, A.order_date, Lead(A.order_date) over (partition by A.Customer_id order by A.order_id)) next_order_day
from sale.orders A, sale.customer B
Where A.customer_id = B.customer_id


