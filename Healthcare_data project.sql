create database healthdb;
use healthdb;
select *from patients;
select * from appointments;
select * from billing;
select* from doctors;
select * from prescriptions;
select * from appointments
where patient_id=1;
select * from prescriptions
where appointment_id=1;
select * from billing
where appointment_id=1;
select a.appointment_id,p.first_name as patient_first_name,p.last_name as patient_last_name,
d.first_name as doctor_first_name,d.last_name as doctor_last_name,
b.amount,b.payment_date,b.status
from appointments a
join patients p on a.patient_id=p.patient_id
join doctors d on a.doctor_id=d.doctor_id
join billing b on a.appointment_id=b.appointment_id;
select * from billing
where status ='paid';
select 
(select sum(amount) from billing) as total_billed,
(select sum(amount) from billing where status ='paid') as total_paid;
select d.specialty,count(a.appointment_id) as number_of_apppointments
from appointments a
join doctors d on a.doctor_id=d.doctor_id
group by d.specialty;
select reason,
count(*) as count
from appointments
group by reason
order by count desc;
select p.patient_id,p.first_name,p.last_name,Max(a.appointment_date) as latest_appointment
from patients p
join appointments a on p.patient_id=a.patient_id
group by p.patient_id,p.first_name,p.last_name;
select d.doctor_id,d.first_name,d.last_name,count(a.appointment_id) as number_of_appointments
from doctors d
join appointments a on d.doctor_id=a.doctor_id
group by d.doctor_id,d.first_name,d.last_name;
select distinct p.* from patients p
join appointments a on p.patient_id=a.patient_id
where str_to_date(a.appointment_date,'%d-%m-%Y')>=curdate()-interval 30 day;
select pr.prescription_id,pr.medication,pr.dosage,pr.instructions
from prescriptions pr
join appointments a on pr.appointment_id=a.appointment_id
join billing b on a.appointrment_id = b.appointment_id
where b.status='pending';
select gender ,count(*) as count
from patients
group by gender;
select medication,count(*) as frequency,sum(cast(substring_index(dosage,'',1) as unsigned)) as total_dosage
from prescriptions
group by medication
order by frequency desc;
select p.patient_id,count(a.appointment_id)as appointment_count,avg(b.amount)as avg_billing_amount
from patients p
left join appointments a on p.patient_id=a.patient_id
left join billing b on a.appointment_id=b.appointment_id
group by p.patient_id;
select p.patient_id,p.first_name,p.last_name,sum(b.amount) as total_billed
from patients p
join appointments a on p.patient_id=a.patient_id
join billing b on a.appointment_id=b.appointment_id
group by p.patient_id,p.first_name,p.last_name
order by total_billed desc
limit 10;
select date_format(payment_date,'%Y-%m') as month ,status,count(*) as count
from billing
group by month,status
order by month,status;
select p.patient_id,p.first_name,p.last_name,sum(b.amount) as total_unpaid
from patients p
join appointments a on p.patient_id=a.patient_id
join billing b on a.appointment_id=b.appointment_id
where b.status='pending'
group by p.patient_id,p.first_name,p.last_name
order by total_unpaid desc;
select d.doctor_id,d.first_name,d.last_name,count(a.appointment_id) as number_of_appointments
from doctors d
join appointments a on d.doctor_id=a.doctor_id
group by d.doctor_id,d.first_name,d.last_name;
select appointment_date,count(*) as appointment_count
from appointments
group by appointment_date;
select p.patient_id,p.first_name,p.last_name
from patients p
left join appointments a on p.patient_id=a.patient_id
where a.appointment_id is null;
select a.appointment_id,a.patient_id,a.doctor_id,a.appointment_date
from appointments a
left join billing b on a.appointment_id=b.appointment_id
where b.billing_id is null;
select a.appointment_id,p.first_name as patient_first_name,p.last_name as patient_last_name,a.appointment_date,a.reason
from appointments a
join patients p on a.patient_id=p.patient_id
where a.doctor_id=1;
select p.medication,p.dosage,p.instructions,b.amount,b.payment_date,b.status
from prescriptions p 
join appointments a on p.appointment_id=a.appointment_id
join billing b on a.appointment_id=b.appointment_id
where b.status='pending';
select distinct p.first_name,p.last_name,p.dob,p.gender,a.appointment_date
from patients p
join appointments a on p.patient_id = a.patient_id
where date_format(a.appointment_date,'%Y-%m') ='2025-08';
select d.first_name,d.last_name as patient_last_name
from doctors d
join appointments a on d.doctor_id=a.doctor_id
join patients p on a.patient_id=p.patient_id
where a.appointment_date between '2024-08-01' and '2024-08-10';
set sql_safe_updates=0;
update appointments
set appointment_date=str_to_date(appointment_date,'%d-%m-%Y');
alter table appointments 
modify appointment_date
date;
select d.first_name, d.last_name,d.specialty, sum(b.amount) as total_billed
from doctors d
join appointments a on d.doctor_id = a.doctor_id
join billing b on a.appointment_id = b.appointment_id
group by d.first_name,d.last_name,d.specialty
order by total_billed desc;

