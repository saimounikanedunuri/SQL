Display all the information of the EMP table?
select * from emps

Display unique Jobs from EMP table?
select distinct job_id from emps

List the emps in the asc order of their Salaries?
select emp_id, emp_name, emp_sal
from emps
order by Salaries asc

List the details of the emps in asc order of the Dptnos and desc of Jobs?
select * from emps
order by Dptnos asc, Jobs desc

Display all the unique job groups in the descending order?
select distinct job_group
from emps
order by job_group desc
