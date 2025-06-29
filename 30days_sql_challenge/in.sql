Display all the details of the emps whose Comm. Is more than their Sal.
select * from emps
where comm>sal

List the emps in the asc order of Designations of those joined after the second half- of 1981.
select * from emps
where joined > 1981-06-30
order by designation asc

Not.List the emps along with their Exp and Daily Sal is more than Rs.100.
select emp_name, exp, (sal/30) as daily_sal
from emps
where (sal/30) > 100

List the emps who are either ‘CLERK’ or ‘ANALYST’ in the Desc order.
select * from emps
where designation in (‘CLERK’,‘ANALYST’)
order by designation desc

List the emps who joined on 1-MAY-81,3-DEC-81,17-DEC-81,19-JAN-80 in asc order of seniority.
select * from emps
where joined in ( '1981-05-01','1981-12-03','1981-12-17','1980-01-19')
order by joined asc
