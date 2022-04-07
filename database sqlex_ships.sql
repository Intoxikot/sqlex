/*

Рассматривается БД кораблей, участвовавших во второй мировой войне. Имеются следующие отношения:
Classes (class, type, country, numGuns, bore, displacement)
Ships (name, class, launched)
Battles (name, date)
Outcomes (ship, battle, result)

Корабли в «классах» построены по одному и тому же проекту, и классу присваивается либо имя первого корабля, построенного по данному проекту, либо названию класса дается имя проекта, которое не совпадает ни с одним из кораблей в БД. Корабль, давший название классу, называется головным.

Отношение Classes содержит имя класса, тип (bb для боевого (линейного) корабля или bc для боевого крейсера), страну, в которой построен корабль, число главных орудий, калибр орудий (диаметр ствола орудия в дюймах) и водоизмещение (вес в тоннах). 

В отношении Ships записаны название корабля, имя его класса и год спуска на воду. В отношение Battles включены название и дата битвы, в которой участвовали корабли, а в отношении Outcomes – результат участия данного корабля в битве (потоплен-sunk, поврежден - damaged или невредим - OK).
Замечания. 

1) В отношение Outcomes могут входить корабли, отсутствующие в отношении Ships. 
2) Потопленный корабль в последующих битвах участия не принимает.

*/

create database if not exists sqlex_ships;
use sqlex_ships;

drop table if exists classes;
drop table if exists ships;
drop table if exists battles;
drop table if exists outcomes;

create table if not exists classes (
	id int unsigned auto_increment not null,
	class varchar(50) not null,
	type varchar(2) not null,
	country varchar(20) not null,
	numGuns tinyint null,
	bore real null,
	displacement int null,
	primary key (id),
	key (class)
);

create table if not exists ships (
	id int unsigned auto_increment not null,
	name varchar(50) not null,
	class varchar(50) not null,
	launched smallint null,
	primary key (id),
	key (name)
);

create table if not exists battles (
	id int unsigned auto_increment not null,
	name varchar(20) not null,
	date datetime not null,
	primary key (id),
	key (name)
);

create table if not exists outcomes (
	id int unsigned auto_increment not null,
	ship varchar(20) not null,
	battle varchar(20) not null,
	result varchar(10) not null,
	primary key (id),
	key (battle, ship)
);

insert into classes(class, type, country, numGuns, bore, displacement) values ('Bismarck', 'bb', 'Germany', 8, 15.0, 42000);
insert into classes(class, type, country, numGuns, bore, displacement) values ('Iowa', 'bb', 'USA', 9,	16.0,46000);
insert into classes(class, type, country, numGuns, bore, displacement) values ('Kongo', 'bc', 'Japan', 8	14.0, 32000);
insert into classes(class, type, country, numGuns, bore, displacement) values ('North', 'Carolina', 'bb',	'USA', 12, 16.0, 37000);
insert into classes(class, type, country, numGuns, bore, displacement) values ('Renown', 'bc', 'Gt.Britain', 6, 15.0, 32000.
insert into classes(class, type, country, numGuns, bore, displacement) values ('Revenge', 'bb', 'Gt.Britain', 8, 15.0, 29000);
insert into classes(class, type, country, numGuns, bore, displacement) values ('Tennessee', 'bb', 'USA', 12	14.0, 32000);
insert into classes(class, type, country, numGuns, bore, displacement) values ('Yamato', 'bb', 'Japan', 9,	18.0, 65000);

insert into ships(name, class, launched) values ('California', 'Tennessee', 1921);
insert into ships(name, class, launched) values ('Haruna', 'Kongo', 1916);
insert into ships(name, class, launched) values ('Hiei', 'Kongo', 1914);
insert into ships(name, class, launched) values ('Iowa', 'Iowa', 1943);
insert into ships(name, class, launched) values ('Kirishima', 'Kongo', 1915);
insert into ships(name, class, launched) values ('Kongo', 'Kongo', 1913);
insert into ships(name, class, launched) values ('Missouri', 'Iowa', 1944);
insert into ships(name, class, launched) values ('Musashi', 'Yamato', 1942);
insert into ships(name, class, launched) values ('New Jersey', 'Iowa', 1943);
insert into ships(name, class, launched) values ('North Carolina', 'North Carolina', 1941);
insert into ships(name, class, launched) values ('Ramillies', 'Revenge', 1917);
insert into ships(name, class, launched) values ('Renown', 'Renown', 1916);
insert into ships(name, class, launched) values ('Repulse', 'Renown', 1916);
insert into ships(name, class, launched) values ('Resolution', 'Renown', 1916);
insert into ships(name, class, launched) values ('Revenge', 'Revenge', 916);
insert into ships(name, class, launched) values ('Royal Oak', 'Revenge', 1916);
insert into ships(name, class, launched) values ('Royal Sovereign', 'Revenge', 1916);
insert into ships(name, class, launched) values ('South Dakota', 'North Carolina', 1941);
insert into ships(name, class, launched) values ('Tennessee', 'Tennessee', 1920);
insert into ships(name, class, launched) values ('Washington', 'North Carolina', 1941);
insert into ships(name, class, launched) values ('Wisconsin', 'Iowa', 1944);
insert into ships(name, class, launched) values ('Yamato', 'Yamato', 1941);

insert into battles(name, date) values ('#Cuba62a',	'1962-10-20 00:00:00.000');
insert into battles(name, date) values ('#Cuba62b', '1962-10-25 00:00:00.000');
insert into battles(name, date) values ('Guadalcanal', '1942-11-15 00:00:00.000');
insert into battles(name, date) values ('North Atlantic', '1941-05-25 00:00:00.000');
insert into battles(name, date) values ('North Cape', '1943-12-26 00:00:00.000');
insert into battles(name, date) values ('Surigao Strait', '1944-10-25 00:00:00.000');

insert into outcomes(ship, battle, result) values ('Bismarck', 'North Atlantic', 'sunk');
insert into outcomes(ship, battle, result) values ('California', 'Guadalcanal', 'damaged');
insert into outcomes(ship, battle, result) values ('CAlifornia', 'Surigao Strait', 'ok');
insert into outcomes(ship, battle, result) values ('Duke of York', 'North Cape', 'ok');
insert into outcomes(ship, battle, result) values ('Fuso', 'Surigao Strait', 'sunk');
insert into outcomes(ship, battle, result) values ('Hood', 'North Atlantic', 'sunk');
insert into outcomes(ship, battle, result) values ('King George V', 'North Atlantic', 'ok');
insert into outcomes(ship, battle, result) values ('Kirishima', 'Guadalcanal', 'sunk');
insert into outcomes(ship, battle, result) values ('Prince of Wales', 'North Atlantic', 'damaged');
insert into outcomes(ship, battle, result) values ('Rodney', 'North Atlantic', 'OK');
insert into outcomes(ship, battle, result) values ('Schamhorst', 'North Cape', 'sunk');
insert into outcomes(ship, battle, result) values ('South Dakota', 'Guadalcanal', 'damaged');
insert into outcomes(ship, battle, result) values ('Tennessee', 'Surigao Strait', 'ok');
insert into outcomes(ship, battle, result) values ('Washington', 'Guadalcanal', 'ok');
insert into outcomes(ship, battle, result) values ('West Virginia', 'Surigao Strait', 'ok');
insert into outcomes(ship, battle, result) values ('Yamashiro', 'Surigao Strait', 'sunk');

select * from classes;
select * from ships;
select * from battles;
select * from outcomes;