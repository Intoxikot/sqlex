/* Задание: 1 (Serge I: 2002-09-30)
Найдите номер модели, скорость и размер жесткого диска для всех ПК стоимостью менее 500 дол. Вывести: model, speed и hd */
select PC.model, PC.speed, PC.hd from PC where price < 500;


/* Задание: 2 (Serge I: 2002-09-21)
Найдите производителей принтеров. Вывести: maker */ 
select distinct Product.maker from Printer, Product where Product.type = 'Printer';


/* Задание: 3 (Serge I: 2002-09-30)
Найдите номер модели, объем памяти и размеры экранов ПК-блокнотов, цена которых превышает 1000 дол. */
select Laptop.model, Laptop.ram, Laptop.screen 
from Laptop 
where Laptop.price > 1000 
order by Laptop.model;


/* Задание: 4 (Serge I: 2002-09-21)
Найдите все записи таблицы Printer для цветных принтеров. */
select *
from Printer
where Printer.color = 'y';


/* Задание: 5 (Serge I: 2002-09-30)
Найдите номер модели, скорость и размер жесткого диска ПК, имеющих 12x или 24x CD и цену менее 600 дол. */
select PC.model, PC.speed, PC.hd
from PC
where (PC.cd = '12x' or PC.cd = '24x') and PC.price < 600
order by PC.model;


/* Задание: 6 (Serge I: 2002-10-28)
Для каждого производителя, выпускающего ПК-блокноты c объёмом жесткого диска не менее 10 Гбайт, найти скорости таких ПК-блокнотов. Вывод: производитель, скорость. */

-- Все ноуты с жестким диском не менее 10 (первый запрос)
select laptop.model, laptop.speed 
from laptop
where laptop.hd >= 10;

-- Все производители ноутов (второй запрос)
select distinct maker from product where type == 'Laptop';

-- Результат
select distinct P.maker, L.speed 
from
	(select maker, model 
	from product 
	where type = 'Laptop') as P
join
	(select laptop.model, laptop.speed 
	from laptop
	where laptop.hd >= 10) as L
on P.model = L.model
order by speed


/*Задание: 7 (Serge I: 2002-11-02)
Найдите номера моделей и цены всех имеющихся в продаже продуктов (любого типа) производителя B (латинская буква). */

-- Производитель B (первый запрос) 
select * from product where maker = 'B';

-- Производитель B для PC (шаблон запроса) 
select * from pc as C
join
(select product.model from product where maker = 'B') as P
on P.model = C.model

-- Объединение пк и ноутов (валидатор требует начало на select)
select * from (	
    (select P.model, C.price 
	from pc as C
	join
	(select product.model from product where maker = 'B') as P
	on P.model = C.model)
		union
	(select P.model, L.price 
	from Laptop as L
	join
	(select product.model from product where maker = 'B') as P
	on P.model = L.model)
) as R

-- Итоговый
select * from (	
    (select P.model, C.price 
	from pc as C
	join
	(select product.model from product where maker = 'B') as P
	on P.model = C.model)
		union
	(select P.model, L.price 
	from Laptop as L
	join
	(select product.model from product where maker = 'B') as P
	on P.model = L.model)
		union
	(select P.model, PR.price 
	from printer as PR
	join
	(select product.model from product where maker = 'B') as P
	on P.model = PR.model)

) as R


/* Задание: 8 (Serge I: 2003-02-03)
Найдите производителя, выпускающего ПК, но не ПК-блокноты. */
select product.maker from product
where product.type in ('PC')
except
select product.maker from product
where product.type in ('Laptop');


/* Задание: 9 (Serge I: 2002-11-02)
Найдите производителей ПК с процессором не менее 450 Мгц. Вывести: Maker */

-- correct v1
select distinct product.maker
from product, pc
where pc.speed > 450 and product.model = pc.model;

-- correct v2
select distinct product.maker 
from
	(select * from pc
	where pc.speed >= 450) as C, product
where product.model = C.model;


