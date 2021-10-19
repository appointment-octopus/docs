insert into USERS (CPF, gender, dateOfBirth, email, fullName, "password") 
values ('35239782152', 'M', '2001-09-28', 'email@gmail.com', 'Martinho da Vila', 'senha');

insert into celphone (celphoneNumber, fk_idUser)
values ('+55 61 3232-8065', 1), ('+55 61 9 9989-8065', 1);

insert into CREDIT_CARD (cardNumber, cardholderName, CVV, expirationYear, expirationMonth, fk_idUser) values
('1234 5678 9012 3456', 'MARTINHO J FERREIRA', '055', 2035, 5, 1);


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
    d := startdate;

    FOR i IN 1..rowCount LOOP
        INSERT INTO POSSIBLE_HOURS ("time", vacant, fk_idDay) values (d + time ''09:00'', true, i), (d + time ''12:00'', true, i), (d + time ''15:00'', true, i);
        d := d + 1;
	END LOOP;
END;
'
LANGUAGE plpgsql;

SELECT createDates('2021-10-19', '2021-12-31');

    
insert into APPOINTMENTS (fk_idUser, fk_idHour) values (1, 1);
insert into APPOINTMENTS (fk_idUser, fk_idHour) values (1, 2);
insert into APPOINTMENTS (fk_idUser, fk_idHour) values (1, 3);

select * from USERS;
select * from celphone where fk_idUser = 1;
select * from CREDIT_CARD where fk_idUser = 1;
select * from POSSIBLE_DAYS;
select * from POSSIBLE_HOURS;
select * from APPOINTMENTS;
