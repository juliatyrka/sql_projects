CREATE OR REPLACE PROCEDURE update_book(
    p_bookId INT,
    p_title VARCHAR,
    p_authorId INT,
    p_categoryId INT,
    p_languageId INT
)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE Books
    SET title = p_title,
        authorId = p_authorId,
        categoryId = p_categoryId,
        languageId = p_languageId
    WHERE bookId = p_bookId;
END;
$$;

CREATE OR REPLACE PROCEDURE delete_book(
    p_bookId INT
)
LANGUAGE plpgsql
AS $$
BEGIN
    DELETE FROM Books
    WHERE bookId = p_bookId;
END;
$$;

CREATE OR REPLACE PROCEDURE create_reservation(
    p_copyid INT,
    p_userid INT,
    p_reservation_date DATE
)
LANGUAGE plpgsql
AS $$
BEGIN

    IF NOT EXISTS (
        SELECT 1 FROM Book_copies
        WHERE copyid = p_copyid AND available = TRUE
    ) THEN
        RAISE EXCEPTION 'Copy is not available';
    END IF;

    INSERT INTO reservations(copyid, userid, reservation_date)
    VALUES (p_copyid, p_userid, p_reservation_date);

    UPDATE Book_copies
    SET available = FALSE
    WHERE copyid = p_copyid;

END;
$$;

CREATE OR REPLACE PROCEDURE update_reservation_status(
	p_reservationid INT,
	p_status VARCHAR
)
LANGUAGE plpgsql
AS $$
BEGIN
	UPDATE reservations
	SET status = p_status
	WHERE reservationid=p_reservationid;
END;
$$;

CREATE OR REPLACE FUNCTION get_active_reservations_by_user(p_userid INT)
RETURNS TABLE(
    reservationid INT,
    title VARCHAR,
    reservation_date DATE,
    status VARCHAR
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT r.reservationid, b.title, r.reservation_date, r.status
    FROM reservations r
    JOIN book_copies bc ON r.copyid = bc.copyid
    JOIN books b ON bc.bookid = b.bookid
    WHERE r.userid = p_userid
    AND r.status = 'active';
END;
$$;

CREATE OR REPLACE FUNCTION get_reservations_by_book(p_bookid INT)
RETURNS TABLE(
    reservationid INT,
    userid INT,
    reservation_date DATE,
    status VARCHAR
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT r.reservationid, r.userid, r.reservation_date, r.status
    FROM reservations r
    JOIN book_copies bc ON r.copyid = bc.copyid
    WHERE bc.bookid = p_bookid;
END;
$$;