/*

Схема БД состоит из четырех таблиц:
Product(maker, model, type)
PC(code, model, speed, ram, hd, cd, price)
Laptop(code, model, speed, ram, hd, price, screen)
Printer(code, model, color, type, price)

Таблица Product представляет производителя (maker), номер модели (model) и тип ('PC' - ПК, 'Laptop' - ПК-блокнот или 'Printer' - принтер). Предполагается, что номера моделей в таблице Product уникальны для всех производителей и типов продуктов. 

В таблице PC для каждого ПК, однозначно определяемого уникальным кодом – code, указаны модель – model (внешний ключ к таблице Product), скорость - speed (процессора в мегагерцах), объем памяти - ram (в мегабайтах), размер диска - hd (в гигабайтах), скорость считывающего устройства - cd (например, '4x') и цена - price (в долларах). 

Таблица Laptop аналогична таблице РС за исключением того, что вместо скорости CD содержит размер экрана - screen (в дюймах). 

В таблице Printer для каждой модели принтера указывается, является ли он цветным - color ('y', если цветной), тип принтера - type (лазерный – 'Laser', струйный – 'Jet' или матричный – 'Matrix') и цена - price.

*/

create database if not exists sqlex_product;
use sqlex_product;

drop table if exists product;
drop table if exists pc;
drop table if exists printer;
drop table if exists laptop;

create table if not exists product (
	id int unsigned auto_increment not null,
	maker varchar(10) not null,
	model varchar(50) not null,
	type varchar (50) not null,
	primary key (id),
	key (model)
);

create table if not exists pc (
	code int unsigned auto_increment not null,
	model varchar(50) not null,
	speed smallint not null,
	ram smallint not null,
	hd real not null,
	cd varchar(10) not null,
	price decimal(10, 4) null,
	primary key (code),
	key (model)
);

create table if not exists laptop (
	code int unsigned auto_increment not null,
	model varchar(50) not null,
	speed smallint not null,
	ram smallint not null,
	hd real not null,
	price decimal(10, 4) null,
	screen tinyint,
	primary key (code),
	key (model)
);

create table if not exists printer (
	code int unsigned auto_increment not null,
	model varchar(50) not null,
	color char(1),
	type varchar(10),
	price decimal(10, 4) null,
	primary key (code),
	key (model)
);

insert into product(maker, model, type) values ('B', 1121, 'PC');
insert into product(maker, model, type) values ('A', 1232, 'PC');
insert into product(maker, model, type) values ('A', 1233, 'PC');
insert into product(maker, model, type) values ('E', 1260, 'PC');
insert into product(maker, model, type) values ('A', 1276, 'Printer');
insert into product(maker, model, type) values ('D', 1288, 'Printer');
insert into product(maker, model, type) values ('A', 1298, 'Laptop');
insert into product(maker, model, type) values ('C', 1321, 'Laptop');
insert into product(maker, model, type) values ('A', 1401, 'Printer');
insert into product(maker, model, type) values ('A', 1408, 'Printer');
insert into product(maker, model, type) values ('D', 1433, 'Printer');
insert into product(maker, model, type) values ('E', 1434, 'Printer');
insert into product(maker, model, type) values ('B', 1750, 'Laptop');
insert into product(maker, model, type) values ('A', 1752, 'Laptop');
insert into product(maker, model, type) values ('E', 2112, 'PC');
insert into product(maker, model, type) values ('E', 2113, 'PC');

insert into pc(model, speed, ram, hd, cd, price) values(1232,	500, 64, 5.0, '12x', 600.0000);
insert into pc(model, speed, ram, hd, cd, price) values(1121,	750, 128, 14.0, '40x', 850.0000);
insert into pc(model, speed, ram, hd, cd, price) values(1233,	500, 64, 5.0, '12x', 600.0000);
insert into pc(model, speed, ram, hd, cd, price) values(1121,	600, 128, 14.0, '40x', 850.0000);
insert into pc(model, speed, ram, hd, cd, price) values(1121,	600, 128, 8.0, '40x', 850.0000);
insert into pc(model, speed, ram, hd, cd, price) values(1233,	750, 128, 20.0, '50x', 950.0000);
insert into pc(model, speed, ram, hd, cd, price) values(1232,	500, 32, 10.0, '12x', 400.0000);
insert into pc(model, speed, ram, hd, cd, price) values(1232,	450, 64, 8.0, '24x', 350.0000);
insert into pc(model, speed, ram, hd, cd, price) values(1232,	450, 32, 10.0, '24x', 350.0000);
insert into pc(model, speed, ram, hd, cd, price) values(1260,	500, 32, 10.0, '12x', 350.0000);
insert into pc(model, speed, ram, hd, cd, price) values(1233,	900, 128, 40.0, '40x', 980.0000);
insert into pc(model, speed, ram, hd, cd, price) values(1233,	800, 128, 20.0, '50x', 970.0000);

insert into printer(model, color, type, price) values (1276, 'n', 'Laser', 400.0000);
insert into printer(model, color, type, price) values (1433, 'y', 'Jet', 270.0000);
insert into printer(model, color, type, price) values (1434, 'y', 'Jet', 290.0000);
insert into printer(model, color, type, price) values (1401, 'n', 'Matrix', 150.0000);
insert into printer(model, color, type, price) values (1408, 'n', 'Matrix', 270.0000);
insert into printer(model, color, type, price) values (1288, 'n', 'Laser', 400.0000);

insert into laptop(model, speed, ram, hd, price, screen) values (1298, 350, 32, 4.0, 700.0000, 11);
insert into laptop(model, speed, ram, hd, price, screen) values (1321, 500, 64, 8.0, 970.0000, 12);
insert into laptop(model, speed, ram, hd, price, screen) values (1750, 750, 128, 12.0, 1200.0000, 14);
insert into laptop(model, speed, ram, hd, price, screen) values (1298, 600, 64, 10.0, 1050.0000, 15);
insert into laptop(model, speed, ram, hd, price, screen) values (1752, 750, 128, 10.0, 1150.0000, 14);
insert into laptop(model, speed, ram, hd, price, screen) values (1298, 450, 64, 10.0, 950.0000, 12);

select * from product order by id;
select * from pc order by code;
select * from laptop order by code;
select * from printer order by code;