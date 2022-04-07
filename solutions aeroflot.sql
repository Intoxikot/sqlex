/* Задание: 63 (Serge I: 2003-04-08)
Определить имена разных пассажиров, когда-либо летевших на одном и том же месте более одного раза. */

-- Не учитывает случай, когда имена пасссажиров могут совпадать, когда фактически это два разных пассажира
select distinct name
from pass_in_trip
join passenger
on pass_in_trip.id_psg = passenger.id_psg
group by pass_in_trip.place, pass_in_trip.id_psg
having count(pass_in_trip.place) > 1

-- Решение
select passenger.name
from passenger
where 
	passenger.id_psg in (
		select distinct pass_in_trip.id_psg
		from pass_in_trip
		group by pass_in_trip.place, pass_in_trip.id_psg
		having count(*) > 1
	)


/* Задание: 66 (Serge I: 2003-04-09)
Для всех дней в интервале с 01/04/2003 по 07/04/2003 определить число рейсов из Rostov.
Вывод: дата, количество рейсов */
select 
	date_format(N.date, '%Y-%m-%d 00:00:00') as date, 
	ifnull(R.count, 0) as count
from (
	select 
		cast(concat('2003-04-0', N.n) as date) as date
	from (
		select 1 as n 
		union select 2
		union select 3
		union select 4
		union select 5
		union select 6
		union select 7
	) as N
) as N
left join (
	select R.date, count(*) as count from (
		select pass_in_trip.trip_no, pass_in_trip.date
		from pass_in_trip
		left join trip
		on trip.trip_no = pass_in_trip.trip_no
		where pass_in_trip.date >= '2003-04-01' and pass_in_trip.date <= '2003-04-07' and trip.town_from = 'Rostov'
		group by pass_in_trip.trip_no, pass_in_trip.date
		order by pass_in_trip.date
	) as R
	group by R.date
) as R
on date_format(N.date, 'Y%-%m-%d') = date_format(R.date, 'Y%-%m-%d')
order by date


/* Задание: 67 (Serge I: 2010-03-27)
Найти количество маршрутов, которые обслуживаются наибольшим числом рейсов.
Замечания.
1) A - B и B - A считать РАЗНЫМИ маршрутами.
2) Использовать только таблицу Trip */

-- Суммарное количество рейсов на каждый маршрут
select trip.town_from, trip.town_to, count(trip.trip_no) as count
from trip
group by trip.town_from, trip.town_to

-- Маршруты с максимальным количеством рейсов
select trip.town_from, trip.town_to, count(*) as count
	from trip
	group by trip.town_from, trip.town_to
	having count = (
		select max(count) from
			(select count(trip.trip_no) as count
			from trip
			group by trip.town_from, trip.town_to) as C
	)

-- Решение. Количество маршрутов с максимальным количеством рейсов
select count(*) as count_max from (
	select trip.town_from, trip.town_to, count(*) as count
	from trip
	group by trip.town_from, trip.town_to
	having count = (
		select max(count) from
			(select count(trip.trip_no) as count
			from trip
			group by trip.town_from, trip.town_to) as C
	)
) as C
group by C.count


/* Задание: 76 (Serge I: 2003-08-28)
Определить время, проведенное в полетах, для пассажиров, летавших всегда на разных местах. Вывод: имя пассажира, время в минутах. */

-- Пассажиры и их рейсы
select *
from passenger, pass_in_trip
where pass_in_trip.id_psg = passenger.id_psg

-- Пассажиры и их рейсы (подробно)
select *
from passenger, pass_in_trip
left join trip
on pass_in_trip.trip_no = trip.trip_no
where pass_in_trip.id_psg = passenger.id_psg

-- Пассажиры и их рейсы со временем полета 
-- т.к. даты в рейсах всегда одинаковы, нужно прибавить 1 день к датам, где trip.time_out > trip.time_in
select *, timestampdiff(minute, trip.time_out, 
	case
		when trip.time_out < trip.time_in then trip.time_in
        else adddate(trip.time_in, interval 1 day)
	end) as fly_time
