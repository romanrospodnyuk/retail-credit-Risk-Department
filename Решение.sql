--Задача №1
select avg(card_limit)
from cards_info
where application_status = 'A' and application_date >= now() - interval '6 month'

--Задача №2
select shop_name
from product_info p 
	join credit_info ci on p.credit_id = ci.credit_id
	join currency_rate cr on cr.currency = ci.currency 
where issue_date >= now() - interval '3 month' and term < '12' and currency = 'RUB' and p.price < 100000

--Задача №3
select ci.customer_id, ci.name, ci.surname, ci.patronymic, ci.birth_date, ci.gender, date_part('year',age(ci.birth_date::date)) as "возраст"
from customer_info c 
	join (
		select customer_id, count(application_id)
		from cards_info 
		where application_status = 'A' and application_date >= now() - interval '1 month'
		group by customer_id 
		having count(application_id) > 1
		) c1 on c1.customer_id = c.customer_id 
	join (
		 select customer_id, count(credit_id), case 
									  when ci.currency ='RUB' then loan_amount
									  else loan_amount * exchange_rate
									  end
		from credit_info ci  
			join currency_rate cr on cr.currency = ci.currency 
		where credit_status = 'A' and issue_date >= now() - interval '1 month' and currency_date = issue_date 
		having count(credit_id) > 2 and sum(loan_amount) >= 1000000)
		) с2 on c2.customer_id = c.customer_id 

--Задача №4
select customer_id, sum(loan_amount), count(credit_id)
from credit_info ci
where currency = 'RUB' and issue_date = now()::date
having avg(loan_amount) > (select avg(loan_amount)
						   from credit_info 
						   where issue_date::date >= now()::date - interval '12 month')
						   
--Задача №5
select shop_name, count(select distinct credit_id from payment_info where delays_day >= 90)/count(credit_id)
from payment_info p 
	join credit_info ci on ci.id = p.id
where credit_status = 'выдан'











