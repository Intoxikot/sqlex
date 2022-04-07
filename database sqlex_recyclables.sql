/*

Фирма имеет несколько пунктов приема вторсырья. Каждый пункт получает деньги для их выдачи сдатчикам вторсырья. Сведения о получении денег на пунктах приема записываются в таблицу:
Income_o(point, date, inc)
Первичным ключом является (point, date). При этом в столбец date записывается только дата (без времени), т.е. прием денег (inc) на каждом пункте производится не чаще одного раза в день. 

Сведения о выдаче денег сдатчикам вторсырья записываются в таблицу:
Outcome_o(point, date, out)
В этой таблице также первичный ключ (point, date) гарантирует отчетность каждого пункта о выданных деньгах (out) не чаще одного раза в день.

В случае, когда приход и расход денег может фиксироваться несколько раз в день, используется другая схема с таблицами, имеющими первичный ключ code:
Income(code, point, date, inc)
Outcome(code, point, date, out)
Здесь также значения столбца date не содержат времени.

*/

create database if not exists sqlex_recyclables;
use sqlex_recyclables;

drop table if exists income_o;
drop table if exists outcome_o;
drop table if exists income;
drop table if exists outcome;

create table if not exists income_o (
	point tinyint,
	date datetime,
	inc decimal(10, 4),
	primary key (point, date)
);

create table if not exists outcome_o (
	point tinyint,
	date datetime,
	`out` decimal(10, 4),
	primary key (point, date)
);

create table if not exists income (
	code int unsigned auto_increment not null,
	point tinyint,
	date datetime,
	inc decimal(10, 4),
	primary key (code)
);

create table if not exists outcome (
	code int unsigned auto_increment not null,
	point tinyint,
	date datetime,
	`out` decimal(10, 4),
	primary key (code)
);

insert into income_o(point, date, inc) values (1, '2001-03-22 00:00:00.000', 15000.0000);
insert into income_o(point, date, inc) values (1, '2001-03-23 00:00:00.000', 15000.0000);
insert into income_o(point, date, inc) values (1, '2001-03-24 00:00:00.000', 3400.0000);
insert into income_o(point, date, inc) values (1, '2001-04-13 00:00:00.000', 5000.0000);
insert into income_o(point, date, inc) values (1, '2001-05-11 00:00:00.000', 4500.0000);
insert into income_o(point, date, inc) values (2, '2001-03-22 00:00:00.000', 10000.0000);
insert into income_o(point, date, inc) values (2, '2001-03-24 00:00:00.000', 1500.0000);
insert into income_o(point, date, inc) values (3, '2001-09-13 00:00:00.000', 11500.0000);
insert into income_o(point, date, inc) values (3, '2001-10-02 00:00:00.000', 18000.0000);

insert into outcome_o(point, date, `out`) values (1, '2001-03-14 00:00:00.000', 15348.0000);
insert into outcome_o(point, date, `out`) values (1, '2001-03-24 00:00:00.000', 3663.0000);
insert into outcome_o(point, date, `out`) values (1, '2001-03-26 00:00:00.000', 1221.0000);
insert into outcome_o(point, date, `out`) values (1, '2001-03-28 00:00:00.000', 2075.0000);
insert into outcome_o(point, date, `out`) values (1, '2001-03-29 00:00:00.000', 2004.0000);
insert into outcome_o(point, date, `out`) values (1, '2001-04-11 00:00:00.000', 3195.0400);
insert into outcome_o(point, date, `out`) values (1, '2001-04-13 00:00:00.000', 4490.0000);
insert into outcome_o(point, date, `out`) values (1, '2001-04-27 00:00:00.000', 3110.0000);
insert into outcome_o(point, date, `out`) values (1, '2001-05-11 00:00:00.000', 2530.0000);
insert into outcome_o(point, date, `out`) values (2, '2001-03-22 00:00:00.000', 1440.0000);
insert into outcome_o(point, date, `out`) values (2, '2001-03-29 00:00:00.000', 7848.0000);
insert into outcome_o(point, date, `out`) values (2, '2001-04-02 00:00:00.000', 2040.0000);
insert into outcome_o(point, date, `out`) values (3, '2001-09-13 00:00:00.000', 1500.0000);
insert into outcome_o(point, date, `out`) values (3, '2001-09-14 00:00:00.000', 2300.0000);
insert into outcome_o(point, date, `out`) values (3, '2002-09-16 00:00:00.000', 2150.0000);