from passenger, pass_in_trip
left join trip
on pass_in_trip.trip_no = trip.trip_no
where pass_in_trip.id_psg = passenger.id_psg

-- Пассажиры и их общее суммарное время полета за все рейсы
select passenger.id_psg, sum(timestampdiff(minute, trip.time_out, 
	case
		when trip.time_out < trip.time_in then trip.time_in
        else adddate(trip.time_in, interval 1 day)
	end)) as fly_time
from passenger, pass_in_trip
left join trip
on pass_in_trip.trip_no = trip.trip_no
where pass_in_trip.id_psg = passenger.id_psg
group by passenger.id_psg

-- Пассажиры и количество рейсов на каждом из мест
select passenger.id_psg, pass_in_trip.place, count(*) as place_count
from passenger, pass_in_trip
where pass_in_trip.id_psg = passenger.id_psg
group by id_psg, pass_in_trip.place

-- Пассажиры, которые летали на одном месте более 1 раза
select passenger.id_psg
from passenger, pass_in_trip
where pass_in_trip.id_psg = passenger.id_psg
group by passenger.id_psg, pass_in_trip.place
having count(passenger.id_psg) > 1

-- Решение
select passenger.name, sum(timestampdiff(minute, trip.time_out, 
	case
		when trip.time_out < trip.time_in then trip.time_in
        else adddate(trip.time_in, interval 1 day)
	end)) as fly_time
from passenger, pass_in_trip
left join trip
on pass_in_trip.trip_no = trip.trip_no
where 
	pass_in_trip.id_psg = passenger.id_psg 
	and passenger.id_psg not in (
		select passenger.id_psg
		from passenger, pass_in_trip
		where pass_in_trip.id_psg = passenger.id_psg
		group by passenger.id_psg, pass_in_trip.place
		having count(passenger.id_psg) > 1
	)
group by passenger.id_psg
order by passenger.name


/* Задание: 79 (Serge I: 2003-04-29)
Определить пассажиров, которые больше других времени провели в полетах.
Вывод: имя пассажира, общее время в минутах, проведенное в полетах */

-- Пассажиры и их суммарное время полета
select 
	passenger.id_psg, sum(timestampdiff(minute, trip.time_out, 
		case
			when trip.time_out < trip.time_in then trip.time_in
			else adddate(trip.time_in, interval 1 day)
		end)
	) as fly_time
from passenger, pass_in_trip
left join trip
on pass_in_trip.trip_no = trip.trip_no
where pass_in_trip.id_psg = passenger.id_psg
group by passenger.id_psg

-- Максимальное время полета среди всех пассажиров
select 
	max(F.fly_time)   
from (
	select passenger.id_psg, sum(timestampdiff(minute, trip.time_out, 
		case
			when trip.time_out < trip.time_in then trip.time_in
			else adddate(trip.time_in, interval 1 day)
		end)
	) as fly_time
	from passenger, pass_in_trip
	left join trip
	on pass_in_trip.trip_no = trip.trip_no
	where pass_in_trip.id_psg = passenger.id_psg
	group by passenger.id_psg
) as F

-- Решение
select 
	passenger.name, sum(timestampdiff(minute, trip.time_out, 
		case
			when trip.time_out < trip.time_in then trip.time_in
			else adddate(trip.time_in, interval 1 day)
		end)
	) as fly_time
from passenger, pass_in_trip
left join trip
on pass_in_trip.trip_no = trip.trip_no
where pass_in_trip.id_psg = passenger.id_psg
group by passenger.id_psg
having 
	fly_time = (
		select max(F.fly_time)   
		from (
			select passenger.id_psg, sum(timestampdiff(minute, trip.time_out, 
				case
					when trip.time_out < trip.time_in then trip.time_in
					else adddate(trip.time_in, interval 1 day)
				end)) as fly_time
			from passenger, pass_in_trip
			left join trip
			on pass_in_trip.trip_no = trip.trip_no
			where pass_in_trip.id_psg = passenger.id_psg
			group by passenger.id_psg
		) as F
	)
	
	
