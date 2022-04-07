/*

Схема базы данных состоит из трех отношений:
utQ (Q_ID int, Q_NAME varchar(35)); 
utV (V_ID int, V_NAME varchar(35), V_COLOR char(1)); 
utB (B_DATETIME datetime, B_Q_ID int, B_V_ID int, B_VOL tinyint).

Таблица utQ содержит идентификатор и название квадрата, цвет которого первоначально черный.
Таблица utV содержит идентификатор, название и цвет баллончика с краской.
Таблица utB содержит информацию об окраске квадрата баллончиком: время окраски, идентификатор квадрата, идентификатор баллончика, количество краски.

При этом следует иметь в виду, что:
- баллончики с краской могут быть трех цветов - красный V_COLOR='R', зеленый V_COLOR='G', голубой V_COLOR='B' (латинские буквы).
- объем баллончика равен 255 и первоначально он полный;
- цвет квадрата определяется по правилу RGB, т.е. R=0,G=0,B=0 - черный, R=255, G=255, B=255 - белый;
- запись в таблице закрасок utB уменьшает количество краски в баллончике на величину B_VOL и соответственно увеличивает количество краски в квадрате на эту же величину;
- значение 0 < B_VOL <= 255;
- количество краски одного цвета в квадрате не превышает 255, а количество краски в баллончике не может быть меньше нуля;
- время окраски B_DATETIME дано с точностью до секунды, т.е. не содержит миллисекунд.

*/

create database if not exists sqlex_coloring;
use sqlex_coloring;

drop table if exists utq;
drop table if exists utv;
drop table if exists utb;

create table if not exists utq (
	q_id int unsigned auto_increment not null,
	q_name varchar(35) not null,
	primary key (q_id)
);

create table if not exists utv (
	v_id int unsigned auto_increment not null, 
	v_name varchar(35) not null,
	v_color char(1) not null,
	primary key (v_id)
);

create table if not exists utb (
	b_id int unsigned auto_increment not null,
	b_datetime datetime not null, 
	b_q_id int not null, 
	b_v_id int not null, 
	b_vol tinyint unsigned not null,
	primary key (b_id),
	key (b_q_id),
	key (b_v_id)
);

insert into utq(q_name) values ('Square # 01');
insert into utq(q_name) values ('Square # 02');
insert into utq(q_name) values ('Square # 03');
insert into utq(q_name) values ('Square # 04');
insert into utq(q_name) values ('Square # 05');
insert into utq(q_name) values ('Square # 06');
insert into utq(q_name) values ('Square # 07');
insert into utq(q_name) values ('Square # 08');
insert into utq(q_name) values ('Square # 09');
insert into utq(q_name) values ('Square # 10');
insert into utq(q_name) values ('Square # 11');
insert into utq(q_name) values ('Square # 12');
insert into utq(q_name) values ('Square # 13');
insert into utq(q_name) values ('Square # 14');
insert into utq(q_name) values ('Square # 15');
insert into utq(q_name) values ('Square # 16');
insert into utq(q_name) values ('Square # 17');
insert into utq(q_name) values ('Square # 18');
insert into utq(q_name) values ('Square # 19');
insert into utq(q_name) values ('Square # 20');
insert into utq(q_name) values ('Square # 21');
insert into utq(q_name) values ('Square # 22');
insert into utq(q_name) values ('Square # 23');
insert into utq(q_name) values ('Square # 25');

