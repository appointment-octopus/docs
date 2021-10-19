CREATE TABLE IF NOT EXISTS USERS (
    idUser SERIAL PRIMARY KEY,
    CPF VARCHAR(11) UNIQUE NOT NULL,
    gender VARCHAR(15) NOT NULL,
    dateOfBirth DATE NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    fullName VARCHAR(150) NOT NULL,
    "password" VARCHAR(255) NOT NULL,
    profilePicture BYTEA
);

CREATE TABLE IF NOT EXISTS cellphone (
    idCellphone SERIAL PRIMARY KEY,
    cellphoneNumber VARCHAR(25),
    fk_idUser SERIAL NOT NULL,
    CONSTRAINT FK_USERS_idUser
      FOREIGN KEY(fk_idUser) 
      REFERENCES USERS(idUser)
);

CREATE TABLE IF NOT EXISTS CREDIT_CARD (
    idCreditCard SERIAL PRIMARY KEY,
    cardNumber VARCHAR(20) NOT NULL,
    cardholderName VARCHAR(50) NOT NULL,
    CVV VARCHAR(3) NOT NULL,
    expirationYear SMALLINT NOT NULL,
    expirationMonth SMALLINT NOT NULL,
    fk_idUser SERIAL NOT NULL,
    CONSTRAINT FK_USERS_idUser
      FOREIGN KEY(fk_idUser) 
      REFERENCES USERS(idUser)
);

CREATE TABLE IF NOT EXISTS POSSIBLE_DAYS (
    idDay SERIAL PRIMARY KEY,
    "day" DATE NOT NULL,
    vacant BOOLEAN NOT NULL
);

CREATE TABLE IF NOT EXISTS POSSIBLE_HOURS (
    idHour SERIAL PRIMARY KEY,
    "time" TIMESTAMP NOT NULL,
    vacant BOOLEAN NOT NULL,
    fk_idDay SERIAL NOT NULL,
    CONSTRAINT FK_POSSIBLE_DAYS_idDay
      FOREIGN KEY(fk_idDay)
      REFERENCES POSSIBLE_DAYS(idDay)
);

CREATE TABLE IF NOT EXISTS APPOINTMENTS (
    fk_idUser SERIAL NOT NULL,
    fk_idHour SERIAL NOT NULL,
    CONSTRAINT FK_USERS_idUser
      FOREIGN KEY(fk_idUser)
      REFERENCES USERS(idUser),
    CONSTRAINT FK_POSSIBLE_HOURS_idHour
      FOREIGN KEY(fk_idHour)
      REFERENCES POSSIBLE_HOURS(idHour)
);

CREATE OR REPLACE FUNCTION set_vacancy_on_hours() RETURNS TRIGGER AS
'
BEGIN
    UPDATE POSSIBLE_HOURS
	SET vacant = ''f''
	WHERE POSSIBLE_HOURS.idHour = new.fk_idHour;
    RETURN new;
END;
'
LANGUAGE plpgsql;

CREATE TRIGGER trig_hour
     AFTER INSERT ON APPOINTMENTS
     FOR EACH ROW
     EXECUTE PROCEDURE set_vacancy_on_hours();



CREATE OR REPLACE FUNCTION set_vacancy_on_day() RETURNS TRIGGER AS
'
DECLARE countVacancies int;
BEGIN
    countVacancies := (SELECT count(*) from POSSIBLE_HOURS where vacant = ''true'' and fk_idDay = new.fk_idDay);
    
    IF (countVacancies = 0) THEN
        UPDATE POSSIBLE_DAYS
            SET vacant = ''f''
            WHERE POSSIBLE_DAYS.idDay = new.fk_idDay;
    END IF;
	
    RETURN new;
END;
'
LANGUAGE plpgsql;

CREATE TRIGGER trig_day
     AFTER UPDATE ON POSSIBLE_HOURS
     FOR EACH ROW
     EXECUTE PROCEDURE set_vacancy_on_day();
