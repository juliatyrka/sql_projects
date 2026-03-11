INSERT INTO categories (category_name)
VALUES ('Non-Fiction'), ('Romance');

INSERT INTO languages (language_name)
VALUES ('Polish'), ('English');

INSERT INTO authors (first_name, last_name)
VALUES 
('Colleen', 'Hoover'),
('Morgan', 'Housel'),
('Ali', 'Abdaal');

INSERT INTO libraries (library_name, city)
VALUES 
('Biblioteka Uniwersytecka', 'Wroclaw'),
('Miejska Biblioteka Publiczna', 'Opole');

INSERT INTO users (first_name, last_name)
VALUES 
('Julia', 'Tyrka'),
('Anna', 'Nowak');

INSERT INTO books (title, authorid, categoryid, languageid)
VALUES 
('Reminders of Him', 1, 2, 2),
('Psychology of Money', 2, 1, 2),
('Feel Good Productivity', 3, 1, 2);

INSERT INTO reservations (reservationid, copyid, userid, reservation_date, status)
VALUES 
(1,1,2,'02/03/2025','active');

UPDATE users
SET first_name = 'Anastazja',
WHERE id = 2;