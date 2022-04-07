/* 
	Задачи по DML ввиду своей специфики не разделены по базам данных и находятся в отдельном файле
*/


/* Задание: 1 (Serge I: 2004-09-08)
Добавить в таблицу PC следующую модель:
code: 20, model: 2111, speed: 950, ram: 512, hd: 60, cd: 52x, price: 1100 */
insert into pc(code, model, speed, ram, hd, cd, price) values (20, 2111, 950, 512, 60,' 52x', 1100);


/* Задание: 2 (Serge I: 2004-09-08)
Добавить в таблицу Product следующие продукты производителя Z:
принтер модели 4003, ПК модели 4001 и блокнот модели 4002 */
insert into product(maker, model, type) values 
('Z', 4003, 'printer'), ('Z', 4001, 'PC'), ('Z', 4002, 'Laptop');


/* Задание: 3 (Serge I: 2004-09-08)
Добавить в таблицу PC модель 4444 с кодом 22, имеющую скорость процессора 1200 и цену 1350. Отсутствующие характеристики должны быть восполнены значениями по умолчанию, принятыми для соответствующих столбцов.*/

-- Через default
insert into pc(code, model, speed, ram, hd, cd, price) values 
(22, 4444, 1200, default, default, default, 1350);

-- Без default
insert into pc(code, model, speed, price) values
(22, 4444, 1200, 1350);


/* Задание: 4 (Serge I: 2004-09-08)
Для каждой группы блокнотов с одинаковым номером модели добавить запись в таблицу PC со следующими характеристиками:
код: минимальный код блокнота в группе +20;
модель: номер модели блокнота +1000;
скорость: максимальная скорость блокнота в группе;
ram: максимальный объем ram блокнота в группе *2;
hd: максимальный объем hd блокнота в группе *2;
cd: значение по умолчанию;
цена: максимальная цена блокнота в группе, уменьшенная в 1,5 раза.
Замечание. Считать номер модели числом. */
insert into pc(code, model, speed, ram, hd, price)
select 
	(min(laptop.code) + 20) as code,
	(cast(laptop.model as int) + 1000) as model,
	max(laptop.speed) as speed,
	max(laptop.ram) * 2 as ram, 
	max(laptop.hd) * 2 as hd,
	max(laptop.price / 1.5) as price
from laptop
group by laptop.model


/* Задание: 5 (Serge I: 2004-09-08)
Удалить из таблицы PC компьютеры, имеющие минимальный объем диска или памяти. */
delete from 
	pc 
where 
	pc.hd = (
		select min(pc.hd)
		from pc
) or
	pc.ram = (
		select min(pc.ram)
		from pc
);


/* Задание: 6 (Serge I: 2004-09-08)
Удалить все блокноты, выпускаемые производителями, которые не выпускают принтеры. */

-- Производители принтеров
select distinct product.maker from product where product.type = 'printer';

-- Решение
delete from laptop where laptop.code in (
	select L.code
	from laptop as L
	right join product as P
	on L.model = P.model 
	where 
		P.maker not in (select distinct product.maker from product where product.type = 'printer') and 
		type = 'Laptop'
);


/* Задание: 7 (Serge I: 2004-09-08)
Производство принтеров производитель A передал производителю Z. Выполнить соответствующее изменение. */
update product 
set product.maker = 'Z'
where product.maker = 'A' and product.type = 'Printer';


/* Задание: 8 (Serge I: 2004-09-08)
Удалите из таблицы Ships все корабли, потопленные в сражениях. */
delete from ships 
where ships.name in (
	select ships.name
	from ships
	join outcomes
	on outcomes.ship = ships.name
	where outcomes.result = 'sunk'
);


/* Задание: 9 (Serge I: 2004-09-08)
Измените данные в таблице Classes так, чтобы калибры орудий измерялись в сантиметрах (1 дюйм=2,5см), а водоизмещение в метрических тоннах (1 метрическая тонна = 1,1 тонны). Водоизмещение вычислить с точностью до
целых. */
update 
	classes
set 
	classes.bore = classes.bore * 2.5, 
	classes.displacement = round(classes.displacement / 1.1, 0);


