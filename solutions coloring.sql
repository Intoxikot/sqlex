/* Задание: 92 (ZrenBy: 2003-09-01)
Выбрать все белые квадраты, которые окрашивались только из баллончиков,
пустых к настоящему времени. Вывести имя квадрата */

-- Только белые квадраты (если white = {R=255, G=255, B=255})
select b_q_id
from
    (select
		b_q_id, 
		sum(b_vol) as vol
	from utb
	left join utv on utv.v_id = utb.b_v_id
	group by b_q_id, utv.v_color
	having vol = 255) as V
group by b_q_id
having count(*) = 3

-- Пустые баллончики
select b_v_id
from utb
group by b_v_id
having sum(b_vol) = 255

-- Решение. Белые квадраты, окрашенные только баллончиками, пустыми к настоящему времени
select q_name
from
    (select
		b_q_id, 
		sum(b_vol) as vol
	from utb
	left join utv on utv.v_id = utb.b_v_id
    where utb.b_v_id in (
		select b_v_id
		from utb
		group by b_v_id
		having sum(b_vol) = 255
	)
	group by b_q_id, utv.v_color
	having vol = 255) as V
left join utq on utq.q_id = V.b_q_id
group by b_q_id
having count(*) = 3


/* Задание: 96 (ZrenBy: 2003-09-01)
При условии, что баллончики с красной краской использовались более одного раза, выбрать из них такие, которыми окрашены квадраты, имеющие голубую компоненту.
Вывести название баллончика */

-- Список по использованию красных баллончиков
select *
from utb as painting
join utv as ballon
on painting.b_v_id = ballon.v_id 
where ballon.v_color = 'R'

-- Красные баллончики, использовавшеся при окраске более одного раза
select ballon.v_id
from utb as painting
join utv as ballon
on painting.b_v_id = ballon.v_id 
where ballon.v_color = 'R'
group by ballon.v_id
having count(*) > 1

-- Квадраты, имеющие синий цвет в окраске
select distinct b_q_id
from utb as painting
join utv as ballon
on painting.b_v_id = ballon.v_id 
where ballon.v_color = 'B'

-- Вероятный ответ (неверно)
select ballon.v_name
from utb as painting
join utv as ballon
on painting.b_v_id = ballon.v_id 
where ballon.v_color = 'R' and b_q_id in (
		select distinct b_q_id
		from utb as painting
		join utv as ballon
		on painting.b_v_id = ballon.v_id 
		where ballon.v_color = 'B'
	)
group by ballon.v_id
having count(*) > 1

-- Ответ. Финальная выборка
select ballon.v_name
from utb as painting
join utv as ballon
on painting.b_v_id = ballon.v_id
where
	painting.b_q_id in (
		select distinct b_q_id
		from utb as painting
		join utv as ballon
		on painting.b_v_id = ballon.v_id 
		where ballon.v_color = 'B'
    ) 
    and ballon.v_id in (
		select ballon.v_id
		from utb as painting
		join utv as ballon
		on painting.b_v_id = ballon.v_id 
		where ballon.v_color = 'R'
		group by ballon.v_id
		having count(*) > 1
	)
group by ballon.v_id


/* Задание: 109 (qwrqwr: 2011-01-13)
Вывести:
1. Названия всех квадратов черного или белого цвета.
2. Общее количество белых квадратов.
3. Общее количество черных квадратов. */

-- Только черные квадраты (если окрашиваний вообще не было)
select square.q_id as square_id
from utq as square
left join utb as painting
on square.q_id = painting.b_q_id
where painting.b_q_id is null

-- Только белые квадраты (если white = {R=255, G=255, B=255})
select square_id
from (
    select
		b_q_id as square_id, 
		sum(b_vol) as color_volume
	from utb as painting
	left join utv as ballon on ballon.v_id = painting.b_v_id
	group by square_id, ballon.v_color
	having color_volume = 255
) as volume
group by square_id
having count(*) = 3

-- Список белых и черных квадратов (с указанием цвета)
select square.q_id as square_id, 'black' as color
from utq as square
left join utb as painting
on square.q_id = painting.b_q_id
where painting.b_q_id is null
union
select square_id, 'white' as color
from (
    select
		b_q_id as square_id, 
		sum(b_vol) as color_volume
	from utb as painting
	left join utv as ballon on ballon.v_id = painting.b_v_id
	group by square_id, ballon.v_color
	having color_volume = 255
) as volume
group by square_id
having count(*) = 3
order by color desc, square_id asc 

-- Количество черных и белых квадратов
select count(white_square.color) as white_squares, count(black_square.color) as black_squares
from 
	utq as square
left join (
	select square.q_id as square_id, 'black' as color
	from utq as square
	left join utb as painting
	on square.q_id = painting.b_q_id
	where painting.b_q_id is null
) as black_square
on square.q_id = black_square.square_id
left join (
select square_id, 'white' as color
from (
		select
			b_q_id as square_id, 
			sum(b_vol) as color_volume
		from utb as painting
		left join utv as ballon on ballon.v_id = painting.b_v_id
		group by square_id, ballon.v_color
		having color_volume = 255
	) as volume
	group by square_id
	having count(*) = 3
) as white_square
on square.q_id = white_square.square_id

