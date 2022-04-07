/* Задание: 14 (Serge I: 2002-11-05)
Найдите класс, имя и страну для кораблей из таблицы Ships, имеющих не менее 10 орудий. */
select ships.class, ships.name, classes.country
from ships
join classes
on classes.class = ships.class
where classes.numGuns >= 10


/* Задание: 31 (Serge I: 2002-10-22)
Для классов кораблей, калибр орудий которых не менее 16 дюймов, укажите класс и страну. */
select classes.class, classes.country
from classes 
where classes.bore >= 16;


/* Задание: 33 (Serge I: 2002-11-02)
Укажите корабли, потопленные в сражениях в Северной Атлантике (North Atlantic). Вывод: ship. */
select outcomes.ship
from outcomes
where battle = 'North Atlantic' and result = 'sunk'


/* Задание: 34 (Serge I: 2002-11-04)
По Вашингтонскому международному договору от начала 1922 г. запрещалось строить линейные корабли водоизмещением более 35 тыс.тонн. Укажите корабли, нарушившие этот договор (учитывать только корабли c известным годом спуска на воду). Вывести названия кораблей. */
select distinct ships.name
from ships, classes
where 
	ships.class = classes.class and 
	ships.launched >= 1922 and
	classes.displacement > 35000 and 
	classes.type = 'bb'


/* Задание: 38 (Serge I: 2003-02-19)
Найдите страны, имевшие когда-либо классы обычных боевых кораблей ('bb') и имевшие когда-либо классы крейсеров ('bc'). */
select classes.country
from classes
where type = 'bb'
	intersect
select classes.country
from classes
where type = 'bc';


/* Задание: 42 (Serge I: 2002-11-05)
Найдите названия кораблей, потопленных в сражениях, и название сражения, в котором они были потоплены. */
select outcomes.ship, battles.name
from outcomes
join battles
on outcomes.battle = battles.name
where outcomes.result = 'sunk';


/* Задание: 43 (qwrqwr: 2011-10-28)
Укажите сражения, которые произошли в годы, не совпадающие ни с одним из годов спуска кораблей на воду. */
select name
from battles
where 
	datepart(year, battles.date) not in (select launched from ships where launched is not null);


/* Задание: 44 (Serge I: 2002-12-04)
Найдите названия всех кораблей в базе данных, начинающихся с буквы R.*/
select distinct T.name
from (
	select name 
	from ships 
	union
	select ship from 
	outcomes) 
as T
where T.name like 'R%';


/* Задание: 45 (Serge I: 2002-12-04)
Найдите названия всех кораблей в базе данных, состоящие из трех и более слов (например, King George V).
Считать, что слова в названиях разделяются единичными пробелами, и нет концевых пробелов. */
select distinct T.name
from (
	select name 
	from ships 
	union
	select ship from 
	outcomes) 
as T
where T.name like '% % %';


/* Задание: 50 (Serge I: 2002-11-05)
Найдите сражения, в которых участвовали корабли класса Kongo из таблицы Ships.*/
select distinct outcomes.battle 
from outcomes
join ships
on outcomes.ship = ships.name
join classes
on classes.class = ships.class
where classes.class = 'Kongo'


/* Задание: 52 (qwrqwr: 2010-04-23)
Определить названия всех кораблей из таблицы Ships, которые могут быть линейным японским кораблем,
имеющим число главных орудий не менее девяти, калибр орудий менее 19 дюймов и водоизмещение не более 65 тыс.тонн */
select distinct ships.name
from ships
left join classes
on ships.class = classes.class
where 
    classes.type = 'bb' and 
    classes.country = 'Japan' and 
    (classes.numGuns >= 9 or classes.numGuns is null) and 
    (classes.bore < 19.0 or classes.bore is null) and 
    (classes.displacement <= 65000 or classes.displacement is null)


/* Задание: 53 (Serge I: 2002-11-05)
Определите среднее число орудий для классов линейных кораблей.
Получить результат с точностью до 2-х десятичных знаков. */
select convert(numeric(4,2), avg(classes.numGuns*1.0))
from classes
where classes.type = 'bb'


/* Задание: 70 (Serge I: 2003-02-14)
Укажите сражения, в которых участвовало по меньшей мере три корабля одной и той же страны. */
select distinct B.battle
from (
	select o.battle as battle, c.country, c.class
	from Outcomes o, Ships s, Classes c
	where 
		o.ship = s.name and
		s.class = c.class
	union all
	select o.battle as battle, c.country, c.class
	from Outcomes o, Classes c
	where 
		o.ship = c.class and
		o.ship not in (select name from ships)
) as B
group by B.battle, B.country 
having count(*) >= 3


/* Задание: 73 (Serge I: 2009-04-17)
Для каждой страны определить сражения, в которых не участвовали корабли данной страны.
Вывод: страна, сражение */
select distinct classes.country, battles.name
from classes
cross join battles
except
select distinct B.country, B.battle
from (
	select o.battle as battle, c.country, c.class
	from Outcomes o, Ships s, Classes c
	where 
		o.ship = s.name and
		s.class = c.class
	union all
	select o.battle as battle, c.country, c.class
	from Outcomes o, Classes c
	where 
		o.ship = c.class and
		o.ship not in (select name from ships)
) as B
group by B.battle, B.country


/* Задание: 74 (dorin_larsen: 2007-03-23)
Вывести классы всех кораблей России (Russia). Если в базе данных нет классов кораблей России, вывести классы для всех имеющихся в БД стран.
Вывод: страна, класс */
select classes.country, classes.class
from classes
where classes.country like
	(case
		when exists (select distinct classes.country from classes where classes.country = 'Russia') then 'Russia'
        else '%'
	end)

/* Задание: 78 (Serge I: 2005-01-19)
Для каждого сражения определить первый и последний день
месяца, в котором оно состоялось. Вывод: сражение, первый день месяца, последний день месяца.
Замечание: даты представить без времени в формате "yyyy-mm-dd". */

-- mysql	
select 
	battles.name,
	battles.date - interval (day(battles.date)) day + interval 1 day as first_day, 
	battles.date - interval (day(battles.date)) day + interval 1 day + interval 1 month - interval 1 day as last_day
from battles	

-- postgresql
select 
	battles.name,
	datefromparts(year(battles.date), month(battles.date), 1),
	dateadd(dd, -1, 
		dateadd(mm, 1, datefromparts(year(battles.date), month(battles.date), 1))
	)
from battles