/*Задание: 95 (qwrqwr: 2013-02-08)
На основании информации из таблицы Pass_in_Trip, для каждой авиакомпании определить:
1) количество выполненных перелетов;
2) число использованных типов самолетов;
3) количество перевезенных различных пассажиров;
4) общее число перевезенных компанией пассажиров.
Вывод: Название компании, 1), 2), 3), 4).*/

-- Шаблон запроса
select *
from pass_in_trip
join trip
on pass_in_trip.trip_no = trip.trip_no;

-- Список всех рейсов: компания, рейс, дата
select trip.id_comp, pass_in_trip.trip_no, pass_in_trip.date
from pass_in_trip
join trip
on pass_in_trip.trip_no = trip.trip_no
group by pass_in_trip.date, trip.trip_no;

-- 1. Количество выполненных перелетов для каждой компании (flights)
select id_comp, count(*) as flights
from (
	select trip.id_comp, pass_in_trip.trip_no, pass_in_trip.date
	from pass_in_trip
	join trip
	on pass_in_trip.trip_no = trip.trip_no
	group by pass_in_trip.date, trip.trip_no
) as flights
group by id_comp;

-- Проверка первого значения (просмотр)
select company.id_comp, company.name, count(*) as flights
from (
	select trip.id_comp, pass_in_trip.trip_no, pass_in_trip.date
	from pass_in_trip
	join trip
	on pass_in_trip.trip_no = trip.trip_no
	group by pass_in_trip.date, trip.trip_no
) as flights
join company on flights.id_comp = company.id_comp
group by flights.id_comp
order by company.name;

-- 2. Число использованных типов самолетов для каждой компании (planes)
select id_comp, count(*) as unique_planes
from (
	select id_comp, plane
	from pass_in_trip
	join trip
	on pass_in_trip.trip_no = trip.trip_no
	group by id_comp, plane
) as unique_planes
group by id_comp;

-- Проверка второго значения (просмотр)
select company.id_comp, company.name, count(*) as unique_planes
from (
	select id_comp, plane
	from pass_in_trip
	join trip
	on pass_in_trip.trip_no = trip.trip_no
	group by id_comp, plane
) as unique_planes
join company on company.id_comp = unique_planes.id_comp
group by company.id_comp
order by company.name;

-- 3. Количество перевезенных различных пассажиров
select id_comp, count(*) as unique_passengers
from (
    select id_comp, id_psg
	from pass_in_trip
	join trip
	on pass_in_trip.trip_no = trip.trip_no
	group by id_comp, pass_in_trip.id_psg
) as unique_passengers
group by id_comp;

-- Проверка третьего значения (просмотр)
select company.id_comp, company.name, count(*) as unique_passengers
from (
    select id_comp, id_psg
	from pass_in_trip
	join trip
	on pass_in_trip.trip_no = trip.trip_no
	group by id_comp, pass_in_trip.id_psg
) as unique_passengers
join company on unique_passengers.id_comp = company.id_comp
group by company.id_comp
order by company.name;

-- 4. Общее число перевезенных компанией пассажиров (total_passengers)
select id_comp, count(*) as total_passengers
from pass_in_trip
join trip
on pass_in_trip.trip_no = trip.trip_no
group by id_comp;

-- Проверка четвертого значения (просмотр)
select company.id_comp, company.name, count(*) as total_passengers
from pass_in_trip
join trip on pass_in_trip.trip_no = trip.trip_no
join company on company.id_comp = trip.id_comp
group by id_comp;

-- Решение
select 
	company.name as company, 
    flights.count as flights, 
    unique_planes.count as unique_planes,
    unique_passengers.count as unique_passengers,
    total_passengers.count as total_passengers