/* Задание: 10 (Serge I: 2002-09-23)
Найдите модели принтеров, имеющих самую высокую цену. Вывести: model, price */
select model, price
from printer
where price in 
	(select max(price) from printer)
order by model;


/* Задание: 11 (Serge I: 2002-11-02)
Найдите среднюю скорость ПК. */
select avg(pc.speed) as speed
from pc;


/* Задание: 12 (Serge I: 2002-11-02)
Найдите среднюю скорость ПК-блокнотов, цена которых превышает 1000 дол. */
select avg(laptop.speed)
from laptop
where laptop.price > 1000;


/* Задание: 13 (Serge I: 2002-11-02)
Найдите среднюю скорость ПК, выпущенных производителем A. */
select avg(speed)
from pc
join product
on product.model = pc.model
where product.maker = 'A';


/* Задание: 15 (Serge I: 2003-02-03)
Найдите размеры жестких дисков, совпадающих у двух и более PC. Вывести: HD */
select pc.hd
from pc
group by pc.hd
having count(pc.hd) >= 2

/* Задание: 16 (Serge I: 2003-02-03)
Найдите пары моделей PC, имеющих одинаковые скорость и RAM. В результате каждая пара указывается только один раз, т.е. (i,j), но не (j,i), Порядок вывода: модель с большим номером, модель с меньшим номером, скорость и RAM. */

-- Группировка speed и ram
select pc.speed, pc.ram
from pc
group by pc.speed, pc.ram

-- Группировка speed и ram с моделями
select max(pc.model) as model, min(pc.model) as model, pc.speed, pc.ram
from pc
group by pc.speed, pc.ram


/* Задание: 17 (Serge I: 2003-02-03)
Найдите модели ПК-блокнотов, скорость которых меньше скорости каждого из ПК.
Вывести: type, model, speed */
select distinct 'laptop' as type, laptop.model, laptop.speed
from laptop
where laptop.speed < (select min(pc.speed) from pc)


/* Задание: 18 (Serge I: 2003-02-03)
Найдите производителей самых дешевых цветных принтеров. Вывести: maker, price */

-- Самые дешевые цветные принтеры
select min(printer.price) from printer where printer.color = 'y';

-- Производители принтеров
select * from product where product.type = 'printer';

-- Производители цветных принтеров
select product.maker, printer.price
from printer
join product
on product.model = printer.model 
where product.type = 'printer' and printer.color = 'y'

-- Полное решение
select product.maker, min(printer.price)
from printer
join product
on product.model = printer.model and product.type = 'printer'
where 
	printer.color = 'y' and 
	printer.price = (select min(printer.price) from printer where printer.color = 'y')
group by product.maker, printer.price


/* Задание: 19 (Serge I: 2003-02-13)
Для каждого производителя, имеющего модели в таблице Laptop, найдите средний размер экрана выпускаемых им ПК-блокнотов.
Вывести: maker, средний размер экрана. */
select product.maker, avg(laptop.screen)
from laptop
join product 
on laptop.model = product.model and product.type = 'Laptop'
group by product.maker


/* Задание: 20 (Serge I: 2003-02-13)
Найдите производителей, выпускающих по меньшей мере три различных модели ПК. Вывести: Maker, число моделей ПК. */
select product.maker, count(product.model)
from product
where product.type = 'PC'
group by product.maker
having count(product.model) >= 3


/* Задание: 21 (Serge I: 2003-02-13)
Найдите максимальную цену ПК, выпускаемых каждым производителем, у которого есть модели в таблице PC.
Вывести: maker, максимальная цена. */
select product.maker, max(pc.price)
from product
join pc
on product.model = pc.model
group by product.maker;


/* Задание: 22 (Serge I: 2003-02-13)
Для каждого значения скорости ПК, превышающего 600 МГц, определите среднюю цену ПК с такой же скоростью. Вывести: speed, средняя цена. */
select pc.speed, avg(price)
from pc
group by pc.speed
having pc.speed > 600;


