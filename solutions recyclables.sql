/* Задание: 29 (Serge I: 2003-02-14)
В предположении, что приход и расход денег на каждом пункте приема фиксируется не чаще одного раза в день [т.е. первичный ключ (пункт, дата)], написать запрос с выходными данными (пункт, дата, приход, расход). Использовать таблицы Income_o и Outcome_o. */
select 
	D.point, D.date, income_o.inc, outcome_o.out
from
	(select point, date from income_o
	union 
	select point, date from outcome_o) as D
left join income_o on D.date = income_o.date and D.point = income_o.point
left join outcome_o on D.date = outcome_o.date and D.point = outcome_o.point


/* Задание: 30 (Serge I: 2003-02-14)
В предположении, что приход и расход денег на каждом пункте приема фиксируется произвольное число раз (первичным ключом в таблицах является столбец code), требуется получить таблицу, в которой каждому пункту за каждую дату выполнения операций будет соответствовать одна строка.
Вывод: point, date, суммарный расход пункта за день (out), суммарный приход пункта за день (inc). Отсутствующие значения считать неопределенными (NULL). */
select 
	D.point, D.date, O.outcome, I.income
from (
	select point, date from income
	union 
	select point, date from outcome
) as D
left join (
	select income.point, income.date, sum(income.inc) as income
	from income
	group by income.point, income.date
) as I
on D.date = I.date and D.point = I.point
left join (
	select outcome.point, outcome.date, sum(outcome.out) as outcome
	from outcome
	group by outcome.point, outcome.date
) as O
on D.date = O.date and D.point = O.point


/* Задание: 59 (Serge I: 2003-02-15)
Посчитать остаток денежных средств на каждом пункте приема для базы данных с отчетностью не чаще одного раза в день. Вывод: пункт, остаток. */
select 
	-- I.point, I.income, O.outcome, (I.income - O.outcome) as remain
    I.point, 
    (
		case
			when I.income is not null then I.income else 0
		end 
		-
		case
			when O.outcome is not null then O.outcome else 0
		end
	) as remain
from 
	(select income_o.point, sum(inc) as income
	from income_o
	group by point) as I
left join
	(select outcome_o.point, sum(outcome_o.`out`) as outcome
	from outcome_o 
	group by point) as O
on I.point = O.point
	
	
/* Задание: 60 (Serge I: 2003-02-15)
Посчитать остаток денежных средств на начало дня 15/04/01 на каждом пункте приема для базы данных с отчетностью не чаще одного раза в день. Вывод: пункт, остаток.
Замечание. Не учитывать пункты, информации о которых нет до указанной даты. */
select 
	-- I.point, I.income, O.outcome, (I.income - O.outcome) as remain
    I.point, 
    (
		case
			when I.income is not null then I.income else 0
		end 
		-
		case
			when O.outcome is not null then O.outcome else 0
		end
	) as remain
from 
	(select income_o.point, sum(inc) as income
	from income_o
    where date < '2001-04-15'
	group by point) as I
left join
	(select outcome_o.point, sum(outcome_o.`out`) as outcome
	from outcome_o
    where date < '2001-04-15'
	group by point) as O
on I.point = O.point


/* Задание: 61 (Serge I: 2003-02-14)
Посчитать остаток денежных средств на всех пунктах приема для базы данных с отчетностью не чаще одного раза в день. */
select 
    (
		case
			when I.income is not null then I.income else 0
		end 
		-
		case
			when O.outcome is not null then O.outcome else 0
		end
	) as remain
from 
	(select income_o.point, sum(inc) as income
	from income_o) as I
left join
	(select outcome_o.point, sum(outcome_o.`out`) as outcome
	from outcome_o) as O
on I.point = O.point


/* Задание: 62 (Serge I: 2003-02-15)
Посчитать остаток денежных средств на всех пунктах приема на начало дня 15/04/01 для базы данных с отчетностью не чаще одного раза в день. */
select 
    (
		case
			when I.income is not null then I.income else 0
		end 
		-
		case
			when O.outcome is not null then O.outcome else 0
		end
	) as remain
from 
	(select sum(inc) as income
	from income_o
    where date < '2001-04-15') as I
cross join
	(select sum(outcome_o.`out`) as outcome
	from outcome_o
    where date < '2001-04-15') as O
	
	
/* Задание: 64 (Serge I: 2010-06-04)
Используя таблицы Income и Outcome, для каждого пункта приема определить дни, когда был приход, но не было расхода и наоборот. Вывод: пункт, дата, тип операции (inc/out), денежная сумма за день. */	
select 
	D.point,
    D.date,
	(case
		when I.income is not null and O.outcome is null then 'inc'
        when I.income is null and O.outcome is not null then 'out'
	end) as operation,
	(case
		when I.income is not null and O.outcome is null then I.income
        when I.income is null and O.outcome is not null then O.outcome
	end) as money
from 
	(select point, date from income
	union
	select point, date from outcome) as D
left join
	(select point, date, sum(inc) as income
	from income
    group by point, date) as I
on D.date = I.date and D.point = I.point
left join
	(select point, date, sum(`out`) as outcome
	from outcome
    group by point, date) as O
on D.date = O.date and D.point = O.point
where I.income is null or O.outcome is null;	


/* Задание: 69 (Serge I: 2011-01-06)
По таблицам Income и Outcome для каждого пункта приема найти остатки денежных средств на конец каждого дня,
в который выполнялись операции по приходу и/или расходу на данном пункте.
Учесть при этом, что деньги не изымаются, а остатки/задолженность переходят на следующий день.
Вывод: пункт приема, день в формате "dd/mm/yyyy", остатки/задолженность на конец этого дня. */
select 
	D.point,
    date_format(D.date, '%d/%m/%Y') as date,
    -- ifnull(I.income, 0) - ifnull(O.outcome, 0) as remain, -- проверка
    (select 
		sum(ifnull(I1.income, 0) - ifnull(O1.outcome, 0)) as remain
    from 
		(select point, date from income
		union
		select point, date from outcome) as D1
	left join
		(select point, date, sum(inc) as income
		from income
		group by point, date) as I1
	on D1.date = I1.date and D1.point = I1.point
	left join
		(select point, date, sum(`out`) as outcome
		from outcome
		group by point, date) as O1
	on D1.date = O1.date and D1.point = O1.point
    where D.point = D1.point and D1.date <= D.date
    ) as remain
from 
	(select point, date from income
	union
	select point, date from outcome) as D
left join
	(select point, date, sum(inc) as income
	from income
    group by point, date) as I
on D.date = I.date and D.point = I.point
left join
	(select point, date, sum(`out`) as outcome
	from outcome
    group by point, date) as O
on D.date = O.date and D.point = O.point


/*Задание: 81 (Serge I: 2011-11-25)
Из таблицы Outcome получить все записи за тот месяц (месяцы), с учетом года, в котором суммарное значение расхода (out) было максимальным.*/

-- Группировка убыли по году/месяцу
select 
	year(date) as y,
    month(date) as m,
	sum(outcome.out)
from outcome
group by y, m

-- Максимальная месячная убыль 
select max(o)
from 
	(select sum(outcome.out) as o
	from outcome
	group by year(date), month(date)) as M

-- Результат
select *
from outcome
where 
	concat(year(outcome.date), month(outcome.date)) in
		(select 
			concat(year(date), month(date))
		from outcome
		group by year(date), month(date)
		having sum(outcome.out) = (
			select max(o)
			from 
				(select sum(outcome.out) as o
				from outcome
				group by year(date), month(date)) as M
			)
		)