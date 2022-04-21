-- Assignment-4 

with T1 as (
select distinct  product_id,discount,
        SUM(quantity) over (partition by product_id,discount ) net_quantity
from sale.order_item
),
T2 as (
select*,
	lead(T1.net_quantity) over(partition by T1.product_id order by T1.product_id,T1.discount) onceki_ay_satýs,
	dense_rank() over(partition by T1.product_id order by T1.product_id, T1.discount) row_num
from T1	),
T3 as
		(
		select *,(T2.onceki_ay_satýs - T2.net_quantity ) fark
		from T2
		where T2.row_num  < 4
		)
select distinct product_id,
	case
		when Sum(fark) over (partition by product_id)>0 then'Positive'
		when Sum(fark) over (partition by product_id)<0 then'Negative'
		else 'Neutral'
		End as Discount_Effect
from T3