/* Задание: 23 (Serge I: 2003-02-14)
Найдите производителей, которые производили бы как ПК
со скоростью не менее 750 МГц, так и ПК-блокноты со скоростью не менее 750 МГц.
Вывести: Maker */
# first
select distinct product.maker
from product
join pc
on product.model = pc.model
where pc.speed >= 750;

# second
select distinct product.maker
from product
join laptop
on product.model = laptop.model
where laptop.speed >= 750;

# result
select distinct T.maker
from
	(select product.maker
	from product
	join pc
	on product.model = pc.model
	where pc.speed >= 750

	intersect

	select product.maker
	from product
	join laptop
	on product.model = laptop.model
	where laptop.speed >= 750) as T


/* Задание: 24 (Serge I: 2003-02-03)
Перечислите номера моделей любых типов, имеющих самую высокую цену по всей имеющейся в базе данных продукции. */

-- Список всех продуктов
select laptop.model as model, laptop.price as price
	from product
	join laptop 
	on product.model = laptop.model
		union
	select pc.model, pc.price
	from product
	join pc 
	on product.model = pc.model
		union
	select printer.model, printer.price
	from product
	join printer
	on product.model = printer.model


-- Максимальная цена по продуктам
select max(T.price) as price from 
	(select laptop.model, laptop.price
	from product
	join laptop 
	on product.model = laptop.model
		union
	select pc.model, pc.price
	from product
	join pc 
	on product.model = pc.model
		union
	select printer.model, printer.price
	from product
	join printer
	on product.model = printer.model) as T


-- Итоговый запрос
select T.model from (
	select laptop.model as model, laptop.price as price
	from product
	join laptop 
	on product.model = laptop.model
		union
	select pc.model, pc.price
	from product
	join pc 
	on product.model = pc.model
		union
	select printer.model, printer.price
	from product
	join printer
	on product.model = printer.model) as T
where price = (
	select max(T.price) as price from (
		select laptop.model, laptop.price
		from product
		join laptop 
		on product.model = laptop.model
			union
		select pc.model, pc.price
		from product
		join pc 
		on product.model = pc.model
			union
		select printer.model, printer.price
		from product
		join printer
		on product.model = printer.model
	) as T
);


/* Задание: 25 (Serge I: 2003-02-14)
Найдите производителей принтеров, которые производят ПК с наименьшим объемом RAM и с самым быстрым процессором среди всех ПК, имеющих наименьший объем RAM. Вывести: Maker */

-- Модели PC от производителей принтеров
select *
from product
join pc
on product.model = pc.model
where product.maker in (
	select distinct product.maker
	from product
	where product.type = 'printer'
) 

-- Модели PC от производителей принтеров c наименьшим RAM среди всех ПК
select *
from product
join pc
on product.model = pc.model
where product.maker in (
	select distinct product.maker
	from product
	where product.type = 'printer'
) and pc.ram = (select min(pc.ram) from pc)

-- Результат
select distinct product.maker
from product
join pc
on product.model = pc.model
where product.maker in (
		select distinct product.maker
		from product
		where product.type = 'printer'
	) 
    and pc.ram = (select min(pc.ram) from pc) 
    and pc.speed = (

	select max(pc.speed)
	from product
	join pc
	on product.model = pc.model
	where product.maker in (
		select distinct product.maker
		from product
		where product.type = 'printer'
	) and pc.ram = (select min(pc.ram) from pc) 


)


/* Задание: 26 (Serge I: 2003-02-14)
Найдите среднюю цену ПК и ПК-блокнотов, выпущенных производителем A (латинская буква). Вывести: одна общая средняя цена. */
select avg(price) from (
	select pc.price
	from pc
	join product
	on pc.model = product.model
	where product.maker = 'A'
		union all
	select laptop.price
	from laptop
	join product
	on laptop.model = product.model
	where product.maker = 'A'
) as T;


