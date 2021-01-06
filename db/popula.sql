insert into PATIENT (CPF, gender, dateOfBirth, email, fullName) 
values ('35239782152', 'M', '2001-09-28', 'email@gmail.com', 'Martinho da Vila');

insert into celphone (celphoneNumber, fk_idPatient)
values ('+55 61 3232-8065', 1), ('+55 61 9 9989-8065', 1);

insert into CREDIT_CARD (cardNumber, cardholderName, CVV, expirationDate, fk_idPatient) values
('1234 5678 9012 3456', 'MARTINHO J FERREIRA', '055', ROW(2035, 5), 1);


CREATE OR REPLACE FUNCTION createDates(startdate date, enddate date)
RETURNS void AS
'
DECLARE d date := startdate;
DECLARE rowCount int;
BEGIN
    
    LOOP
        insert into POSSIBLE_DAYS ("day", vacant) values (d, true);
    	d := d + 1;
    	EXIT WHEN d > $2;
	END LOOP;
    
    rowCount := (SELECT count(*) FROM POSSIBLE_DAYS);
    
    FOR i IN 1..rowCount LOOP
        INSERT INTO POSSIBLE_HOURS ("time", vacant, fk_idDay) values (''09:00'', true, i), (''12:00'', true, i), (''15:00'', true, i);
	END LOOP;
END;
'
LANGUAGE plpgsql;

SELECT createDates('2021-01-05', '2021-01-06');



     
insert into APPOINTMENTS (fk_idPatient, fk_idHour) values (1, 1);
insert into APPOINTMENTS (fk_idPatient, fk_idHour) values (1, 2);
insert into APPOINTMENTS (fk_idPatient, fk_idHour) values (1, 3);

select * from PATIENT;
select * from celphone where fk_idPatient = 1;
select * from CREDIT_CARD where fk_idPatient = 1;
select * from POSSIBLE_DAYS;
select * from POSSIBLE_HOURS;
select * from APPOINTMENTS;
