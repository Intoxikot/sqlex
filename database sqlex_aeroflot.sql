/*

Схема БД состоит из четырех отношений:
Company (ID_comp, name)
Trip(trip_no, ID_comp, plane, town_from, town_to, time_out, time_in)
Passenger(ID_psg, name)
Pass_in_trip(trip_no, date, ID_psg, place)

Таблица Company содержит идентификатор и название компании, осуществляющей перевозку пассажиров. 

Таблица Trip содержит информацию о рейсах: номер рейса, идентификатор компании, тип самолета, город отправления, город прибытия, время отправления и время прибытия. 

Таблица Passenger содержит идентификатор и имя пассажира. 

Таблица Pass_in_trip содержит информацию о полетах: номер рейса, дата вылета (день), идентификатор пассажира и место, на котором он сидел во время полета. 

При этом следует иметь в виду, что
- рейсы выполняются ежедневно, а длительность полета любого рейса менее суток; town_from <> town_to;
- время и дата учитывается относительно одного часового пояса;
- время отправления и прибытия указывается с точностью до минуты;
- среди пассажиров могут быть однофамильцы (одинаковые значения поля name, например, Bruce Willis);
- номер места в салоне – это число с буквой; число определяет номер ряда, буква (a – d) – место в ряду слева направо в алфавитном порядке;
- связи и ограничения показаны на схеме данных.

*/

create database if not exists sqlex_aeroflot;
use sqlex_aeroflot;

drop table if exists company;
drop table if exists trip;
drop table if exists passenger;
drop table if exists pass_in_trip;

create table if not exists company (
	id_comp int unsigned auto_increment not null,
	name char(10) not null,
	primary key (id_comp)
);

create table if not exists trip (
	trip_no int not null, 
	id_comp int not null, 
	plane char(10) not null, 
	town_from char(25) not null, 
	town_to char(25) not null, 
	time_out datetime not null, 
	time_in datetime not null,
	primary key (trip_no)
);

create table if not exists passenger (
	id_psg int unsigned not null, 
	name char(20) not null,
	primary key (id_psg)
);

create table if not exists pass_in_trip (
	id int unsigned auto_increment not null,
	trip_no int not null, 
	date datetime not null, 
	id_psg int unsigned not null, 
	place char(10) not null,
	primary key(id),
	key (trip_no),
    key (date),
    key (id_psg)
);

insert into company(name) values ('Don_avia'); 
insert into company(name) values ('Aeroflot'); 
insert into company(name) values ('Dale_avia');
insert into company(name) values ('air_France');
insert into company(name) values ('British_AW');

