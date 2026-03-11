CREATE OR REPLACE VIEW view_books_full AS
SELECT 
    b.title,
    a.first_name || ' ' || a.last_name AS author,
    c.category_name,
    l.language_name
FROM books b
JOIN authors a ON b.authorid = a.authorid
JOIN categories c ON b.categoryid = c.categoryid
JOIN languages l ON b.languageid = l.languageid;

CREATE OR REPLACE VIEW view_users_contact AS
SELECT 
    u.first_name,
    u.last_name,
    e.email
FROM users u
JOIN emails e ON u.userid = e.userid;

CREATE OR REPLACE VIEW view_library_books AS
SELECT 
    l.library_name,
    b.title,
    bc.available
FROM book_copies bc
JOIN books b ON bc.bookid = b.bookid
JOIN libraries l ON bc.libraryid = l.libraryid;