insert into income(point, date, inc) values (1, '2001-03-22 00:00:00.000', 15000.0000);
insert into income(point, date, inc) values (1, '2001-03-23 00:00:00.000', 15000.0000);
insert into income(point, date, inc) values (1, '2001-03-24 00:00:00.000', 3600.0000);
insert into income(point, date, inc) values (2, '2001-03-22 00:00:00.000', 10000.0000);
insert into income(point, date, inc) values (2, '2001-03-24 00:00:00.000', 1500.0000);
insert into income(point, date, inc) values (1, '2001-04-13 00:00:00.000', 5000.0000);
insert into income(point, date, inc) values (1, '2001-05-11 00:00:00.000', 4500.0000);
insert into income(point, date, inc) values (1, '2001-03-22 00:00:00.000', 15000.0000);
insert into income(point, date, inc) values (2, '2001-03-24 00:00:00.000', 1500.0000);
insert into income(point, date, inc) values (1, '2001-04-13 00:00:00.000', 5000.0000);
insert into income(point, date, inc) values (1, '2001-03-24 00:00:00.000', 3400.0000);
insert into income(point, date, inc) values (3, '2001-09-13 00:00:00.000', 1350.0000);
insert into income(point, date, inc) values (3, '2001-09-13 00:00:00.000', 1750.0000);

insert into outcome(point, date, `out`) values (1, '2001-03-14 00:00:00.000', 15348.0000);
insert into outcome(point, date, `out`) values (1, '2001-03-24 00:00:00.000', 3663.0000);
insert into outcome(point, date, `out`) values (1, '2001-03-26 00:00:00.000', 1221.0000);
insert into outcome(point, date, `out`) values (1, '2001-03-28 00:00:00.000', 2075.0000);
insert into outcome(point, date, `out`) values (1, '2001-03-29 00:00:00.000', 2004.0000);
insert into outcome(point, date, `out`) values (1, '2001-04-11 00:00:00.000', 3195.0400);
insert into outcome(point, date, `out`) values (1, '2001-04-13 00:00:00.000', 4490.0000);
insert into outcome(point, date, `out`) values (1, '2001-04-27 00:00:00.000', 3110.0000);
insert into outcome(point, date, `out`) values (1, '2001-05-11 00:00:00.000', 2530.0000);
insert into outcome(point, date, `out`) values (2, '2001-03-22 00:00:00.000', 1440.0000);
insert into outcome(point, date, `out`) values (2, '2001-03-29 00:00:00.000', 7848.0000);
insert into outcome(point, date, `out`) values (2, '2001-04-02 00:00:00.000', 2040.0000);
insert into outcome(point, date, `out`) values (1, '2001-03-24 00:00:00.000', 3500.0000);
insert into outcome(point, date, `out`) values (2, '2001-03-22 00:00:00.000', 1440.0000);
insert into outcome(point, date, `out`) values (1, '2001-03-29 00:00:00.000', 2006.0000);
insert into outcome(point, date, `out`) values (3, '2001-09-13 00:00:00.000', 1200.0000);
insert into outcome(point, date, `out`) values (3, '2001-09-13 00:00:00.000', 1500.0000);
insert into outcome(point, date, `out`) values (3, '2001-09-14 00:00:00.000', 1150.0000);

select * from income_o;
select * from outcome_o;
select * from income;
select * from outcome;