from company
join (
	select id_comp, count(*) as count
	from (
		select trip.id_comp, pass_in_trip.trip_no, pass_in_trip.date
		from pass_in_trip
		join trip
		on pass_in_trip.trip_no = trip.trip_no
		group by pass_in_trip.date, trip.trip_no
	) as flights
	group by id_comp
) as flights on company.id_comp = flights.id_comp
join (
	select id_comp, count(*) as count
	from (
		select id_comp, plane
		from pass_in_trip
		join trip
		on pass_in_trip.trip_no = trip.trip_no
		group by id_comp, plane
	) as unique_planes
	group by id_comp
) as unique_planes on company.id_comp = unique_planes.id_comp
join (
	select id_comp, count(*) as count
	from (
		select id_comp, id_psg
		from pass_in_trip
		join trip
		on pass_in_trip.trip_no = trip.trip_no
		group by id_comp, pass_in_trip.id_psg
	) as unique_passengers
	group by id_comp
) as unique_passengers on company.id_comp = unique_passengers.id_comp
join  (
	select id_comp, count(*) as count
	from pass_in_trip
	join trip
	on pass_in_trip.trip_no = trip.trip_no
	group by id_comp
) as total_passengers on company.id_comp = total_passengers.id_comp
order by company.name


/* Задание: 114 (Serge I: 2003-04-08)
Определить имена разных пассажиров, которым чаще других доводилось лететь на одном и том же месте. Вывод: имя и количество полетов на одном и том же месте. */

-- Максимальное количество полетов на одном месте
select max(count) as max
from (	
    select count(*) as count
	from pass_in_trip
	group by id_psg, place 
) as T

-- Конечный результат (группировка по id_psg позволяет избежать дубликатов)
select passenger.name, T.count_similar_place
from passenger
join (
	select pass_in_trip.id_psg, count(*) as count_similar_place
	from pass_in_trip
	group by pass_in_trip.id_psg, pass_in_trip.place 
	having count(*) = (
		select max(count) as max
		from (	
			select count(*) as count
			from pass_in_trip
			group by id_psg, place 
		) as T
	)
) as T on T.id_psg = passenger.id_psg
group by T.id_psg


/* Задание: 142 (Serge I: 2003-08-28)
Среди пассажиров, летавших на самолетах только одного типа, определить тех, кто прилетал в один и тот же город не менее 2-х раз. Вывести имена пассажиров. */

-- Пассажиры и уникальные типы самолетов
select distinct pass_in_trip.id_psg, trip.plane
from pass_in_trip
left join trip on pass_in_trip.trip_no = trip.trip_no
group by pass_in_trip.id_psg, trip.plane

-- Пассажиры летающие только на одном типе самолета 
-- (необходима внешняя группировка, для подсчета типов самолетов)
select planes.id_psg
from (
	select distinct pass_in_trip.id_psg, trip.plane
	from pass_in_trip
	join trip on pass_in_trip.trip_no = trip.trip_no
	group by pass_in_trip.id_psg, trip.plane
) as planes
group by planes.id_psg
having count(*) = 1

-- Пассажиры и количество прилетов в один город
select pass_in_trip.id_psg, trip.town_to, count(*)
from pass_in_trip
left join trip on pass_in_trip.trip_no = trip.trip_no
group by pass_in_trip.id_psg, trip.town_to

-- Пассажиры, которые прилетали в один и тот же город не менее 2-х раз
select distinct pass_in_trip.id_psg
from pass_in_trip
left join trip on pass_in_trip.trip_no = trip.trip_no
group by pass_in_trip.id_psg, trip.town_to
having count(*) >= 2

-- Решение
select passenger.name
from passenger
where 
	passenger.id_psg in (
		select planes.id_psg
		from (
			select distinct pass_in_trip.id_psg, trip.plane
			from pass_in_trip
			join trip on pass_in_trip.trip_no = trip.trip_no
			group by pass_in_trip.id_psg, trip.plane
		) as planes
		group by planes.id_psg
		having count(*) = 1
	) and passenger.id_psg in (
		select distinct pass_in_trip.id_psg
		from pass_in_trip
		join trip on pass_in_trip.trip_no = trip.trip_no
		group by pass_in_trip.id_psg, trip.town_to
		having count(*) >= 2
    )


/* Задание: 155 (pаparome: 2005-12-02)
Предполагая, что не существует номера рейса большего 65535,
вывести номер рейса и его представление в двоичной системе счисления (без ведущих нулей) */
select
	trip.trip_no, 
    bin(trip.trip_no) as bin
from trip