insert into utv(v_name, v_color) values ('Balloon # 01', 'R');
insert into utv(v_name, v_color) values ('Balloon # 02', 'R');
insert into utv(v_name, v_color) values ('Balloon # 03', 'R');
insert into utv(v_name, v_color) values ('Balloon # 04', 'G');
insert into utv(v_name, v_color) values ('Balloon # 05', 'G');
insert into utv(v_name, v_color) values ('Balloon # 06', 'G');
insert into utv(v_name, v_color) values ('Balloon # 07', 'B');
insert into utv(v_name, v_color) values ('Balloon # 08', 'B');
insert into utv(v_name, v_color) values ('Balloon # 09', 'B');
insert into utv(v_name, v_color) values ('Balloon # 10', 'R');
insert into utv(v_name, v_color) values ('Balloon # 11', 'R');
insert into utv(v_name, v_color) values ('Balloon # 12', 'R');
insert into utv(v_name, v_color) values ('Balloon # 13', 'G');
insert into utv(v_name, v_color) values ('Balloon # 14', 'G');
insert into utv(v_name, v_color) values ('Balloon # 15', 'B');
insert into utv(v_name, v_color) values ('Balloon # 16', 'B');
insert into utv(v_name, v_color) values ('Balloon # 17', 'R');
insert into utv(v_name, v_color) values ('Balloon # 18', 'G');
insert into utv(v_name, v_color) values ('Balloon # 19', 'B');
insert into utv(v_name, v_color) values ('Balloon # 20', 'R');
insert into utv(v_name, v_color) values ('Balloon # 21', 'G');
insert into utv(v_name, v_color) values ('Balloon # 22', 'B');
insert into utv(v_name, v_color) values ('Balloon # 23', 'R');
insert into utv(v_name, v_color) values ('Balloon # 24', 'G');
insert into utv(v_name, v_color) values ('Balloon # 25', 'B');
insert into utv(v_name, v_color) values ('Balloon # 26', 'B');
insert into utv(v_name, v_color) values ('Balloon # 27', 'R');
insert into utv(v_name, v_color) values ('Balloon # 28', 'G');
insert into utv(v_name, v_color) values ('Balloon # 29', 'R');
insert into utv(v_name, v_color) values ('Balloon # 30', 'G');
insert into utv(v_name, v_color) values ('Balloon # 31', 'R');
insert into utv(v_name, v_color) values ('Balloon # 32', 'G');
insert into utv(v_name, v_color) values ('Balloon # 33', 'B');
insert into utv(v_name, v_color) values ('Balloon # 34', 'R');
insert into utv(v_name, v_color) values ('Balloon # 35', 'G');
insert into utv(v_name, v_color) values ('Balloon # 36', 'B');
insert into utv(v_name, v_color) values ('Balloon # 37', 'R');
insert into utv(v_name, v_color) values ('Balloon # 38', 'G');
insert into utv(v_name, v_color) values ('Balloon # 39', 'B');
insert into utv(v_name, v_color) values ('Balloon # 40', 'R');
insert into utv(v_name, v_color) values ('Balloon # 41', 'R');
insert into utv(v_name, v_color) values ('Balloon # 42', 'G');
insert into utv(v_name, v_color) values ('Balloon # 43', 'B');
insert into utv(v_name, v_color) values ('Balloon # 44', 'R');
insert into utv(v_name, v_color) values ('Balloon # 45', 'G');
insert into utv(v_name, v_color) values ('Balloon # 46', 'B');
insert into utv(v_name, v_color) values ('Balloon # 47', 'B');
insert into utv(v_name, v_color) values ('Balloon # 48', 'G');
insert into utv(v_name, v_color) values ('Balloon # 49', 'R');
insert into utv(v_name, v_color) values ('Balloon # 50', 'G');
insert into utv(v_name, v_color) values ('Balloon # 51', 'B');
insert into utv(v_name, v_color) values ('Balloon # 52', 'R');
insert into utv(v_name, v_color) values ('Balloon # 53', 'G');
insert into utv(v_name, v_color) values ('Balloon # 54', 'B');

