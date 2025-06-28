Display all the details of all ‘Mgrs’
select * from emps
where emp_designation='Mgrs'

List the emps who joined before 1981.
select * from emps
where extract(year emp_join) <1981

List the Empno, Ename, Sal, Daily sal of all emps in the asc order of Annsal.
select Empno, Ename, Sal, (sal/30) as daily_sal
from emps order by sal asc

Display the Empno, Ename, job, Hiredate, Exp of all Mgrs
select Empno, Ename, job, Hiredate, Exp
from emps where Job='Mgr'

List the Empno, Ename, Sal, Exp of all emps working for Mgr 7369.
select Empno, Ename, Sal, Exp
from emps where Mgr=7369