/* Задание: 27 (Serge I: 2003-02-03)
Найдите средний размер диска ПК каждого из тех производителей, которые выпускают и принтеры. Вывести: maker, средний размер HD. */
select product.maker, avg(pc.hd)
from pc
join product
on product.model = pc.model
where maker in (select product.maker from product where product.type = 'printer')
group by maker;


/* Задание: 28 (Serge I: 2012-05-04)
Используя таблицу Product, определить количество производителей, выпускающих по одной модели. */

-- Правильно
select count(T.cnt)
from (
	select count(*) as cnt
	from product
	group by product.maker
) as T
where T.cnt = 1

-- Так не правильно
select count(product.maker)
from product
group by product.maker
having count(product.model) = 1


/* Задание: 40 (Serge I: 2012-04-20)
Найти производителей, которые выпускают более одной модели, при этом все выпускаемые производителем модели являются продуктами одного типа. Вывести: maker, type */

-- Уникальные пары (maker, type)
select distinct maker, type
from product as M

-- Результат
select maker, type
from product
where maker in
	(select maker from
		(select distinct maker, type
		from product) as M
	group by maker
	having count(maker) = 1)
group by maker, type
having count(*) > 1


/* Задание: 41 (Serge I: 2019-05-31)
Для каждого производителя, у которого присутствуют модели хотя бы в одной из таблиц PC, Laptop или Printer,
определить максимальную цену на его продукцию.
Вывод: имя производителя, если среди цен на продукцию данного производителя присутствует NULL, то выводить для этого производителя NULL,
иначе максимальную цену. */

-- Верный результат на mysql (не проходит онлайн-валидатор)
select T.maker, (
	case  
		when T.price is not null then max(T.price) 
		else null
    end
    ) as m_price
from (
	select product.maker, product.model, pc.price
	from product
	join pc
	on pc.model = product.model
		union  
	select product.maker, product.model, laptop.price
	from product
	join laptop
	on laptop.model = product.model
		union
	select product.maker, product.model, printer.price 
	from product
	join printer
	on printer.model = product.model
) as T
group by T.maker;

-- Решение для валидатора:
-- считает максимальную цену среди тех производителей у которых нет нулл среди цен и присоединяет ту же таблицу, добавляя поставщиков, среди товаров которых имеются цены нулл (добавляя столбец нулл соответственно)
select 
	T.maker, max(T.price)
from (
	select product.maker, pc.price
	from product
	join pc
	on pc.model = product.model
		union  
	select product.maker, laptop.price
	from product
	join laptop
	on laptop.model = product.model
		union
	select product.maker, printer.price 
	from product
	join printer
	on printer.model = product.model
) as T
where T.maker not in (
	select 
		T.maker
	from (
		select product.maker, pc.price
		from product
		join pc
		on pc.model = product.model
			union  
		select product.maker, laptop.price
		from product
		join laptop
		on laptop.model = product.model
			union
		select product.maker, printer.price 
		from product
		join printer
		on printer.model = product.model
	) as T
    where T.price is null
	group by T.maker)
group by T.maker
	union
select 
	T.maker, null
from (
	select product.maker, pc.price
	from product
	join pc
	on pc.model = product.model
		union  
	select product.maker, laptop.price
	from product
	join laptop
	on laptop.model = product.model
		union
	select product.maker, printer.price 
	from product
	join printer
	on printer.model = product.model
) as T
where T.price is null
group by T.maker;


/* Задание: 58 (Serge I: 2009-11-13)
Для каждого типа продукции и каждого производителя из таблицы Product c точностью до двух десятичных знаков найти процентное отношение числа моделей данного типа данного производителя к общему числу моделей этого производителя. Вывод: maker, type, процентное отношение числа моделей данного типа к общему числу моделей производителя */

-- Пересечение всех производителей и типов
select A.maker, B.type
	from
		(select product.maker
		from product
		group by product.maker) as A
	cross join
		(select product.type
		from product
		group by product.type) as B
	order by A.maker, B.type