insert into trip(trip_no, id_comp, plane, town_from, town_to, time_out, time_in) values (1100, 4, 'Boeing', 'Rostov', 'Paris', '1900-01-01 14:30:00.000', '1900-01-01 17:50:00.000');
insert into trip(trip_no, id_comp, plane, town_from, town_to, time_out, time_in) values (1101, 4, 'Boeing', 'Paris', 'Rostov', '1900-01-01 08:12:00.000', '1900-01-01 11:45:00.000');
insert into trip(trip_no, id_comp, plane, town_from, town_to, time_out, time_in) values (1123, 3, 'TU-154', 'Rostov', 'Vladivostok', '1900-01-01 16:20:00.000', '1900-01-01 03:40:00.000');
insert into trip(trip_no, id_comp, plane, town_from, town_to, time_out, time_in) values (1124, 3, 'TU-154', 'Vladivostok', 'Rostov', '1900-01-01 09:00:00.000', '1900-01-01 19:50:00.000');
insert into trip(trip_no, id_comp, plane, town_from, town_to, time_out, time_in) values (1145, 2, 'IL-86', 'Moscow', 'Rostov', '1900-01-01 09:35:00.000', '1900-01-01 11:23:00.000');
insert into trip(trip_no, id_comp, plane, town_from, town_to, time_out, time_in) values (1146, 2, 'IL-86', 'Rostov', 'Moscow', '1900-01-01 17:55:00.000', '1900-01-01 20:01:00.000');
insert into trip(trip_no, id_comp, plane, town_from, town_to, time_out, time_in) values (1181, 1, 'TU-134', 'Rostov', 'Moscow', '1900-01-01 06:12:00.000', '1900-01-01 08:01:00.000');
insert into trip(trip_no, id_comp, plane, town_from, town_to, time_out, time_in) values (1182, 1, 'TU-134', 'Moscow', 'Rostov', '1900-01-01 12:35:00.000', '1900-01-01 14:30:00.000');
insert into trip(trip_no, id_comp, plane, town_from, town_to, time_out, time_in) values (1187, 1, 'TU-134', 'Rostov', 'Moscow', '1900-01-01 15:42:00.000', '1900-01-01 17:39:00.000');
insert into trip(trip_no, id_comp, plane, town_from, town_to, time_out, time_in) values (1188, 1, 'TU-134', 'Moscow', 'Rostov', '1900-01-01 22:50:00.000', '1900-01-01 00:48:00.000');
insert into trip(trip_no, id_comp, plane, town_from, town_to, time_out, time_in) values (1195, 1, 'TU-154', 'Rostov', 'Moscow', '1900-01-01 23:30:00.000', '1900-01-01 01:11:00.000');
insert into trip(trip_no, id_comp, plane, town_from, town_to, time_out, time_in) values (1196, 1, 'TU-154', 'Moscow', 'Rostov', '1900-01-01 04:00:00.000', '1900-01-01 05:45:00.000');
insert into trip(trip_no, id_comp, plane, town_from, town_to, time_out, time_in) values (7771, 5, 'Boeing', 'London', 'Singapore', '1900-01-01 01:00:00.000', '1900-01-01 11:00:00.000');
insert into trip(trip_no, id_comp, plane, town_from, town_to, time_out, time_in) values (7772, 5, 'Boeing', 'Singapore', 'London', '1900-01-01 12:00:00.000', '1900-01-01 02:00:00.000');
insert into trip(trip_no, id_comp, plane, town_from, town_to, time_out, time_in) values (7773, 5, 'Boeing', 'London', 'Singapore', '1900-01-01 03:00:00.000', '1900-01-01 13:00:00.000');
insert into trip(trip_no, id_comp, plane, town_from, town_to, time_out, time_in) values (7774, 5, 'Boeing', 'Singapore', 'London', '1900-01-01 14:00:00.000', '1900-01-01 06:00:00.000');
insert into trip(trip_no, id_comp, plane, town_from, town_to, time_out, time_in) values (7775, 5, 'Boeing', 'London', 'Singapore', '1900-01-01 09:00:00.000', '1900-01-01 20:00:00.000');
insert into trip(trip_no, id_comp, plane, town_from, town_to, time_out, time_in) values (7776, 5, 'Boeing', 'Singapore', 'London', '1900-01-01 18:00:00.000', '1900-01-01 08:00:00.000');
insert into trip(trip_no, id_comp, plane, town_from, town_to, time_out, time_in) values (7777, 5, 'Boeing', 'London', 'Singapore', '1900-01-01 18:00:00.000', '1900-01-01 06:00:00.000');
insert into trip(trip_no, id_comp, plane, town_from, town_to, time_out, time_in) values (7778, 5, 'Boeing', 'Singapore', 'London', '1900-01-01 22:00:00.000', '1900-01-01 12:00:00.000');
insert into trip(trip_no, id_comp, plane, town_from, town_to, time_out, time_in) values (8881, 5, 'Boeing', 'London', 'Paris', '1900-01-01 03:00:00.000', '1900-01-01 04:00:00.000');
insert into trip(trip_no, id_comp, plane, town_from, town_to, time_out, time_in) values (8882, 5, 'Boeing', 'Paris', 'London', '1900-01-01 22:00:00.000', '1900-01-01 23:00:00.000');

insert into passenger(id_psg, name) values (1, 'Bruce Willis');       
insert into passenger(id_psg, name) values (2, 'George Clooney');    
insert into passenger(id_psg, name) values (3, 'Kevin Costner');       
insert into passenger(id_psg, name) values (4, 'Donald Sutherland');   
insert into passenger(id_psg, name) values (5, 'Jennifer Lopez');      
insert into passenger(id_psg, name) values (6, 'Ray Liotta');          
insert into passenger(id_psg, name) values (7, 'Samuel L. Jackson');   
insert into passenger(id_psg, name) values (8, 'Nikole Kidman');       
insert into passenger(id_psg, name) values (9, 'Alan Rickman');        
insert into passenger(id_psg, name) values (10, 'Kurt Russell');        
insert into passenger(id_psg, name) values (11, 'Harrison Ford');       
insert into passenger(id_psg, name) values (12, 'Russell Crowe');       
insert into passenger(id_psg, name) values (13, 'Steve Martin ');       
insert into passenger(id_psg, name) values (14, 'Michael Caine');       
insert into passenger(id_psg, name) values (15, 'Angelina Jolie');      
insert into passenger(id_psg, name) values (16, 'Mel Gibson');      
insert into passenger(id_psg, name) values (17, 'Michael Douglas');     
insert into passenger(id_psg, name) values (18, 'John Travolta');       
insert into passenger(id_psg, name) values (19, 'Sylvester Stallone');  
insert into passenger(id_psg, name) values (20, 'Tommy Lee Jones');     
insert into passenger(id_psg, name) values (21, 'Catherine Zeta-Jones');
insert into passenger(id_psg, name) values (22, 'Antonio Banderas');
insert into passenger(id_psg, name) values (23, 'Kim Basinger');
insert into passenger(id_psg, name) values (24, 'Sam Neill');
insert into passenger(id_psg, name) values (25, 'Gary Oldman');
insert into passenger(id_psg, name) values (26, 'Clint Eastwood');
insert into passenger(id_psg, name) values (27, 'Brad Pitt');
insert into passenger(id_psg, name) values (28, 'Johnny Depp');
insert into passenger(id_psg, name) values (29, 'Pierce Brosnan');
insert into passenger(id_psg, name) values (30, 'Sean Connery');
insert into passenger(id_psg, name) values (31, 'Bruce Willis');
insert into passenger(id_psg, name) values (37, 'Mullah Omar');