insert into utb(b_datetime, b_q_id, b_v_id, b_vol) values('2000-01-01 01:13:36.000', 22, 50, 50);
insert into utb(b_datetime, b_q_id, b_v_id, b_vol) values('2001-01-01 01:13:37.000', 22, 50, 50);
insert into utb(b_datetime, b_q_id, b_v_id, b_vol) values('2002-01-01 01:13:38.000', 22, 51, 50);
insert into utb(b_datetime, b_q_id, b_v_id, b_vol) values('2002-06-01 01:13:39.000', 22, 51, 50);
insert into utb(b_datetime, b_q_id, b_v_id, b_vol) values('2003-01-01 01:12:01.000', 1, 1, 155);
insert into utb(b_datetime, b_q_id, b_v_id, b_vol) values('2003-01-01 01:12:03.000', 2, 2, 255);
insert into utb(b_datetime, b_q_id, b_v_id, b_vol) values('2003-01-01 01:12:04.000', 3, 3, 255);
insert into utb(b_datetime, b_q_id, b_v_id, b_vol) values('2003-01-01 01:12:05.000', 1, 4, 255);
insert into utb(b_datetime, b_q_id, b_v_id, b_vol) values('2003-01-01 01:12:06.000', 2, 5, 255);
insert into utb(b_datetime, b_q_id, b_v_id, b_vol) values('2003-01-01 01:12:07.000', 3, 6, 255);
insert into utb(b_datetime, b_q_id, b_v_id, b_vol) values('2003-01-01 01:12:08.000', 1, 7, 255);
insert into utb(b_datetime, b_q_id, b_v_id, b_vol) values('2003-01-01 01:12:09.000', 2, 8, 255);
insert into utb(b_datetime, b_q_id, b_v_id, b_vol) values('2003-01-01 01:12:10.000', 3, 9, 255);
insert into utb(b_datetime, b_q_id, b_v_id, b_vol) values('2003-01-01 01:12:11.000', 4, 10, 50);
insert into utb(b_datetime, b_q_id, b_v_id, b_vol) values('2003-01-01 01:12:12.000', 5, 11, 100);
insert into utb(b_datetime, b_q_id, b_v_id, b_vol) values('2003-01-01 01:12:13.000', 5, 12, 155);
insert into utb(b_datetime, b_q_id, b_v_id, b_vol) values('2003-01-01 01:12:14.000', 5, 13, 155);
insert into utb(b_datetime, b_q_id, b_v_id, b_vol) values('2003-01-01 01:12:15.000', 5, 14, 100);
insert into utb(b_datetime, b_q_id, b_v_id, b_vol) values('2003-01-01 01:12:16.000', 5, 15, 50);
insert into utb(b_datetime, b_q_id, b_v_id, b_vol) values('2003-01-01 01:12:17.000', 5, 16, 205);
insert into utb(b_datetime, b_q_id, b_v_id, b_vol) values('2003-01-01 01:12:18.000', 6, 10, 155);
insert into utb(b_datetime, b_q_id, b_v_id, b_vol) values('2003-01-01 01:12:19.000', 6, 17, 100);
insert into utb(b_datetime, b_q_id, b_v_id, b_vol) values('2003-01-01 01:12:20.000', 6, 18, 255);
insert into utb(b_datetime, b_q_id, b_v_id, b_vol) values('2003-01-01 01:12:21.000', 6, 19, 255);
insert into utb(b_datetime, b_q_id, b_v_id, b_vol) values('2003-01-01 01:12:22.000', 7, 17, 155);
insert into utb(b_datetime, b_q_id, b_v_id, b_vol) values('2003-01-01 01:12:23.000', 7, 20, 100);
insert into utb(b_datetime, b_q_id, b_v_id, b_vol) values('2003-01-01 01:12:24.000', 7, 21, 255);
insert into utb(b_datetime, b_q_id, b_v_id, b_vol) values('2003-01-01 01:12:25.000', 7, 22, 255);
insert into utb(b_datetime, b_q_id, b_v_id, b_vol) values('2003-01-01 01:12:26.000', 8, 10, 50);
insert into utb(b_datetime, b_q_id, b_v_id, b_vol) values('2003-01-01 01:12:27.000', 9, 23, 255);
insert into utb(b_datetime, b_q_id, b_v_id, b_vol) values('2003-01-01 01:12:28.000', 9, 24, 255);
insert into utb(b_datetime, b_q_id, b_v_id, b_vol) values('2003-01-01 01:12:29.000', 9, 25, 100);
insert into utb(b_datetime, b_q_id, b_v_id, b_vol) values('2003-01-01 01:12:30.000', 9, 26, 155);
insert into utb(b_datetime, b_q_id, b_v_id, b_vol) values('2003-01-01 01:12:31.000', 10, 25, 155);
insert into utb(b_datetime, b_q_id, b_v_id, b_vol) values('2003-01-01 01:12:31.000', 10, 26, 100);
insert into utb(b_datetime, b_q_id, b_v_id, b_vol) values('2003-01-01 01:12:33.000', 10, 27, 10);
insert into utb(b_datetime, b_q_id, b_v_id, b_vol) values('2003-01-01 01:12:34.000', 10, 28, 10);
insert into utb(b_datetime, b_q_id, b_v_id, b_vol) values('2003-01-01 01:12:35.000', 10, 29, 245);
insert into utb(b_datetime, b_q_id, b_v_id, b_vol) values('2003-01-01 01:12:36.000', 10, 30, 245);
insert into utb(b_datetime, b_q_id, b_v_id, b_vol) values('2003-01-01 01:12:37.000', 11, 31, 100);
insert into utb(b_datetime, b_q_id, b_v_id, b_vol) values('2003-01-01 01:12:38.000', 11, 32, 100);
insert into utb(b_datetime, b_q_id, b_v_id, b_vol) values('2003-01-01 01:12:39.000', 11, 33, 100);
insert into utb(b_datetime, b_q_id, b_v_id, b_vol) values('2003-01-01 01:12:40.000', 11, 34, 155);
insert into utb(b_datetime, b_q_id, b_v_id, b_vol) values('2003-01-01 01:12:41.000', 11, 35, 155);
insert into utb(b_datetime, b_q_id, b_v_id, b_vol) values('2003-01-01 01:12:42.000', 11, 36, 155);
insert into utb(b_datetime, b_q_id, b_v_id, b_vol) values('2003-01-01 01:12:43.000', 12, 31, 155);
insert into utb(b_datetime, b_q_id, b_v_id, b_vol) values('2003-01-01 01:12:44.000', 12, 32, 155);
insert into utb(b_datetime, b_q_id, b_v_id, b_vol) values('2003-01-01 01:12:45.000', 12, 33, 155);
insert into utb(b_datetime, b_q_id, b_v_id, b_vol) values('2003-01-01 01:12:46.000', 12, 34, 100);
insert into utb(b_datetime, b_q_id, b_v_id, b_vol) values('2003-01-01 01:12:47.000', 12, 35, 100);
insert into utb(b_datetime, b_q_id, b_v_id, b_vol) values('2003-01-01 01:12:48.000', 12, 36, 100);
insert into utb(b_datetime, b_q_id, b_v_id, b_vol) values('2003-01-01 01:13:01.000', 4, 37, 20);
insert into utb(b_datetime, b_q_id, b_v_id, b_vol) values('2003-01-01 01:13:02.000', 8, 38, 20);
insert into utb(b_datetime, b_q_id, b_v_id, b_vol) values('2003-01-01 01:13:03.000', 13, 39, 123);
insert into utb(b_datetime, b_q_id, b_v_id, b_vol) values('2003-01-01 01:13:04.000', 14, 39, 111);
insert into utb(b_datetime, b_q_id, b_v_id, b_vol) values('2003-01-01 01:13:05.000', 4, 37, 185);
insert into utb(b_datetime, b_q_id, b_v_id, b_vol) values('2003-01-01 01:13:05.000', 14, 40, 50);
insert into utb(b_datetime, b_q_id, b_v_id, b_vol) values('2003-01-01 01:13:06.000', 15, 41, 50);
insert into utb(b_datetime, b_q_id, b_v_id, b_vol) values('2003-01-01 01:13:07.000', 15, 41, 50);
insert into utb(b_datetime, b_q_id, b_v_id, b_vol) values('2003-01-01 01:13:08.000', 15, 42, 50);
insert into utb(b_datetime, b_q_id, b_v_id, b_vol) values('2003-01-01 01:13:09.000', 15, 42, 50);
insert into utb(b_datetime, b_q_id, b_v_id, b_vol) values('2003-01-01 01:13:10.000', 16, 42, 50);
insert into utb(b_datetime, b_q_id, b_v_id, b_vol) values('2003-01-01 01:13:11.000', 16, 42, 50);
insert into utb(b_datetime, b_q_id, b_v_id, b_vol) values('2003-01-01 01:13:12.000', 16, 43, 50);
insert into utb(b_datetime, b_q_id, b_v_id, b_vol) values('2003-01-01 01:13:13.000', 16, 43, 50);
insert into utb(b_datetime, b_q_id, b_v_id, b_vol) values('2003-01-01 01:13:14.000', 16, 47, 50);
insert into utb(b_datetime, b_q_id, b_v_id, b_vol) values('2003-01-01 01:13:15.000', 17, 44, 10);
insert into utb(b_datetime, b_q_id, b_v_id, b_vol) values('2003-01-01 01:13:16.000', 17, 44, 10);
insert into utb(b_datetime, b_q_id, b_v_id, b_vol) values('2003-01-01 01:13:17.000', 17, 45, 10);
insert into utb(b_datetime, b_q_id, b_v_id, b_vol) values('2003-01-01 01:13:18.000', 17, 45, 10);
insert into utb(b_datetime, b_q_id, b_v_id, b_vol) values('2003-01-01 01:13:24.000', 19, 44, 10);
insert into utb(b_datetime, b_q_id, b_v_id, b_vol) values('2003-01-01 01:13:25.000', 19, 45, 10);
insert into utb(b_datetime, b_q_id, b_v_id, b_vol) values('2003-01-01 01:13:26.000', 19, 45, 10);
insert into utb(b_datetime, b_q_id, b_v_id, b_vol) values('2003-02-01 01:13:19.000', 18, 45, 10);
insert into utb(b_datetime, b_q_id, b_v_id, b_vol) values('2003-02-01 01:13:27.000', 20, 45, 10);
insert into utb(b_datetime, b_q_id, b_v_id, b_vol) values('2003-02-01 01:13:31.000', 21, 49, 50);
insert into utb(b_datetime, b_q_id, b_v_id, b_vol) values('2003-02-02 01:13:32.000', 21, 49, 50);
insert into utb(b_datetime, b_q_id, b_v_id, b_vol) values('2003-02-03 01:13:33.000', 21, 50, 50);
insert into utb(b_datetime, b_q_id, b_v_id, b_vol) values('2003-02-04 01:13:34.000', 21, 50, 50);
insert into utb(b_datetime, b_q_id, b_v_id, b_vol) values('2003-02-05 01:13:35.000', 21, 48, 1);
insert into utb(b_datetime, b_q_id, b_v_id, b_vol) values('2003-03-01 01:13:20.000', 18, 45, 10);
insert into utb(b_datetime, b_q_id, b_v_id, b_vol) values('2003-03-01 01:13:28.000', 20, 45, 10);
insert into utb(b_datetime, b_q_id, b_v_id, b_vol) values('2003-04-01 01:13:21.000', 18, 46, 10);
insert into utb(b_datetime, b_q_id, b_v_id, b_vol) values('2003-04-01 01:13:29.000', 20, 46, 10);
insert into utb(b_datetime, b_q_id, b_v_id, b_vol) values('2003-05-01 01:13:22.000', 18, 46, 10);
insert into utb(b_datetime, b_q_id, b_v_id, b_vol) values('2003-05-01 01:13:30.000', 20, 46, 10);
insert into utb(b_datetime, b_q_id, b_v_id, b_vol) values('2003-06-11 01:13:23.000', 19, 44, 10);
insert into utb(b_datetime, b_q_id, b_v_id, b_vol) values('2003-06-23 01:12:02.000', 1, 1, 100);

select * from utq;
select * from utv;
select * from utb;