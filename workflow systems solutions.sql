-- 1. Вывести список имен сотрудников, получающих заработную плату большую, чем у непосредственного руководителя
select worker.title
from worker
left join worker as chief
on worker.chief_id = chief.worker_id
where worker.salary > chief.salary;

-- 2. Вывести список имен сотрудников, получающих максимальную зарплату в своем отделе 
select worker.title
from worker
group by department_id
having max(worker.salary);

-- 3. Вывести список названий отделов, количество сотрудников в которых не превышает 3-х человек
select department.title
from department
left join worker
on department.department_id = worker.department_id
group by department.department_id
having count(worker_id) <= 3;

-- 4. Вывести список имен сотрудников, не имеющих назначенного руководителя, работающего в том же отделе
select * 
from worker
left join worker as chief
on worker.chief_id = chief.worker_id
where chief.department_id <> worker.department_id;

-- 5. Вывести список названий отделов с максимальной суммарной заплатой сотрудников
select department.title
from department
left join worker
on department.department_id = worker.department_id
group by department.department_id
having sum(salary) = (
	select max(salary) from (
		select department.department_id, department.title, sum(salary) as salary
		from department
		left join worker
		on department.department_id = worker.department_id
		group by department.department_id
		) as department_salary
);