insert into pass_in_trip(trip_no, date, id_psg, place) values (1100, '2003-04-29 00:00:00.000', 1, '1a');
insert into pass_in_trip(trip_no, date, id_psg, place) values (1123, '2003-04-05 00:00:00.000', 3, '2a');
insert into pass_in_trip(trip_no, date, id_psg, place) values (1123, '2003-04-08 00:00:00.000', 1, '4c');
insert into pass_in_trip(trip_no, date, id_psg, place) values (1123, '2003-04-08 00:00:00.000', 6, '4b');
insert into pass_in_trip(trip_no, date, id_psg, place) values (1124, '2003-04-02 00:00:00.000', 2, '2d');
insert into pass_in_trip(trip_no, date, id_psg, place) values (1145, '2003-04-05 00:00:00.000', 3, '2c');
insert into pass_in_trip(trip_no, date, id_psg, place) values (1181, '2003-04-01 00:00:00.000', 1, '1a');
insert into pass_in_trip(trip_no, date, id_psg, place) values (1181, '2003-04-01 00:00:00.000', 6, '1b');
insert into pass_in_trip(trip_no, date, id_psg, place) values (1181, '2003-04-01 00:00:00.000', 8, '3c');
insert into pass_in_trip(trip_no, date, id_psg, place) values (1181, '2003-04-13 00:00:00.000', 5, '1b');
insert into pass_in_trip(trip_no, date, id_psg, place) values (1182, '2003-04-13 00:00:00.000', 5, '4b');
insert into pass_in_trip(trip_no, date, id_psg, place) values (1187, '2003-04-14 00:00:00.000', 8, '3a');
insert into pass_in_trip(trip_no, date, id_psg, place) values (1188, '2003-04-01 00:00:00.000', 8, '3a');
insert into pass_in_trip(trip_no, date, id_psg, place) values (1182, '2003-04-13 00:00:00.000', 9, '6d');
insert into pass_in_trip(trip_no, date, id_psg, place) values (1145, '2003-04-25 00:00:00.000', 5, '1d');
insert into pass_in_trip(trip_no, date, id_psg, place) values (8882, '2005-11-06 00:00:00.000', 37, '1a');
insert into pass_in_trip(trip_no, date, id_psg, place) values (7771, '2005-11-07 00:00:00.000', 37, '1c');
insert into pass_in_trip(trip_no, date, id_psg, place) values (7772, '2005-11-07 00:00:00.000', 37, '1a');
insert into pass_in_trip(trip_no, date, id_psg, place) values (8881, '2005-11-08 00:00:00.000', 37, '1d');
insert into pass_in_trip(trip_no, date, id_psg, place) values (7778, '2005-11-05 00:00:00.000', 10, '2a');
insert into pass_in_trip(trip_no, date, id_psg, place) values (7772, '2005-11-29 00:00:00.000', 10, '3a');
insert into pass_in_trip(trip_no, date, id_psg, place) values (7771, '2005-11-04 00:00:00.000', 11, '4a');
insert into pass_in_trip(trip_no, date, id_psg, place) values (7771, '2005-11-07 00:00:00.000', 11, '1b');
insert into pass_in_trip(trip_no, date, id_psg, place) values (7771, '2005-11-09 00:00:00.000', 11, '5a');
insert into pass_in_trip(trip_no, date, id_psg, place) values (7772, '2005-11-07 00:00:00.000', 12, '1d');
insert into pass_in_trip(trip_no, date, id_psg, place) values (7773, '2005-11-07 00:00:00.000', 13, '2d');
insert into pass_in_trip(trip_no, date, id_psg, place) values (7772, '2005-11-29 00:00:00.000', 13, '1b');
insert into pass_in_trip(trip_no, date, id_psg, place) values (8882, '2005-11-13 00:00:00.000', 14, '3d');
insert into pass_in_trip(trip_no, date, id_psg, place) values (7771, '2005-11-14 00:00:00.000', 14, '4d');
insert into pass_in_trip(trip_no, date, id_psg, place) values (7771, '2005-11-16 00:00:00.000', 14, '5d');
insert into pass_in_trip(trip_no, date, id_psg, place) values (7772, '2005-11-29 00:00:00.000', 14, '1c');
insert into pass_in_trip(trip_no, date, id_psg, place) values (1187, '2003-04-14 00:00:00.000', 10, '3d');

select * from company;
select * from trip;
select * from passenger;
select * from pass_in_trip;