-- Решение
select C.maker, C.type, 
	round( 
		case 
			when type_count is not null then type_count * 100
            else 0
		end
		/ total_count, 2) as prc
from
	(select A.maker, B.type
	from
		(select product.maker
		from product
		group by product.maker) as A
	cross join
		(select product.type
		from product
		group by product.type) as B
	order by A.maker, B.type) as C
left join
	(select product.maker, product.type, count(product.type) as type_count
	from product
	group by product.maker, product.type) as M
on C.maker = M.maker and C.type = M.type 
left join
	(select product.maker, count(product.maker) as total_count
	from product
	group by product.maker) as T
on C.maker = T.maker


/* Задание: 75 (Serge I: 2020-01-31)
Для тех производителей, у которых есть продукты с известной ценой хотя бы в одной из таблиц Laptop, PC, Printer найти максимальные цены на каждый из типов продукции.
Вывод: maker, максимальная цена на ноутбуки, максимальная цена на ПК, максимальная цена на принтеры.
Для отсутствующих продуктов/цен использовать NULL. */
select 
	product.maker, 
	max(laptop.price) as laptop, 
	max(pc.price) as pc, 
	max(printer.price) as printer
from product
left join pc on product.model = pc.model
left join laptop on product.model = laptop.model
left join printer on product.model = printer.model
group by product.maker
having 
	max(laptop.price) is not null or 
	max(pc.price) is not null or 
	max(printer.price) is not null


/* Задание: 80 (Baser: 2011-11-11)
Найти производителей любой компьютерной техники, у которых нет моделей ПК, не представленных в таблице PC.*/

-- Список моделей в таблице PC
select distinct product.model
from product
join pc
on product.model = pc.model
where product.type = 'PC'

-- Список производителей, которые имеют записи в таблице PC
select distinct product.maker
from product
where product.model not in (
	select distinct product.model
	from product
	join pc
	on product.model = pc.model
	where product.type = 'PC'
);

-- mysql/mssql
select distinct product.maker
from product
where product.maker not in (
select distinct product.maker
from product
where product.model not in (
	select distinct product.model
	from product
	join pc
	on product.model = pc.model
	where product.type = 'PC'
)
and product.type = 'PC')
order by product.maker;

-- only mssql
select distinct product.maker
from product
except
select distinct product.maker
from product
where product.model not in (
	select distinct product.model
	from product
	join pc
	on product.model = pc.model
	where product.type = 'PC')
and product.type = 'PC';


/* Задание: 85 (Serge I: 2012-03-16)
Найти производителей, которые выпускают только принтеры или только PC.
При этом искомые производители PC должны выпускать не менее 3 моделей. */
select S.maker from (
	select product.maker, count(*) as count
	from product
	where product.type = 'PC' and product.maker not in 
		(select distinct product.maker from product where product.type = 'Laptop' or product.type = 'Printer')
	group by product.maker
	having count(*) >= 3
		union 
	select product.maker, count(*)
	from product
	where product.type = 'Printer' and product.maker not in 
		(select distinct product.maker from product where product.type = 'PC' or product.type = 'Laptop')
	group by product.maker
) as S


/* Задание: 86 (Serge I: 2012-04-20)
Для каждого производителя перечислить в алфавитном порядке с разделителем "/" все типы выпускаемой им продукции.
Вывод: maker, список типов продукции */

-- Объединение всех записей
select product.maker, string_agg(product.type,'/') within group (order by product.type asc) as types
from product
group by product.maker
order by product.maker

-- Объединение уникальных записей (конечный результат)
select P.maker, string_agg(P.type,'/') within group (order by P.type asc) as types
from (
	select distinct product.maker, product.type
	from product
) as P
group by P.maker

select * from

(select product.maker, count(product.model) as count
from product
group by product.maker
having count = (
	select count(product.model) as count
	from product
	group by product.maker
	order by count desc
	limit 1
)
union
select product.maker, count(product.model) as count
from product
group by product.maker
having count = (
	select count(product.model) as count
	from product
	group by product.maker
	order by count asc
	limit 1
)) as P