-- Решение
select square.q_name as name, color_count.white_squares, color_count.black_squares
from (
	select square.q_id as square_id, 'black' as color
	from utq as square
	left join utb as painting
	on square.q_id = painting.b_q_id
	where painting.b_q_id is null
		union
	select square_id, 'white' as color
	from (
		select
			b_q_id as square_id, 
			sum(b_vol) as color_volume
		from utb as painting
		left join utv as ballon on ballon.v_id = painting.b_v_id
		group by square_id, ballon.v_color
		having color_volume = 255
	) as volume
	group by square_id
	having count(*) = 3
) as square_list
cross join (
	select count(white_square.color) as white_squares, count(black_square.color) as black_squares
	from 
		utq as square
	left join (
		select square.q_id as square_id, 'black' as color
		from utq as square
		left join utb as painting
		on square.q_id = painting.b_q_id
		where painting.b_q_id is null
	) as black_square
	on square.q_id = black_square.square_id
	left join (
	select square_id, 'white' as color
	from (
			select
				b_q_id as square_id, 
				sum(b_vol) as color_volume
			from utb as painting
			left join utv as ballon on ballon.v_id = painting.b_v_id
			group by square_id, ballon.v_color
			having color_volume = 255
		) as volume
		group by square_id
		having count(*) = 3
	) as white_square
	on square.q_id = white_square.square_id
) as color_count
join utq as square on square.q_id = square_list.square_id
order by square_id


/* Задание: 113 (Serge I: 2003-12-24)
Сколько каждой краски понадобится, чтобы докрасить все Не белые квадраты до белого цвета.
Вывод: количество каждой краски в порядке (R,G,B) */

-- Недокрашенные квадраты и количество затраченной краски
select painting.b_q_id, ballon.v_color, sum(painting.b_vol) as color_volume
from utb as painting
join utv as ballon
on painting.b_v_id = ballon.v_id
group by painting.b_q_id, ballon.v_color
having color_volume <> 255

-- Потребность в докраске квадратов по цветам (без учета цветов с нулями) 
select painting.color, color_volume, (255-color_volume) as requirement from
	(select painting.b_q_id as square_id, ballon.v_color as color, sum(painting.b_vol) as color_volume
	from utb as painting
	join utv as ballon
	on painting.b_v_id = ballon.v_id
	group by painting.b_q_id, ballon.v_color
	having color_volume <> 255
) as painting

-- Выборка всех цветов
select 'R' as color union select 'G' union select 'B'

-- Квадраты и их закраска по цветам
select squares_color.square_id, squares_color.color, ifnull(painting.color_volume, 0) as color_volume
from (
	select square.q_id as square_id, color_type.color
	from 
		utq as square,
		(select 'R' as color union select 'G' union select 'B') as color_type
	) as squares_color
left join (
	select square_id, color, color_volume
    from (
		select painting.b_q_id as square_id, ballon.v_color as color, sum(painting.b_vol) as color_volume
		from utb as painting
		join utv as ballon
		on painting.b_v_id = ballon.v_id
		group by painting.b_q_id, ballon.v_color
	) as painting
) as painting
on painting.color = squares_color.color and squares_color.square_id = painting.square_id

-- Цвет и потребность
select color_requirement.color, sum(requirement)
from
	(select squares_color.square_id, squares_color.color, (255-ifnull(painting.color_volume, 0)) as requirement
	from (
		select square.q_id as square_id, color_type.color
		from 
			utq as square,
			(select 'R' as color union select 'G' union select 'B') as color_type
		) as squares_color
	left join (
		select square_id, color, color_volume
		from (
			select painting.b_q_id as square_id, ballon.v_color as color, sum(painting.b_vol) as color_volume
			from utb as painting
			join utv as ballon
			on painting.b_v_id = ballon.v_id
			group by painting.b_q_id, ballon.v_color
		) as painting
	) as painting
	on painting.color = squares_color.color and squares_color.square_id = painting.square_id
) as color_requirement
group by color

-- Финальная выборка
select 
	sum(R) as R, 
	sum(G) as G, 
    sum(B) as B
from (
	select 
		(case when total_requirement.color = 'R' then requirement else null end) as R,
		(case when total_requirement.color = 'G' then requirement else null end) as G,
		(case when total_requirement.color = 'B' then requirement else null end) as B
	from (
		select color_requirement.color, sum(requirement) as requirement
		from (
			select squares_color.square_id, squares_color.color, (255-ifnull(painting.color_volume, 0)) as requirement
			from (
				select square.q_id as square_id, color_type.color
				from 
					utq as square,
					(select 'R' as color union select 'G' union select 'B') as color_type
				) as squares_color
			left join (
				select square_id, color, color_volume
				from (
					select painting.b_q_id as square_id, ballon.v_color as color, sum(painting.b_vol) as color_volume
					from utb as painting
					join utv as ballon
					on painting.b_v_id = ballon.v_id
					group by painting.b_q_id, ballon.v_color
				) as painting
			) as painting
			on painting.color = squares_color.color and squares_color.square_id = painting.square_id
		) as color_requirement
		group by color_requirement.color
	) as total_requirement
) as result