/* Задание: 10 (Serge I: 2004-09-09)
Добавить в таблицу PC те модели ПК из Product, которые отсутствуют в таблице PC.
При этом модели должны иметь следующие характеристики:
1. Код равен номеру модели плюс максимальный код, который был до вставки.
2. Скорость, объем памяти и диска, а также скорость CD должны иметь максимальные характеристики среди всех имеющихся в таблице PC.
3. Цена должна быть средней среди всех ПК, имевшихся в таблице PC до вставки. */

-- Выборка отсутствующих моделей
select product.model
from product
left join pc
on product.model = pc.model
where product.type = 'PC' and pc.code is null

-- Выборка основных значений
select 
	max(pc.code) as code, 
    max(pc.speed) as speed, 
    max(pc.ram) as ram, 
    max(pc.hd) as hd, 
    max(pc.cd) as cd, 
    avg(pc.price) as price
from pc;

-- Финальная выборка
select 
	(P.model + C.code) as code, 
    P.model as model,
    C.speed as speed,
    C.ram as ram,
    C.hd as hd,
    C.cd as cd,
    C.price as price
from (
    select product.model
	from product
	left join pc
	on product.model = pc.model
	where product.type = 'PC' and pc.code is null
) as P, ( 
	select 
		max(pc.code) as code, 
		max(pc.speed) as speed, 
		max(pc.ram) as ram, 
		max(pc.hd) as hd, 
		max(pc.cd) as cd, 
		avg(pc.price) as price
	from pc
) as C

-- Результирующий запрос
insert into pc(code, model, speed, ram, hd, cd, price)
select 
	(P.model + C.code) as code, 
    P.model as model,
    C.speed as speed,
    C.ram as ram,
    C.hd as hd,
    C.cd as cd,
    C.price as price
from (
    select product.model
	from product
	left join pc
	on product.model = pc.model
	where product.type = 'PC' and pc.code is null
) as P, ( 
	select 
		max(pc.code) as code, 
		max(pc.speed) as speed, 
		max(pc.ram) as ram, 
		max(pc.hd) as hd,
        concat(
			max(
				cast(replace(pc.cd, 'x', '') as decimal(2))
			), 'x'
		) as cd, 
		avg(pc.price) as price
	from pc
) as C


/* Задание: 11 (Serge I: 2004-09-09)
Для каждой группы блокнотов с одинаковым номером модели добавить запись в таблицу PC со следующими характеристиками:
код: минимальный код блокнота в группе +20;
модель: номер модели блокнота +1000;
скорость: максимальная скорость блокнота в группе;
ram: максимальный объем ram блокнота в группе *2;
hd: максимальный объем hd блокнота в группе *2;
cd: cd c максимальной скоростью среди всех ПК;
цена: максимальная цена блокнота в группе, уменьшенная в 1,5 раза */

-- Решение во многом повторяет 4-ое задание, совмещенное с 10-ым 
insert into pc(code, model, speed, ram, hd, cd, price)
select 
	(min(laptop.code) + 20) as code,
	(cast(laptop.model as decimal) + 1000) as model,
	max(laptop.speed) as speed,
	max(laptop.ram) * 2 as ram, 
	max(laptop.hd) * 2 as hd,
    concat(
			max(
				cast(replace(C.cd, 'x', '') as decimal(2))
			), 'x'
	) as cd,
	max(laptop.price / 1.5) as price
from laptop
cross join
	(select distinct pc.cd from pc) as C
group by laptop.model;


/*Задание: 12 (Serge I: 2004-09-09)
Добавьте один дюйм к размеру экрана каждого блокнота,
выпущенного производителями E и B, и уменьшите его цену на $100.*/
update laptop
set laptop.screen = laptop.screen + 1, laptop.price = laptop.price - 100
where laptop.model in (
	select distinct laptop.model
	from product
	join laptop
	on laptop.model = product.model
	where product.maker = 'E' or  product.maker = 'B'
)


/* Задание: 13 (Serge I: 2004-09-09)
Ввести в базу данных информацию о том, что корабль Rodney был потоплен в битве, произошедшей 25/10/1944, а корабль Nelson поврежден - 28/01/1945.
Замечание: считать, что дата битвы уникальна в таблице Battles. */
insert into 
	outcomes(ship, result, battle)
values (
	'Rodney', 
    'sunk', 
    (
		select distinct battles.name
		from battles
		where battles.date = '1944-10-25'
    )
), (
	'Nelson', 
    'damaged', (
		select distinct battles.name
		from battles
		where battles.date = '1945-01-28'
    )
);