/* Задание: 89 (Serge I: 2012-05-04)
Найти производителей, у которых больше всего моделей в таблице Product, а также тех, у которых меньше всего моделей. Вывод: maker, число моделей */

-- mysql
select product.maker, count(product.model) as count
from product
group by product.maker
having 
	count = (
		select count(product.model) as count
		from product
		group by product.maker
		order by count desc
		limit 1
	) or count = (
		select count(product.model) as count
		from product
		group by product.maker
		order by count asc
		limit 1
	);

-- mssql
select product.maker, count(product.model) as cnt
from product
group by product.maker
having count(product.model) = (
	select max(count) from (
		select count(product.model) as count
		from product
		group by product.maker
	) as P_COUNT
) or count(product.model) = (
	select min(count) from (
		select count(product.model) as count
		from product
		group by product.maker
	) as P_COUNT
);

/* Задание: 90 (Serge I: 2012-05-04)
Вывести все строки из таблицы Product, кроме трех строк с наименьшими номерами моделей и трех строк с наибольшими номерами моделей. */

-- mysql
select * 
from product
where product.model not in (
	select * from ((
		select product.model
		from product
		order by product.model desc
		limit 3
		) union all (
		select product.model
		from product
		order by product.model asc
		limit 3
	)) as M
)

-- mssql
select * 
from product
where product.model not in (
	select * from ((
		select top 3 product.model
		from product
		order by product.model desc
		) union all (
		select top 3 product.model
		from product
		order by product.model asc
	)) as M
)


/* Задание: 144 (Serge I: 2019-01-04)
Найти производителей, которые производят PC как с самой низкой ценой, так и с самой высокой. Вывод: maker */

-- mssql
select product.maker
from product
join pc
on product.model = pc.model
where pc.price = (
	select max(pc.price)
	from product
	join pc
	on product.model = pc.model
)
intersect
select product.maker
from product
join pc
on product.model = pc.model
where pc.price = (
	select min(pc.price)
	from product
	join pc
	on product.model = pc.model
)

-- mysql
select distinct P1.maker 
from (
	select product.maker
	from product
	join pc
	on product.model = pc.model
	where pc.price = (
		select max(pc.price)
		from product
		join pc
		on product.model = pc.model
	)
) as P1
join (
	select product.maker
	from product
	join pc
	on product.model = pc.model
	where pc.price = (
		select min(pc.price)
		from product
		join pc
		on product.model = pc.model
	)
) as P2
on P1.maker = P2.maker

-- Этот вариант неправильный, так как он не учитывает пересечение производителей
select distinct product.maker
from product
join pc
on product.model = pc.model
where pc.price = (
	select max(pc.price)
	from product
	join pc
	on product.model = pc.model
) and price = ( 
	select min(pc.price)
	from product
	join pc
	on product.model = pc.model
)


/*Задание: 146 (Serge I: 2008-08-30)
Для ПК с максимальным кодом из таблицы PC вывести все его характеристики (кроме кода) в два столбца:
- название характеристики (имя соответствующего столбца в таблице PC);
- значение характеристики*/

-- mysql
select 
	'model' as chr,
    (select pc.model from pc where pc.code = (select max(pc.code) as code from pc) + '') as value
union all
select 
	'speed' as chr,
    (select pc.speed from pc where pc.code = (select max(pc.code) as code from pc) + '') as value
union all
select 
	'ram' as chr,
    (select pc.ram from pc where pc.code = (select max(pc.code) as code from pc) + '') as value
union all
select 
	'hd' as chr,
    (select pc.hd from pc where pc.code = (select max(pc.code) as code from pc) + '') as value
union all
select 
	'cd' as chr,
    (select pc.cd from pc where pc.code = (select max(pc.code) as code from pc) + '') as value
union all
select 
	'price' as chr,
    (select pc.price from pc where pc.code = (select max(pc.code) as code from pc) + '') as value