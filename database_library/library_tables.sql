CREATE TABLE Categories (
	categoryId SERIAL PRIMARY KEY,
	category_name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE Languages (
	languageId SERIAL PRIMARY KEY,
	language_name VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE Users (
	userId SERIAL PRIMARY KEY,
	first_name VARCHAR(50) NOT NULL,
	last_name VARCHAR(50) NOT NULL
);

CREATE TABLE Authors(
	authorId SERIAL PRIMARY KEY,
	first_name VARCHAR(100),
	last_name VARCHAR(100)
);

CREATE TABLE Libraries(
	libraryId SERIAL PRIMARY KEY,
	library_name VARCHAR(200) NOT NULL,
	city VARCHAR(100),
	UNIQUE(library_name, city)
);

CREATE TABLE Books(
	bookId SERIAL PRIMARY KEY,
	title VARCHAR(200) NOT NULL,
	authorId INT NOT NULL,
	categoryId INT NOT NULL,
	languageId INT NOT NULL,
	FOREIGN KEY (authorId) REFERENCES Authors(authorId),
    FOREIGN KEY (categoryId) REFERENCES Categories(categoryId),
    FOREIGN KEY (languageId) REFERENCES Languages(languageId)
);

CREATE TABLE Emails (
	emailId SERIAL PRIMARY KEY,
	userId INT NOT NULL,
	email VARCHAR(150) NOT NULL UNIQUE,
	FOREIGN KEY (userId) REFERENCES Users(userId)
);

CREATE TABLE Phone_numbers (
	phoneId SERIAL PRIMARY KEY,
	userId INT NOT NULL,
	phone VARCHAR(15) NOT NULL,
	UNIQUE(userId, phone),
	FOREIGN KEY (userId) REFERENCES Users(userId)
);

CREATE TABLE Book_copies (
	copyId SERIAL PRIMARY KEY,
	bookId INT NOT NULL,
	libraryId INT NOT NULL,
	available BOOLEAN DEFAULT TRUE,
	FOREIGN KEY (bookId) REFERENCES Books(bookId),
	FOREIGN KEY (libraryId) REFERENCES Libraries(libraryId)
);

CREATE TABLE reservations (
    reservationid SERIAL PRIMARY KEY,
    copyid INT NOT NULL,
    userid INT NOT NULL,
    reservation_date DATE NOT NULL,
    status VARCHAR(50) DEFAULT 'active',
    FOREIGN KEY (copyid) REFERENCES book_copies(copyid),
    FOREIGN KEY (userid) REFERENCES users(userid)
);