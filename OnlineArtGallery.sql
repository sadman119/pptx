SET SQL_SAFE_UPDATES = 0;
drop database DIU_online_art_gallery;

create database DIU_online_art_gallery;
USE DIU_online_art_gallery;

CREATE TABLE artists (
    artist_id int auto_increment primary key,
    name varchar(50) not null,
    biography text,
    country varchar(30),
    created_at timestamp default current_timestamp
);

CREATE TABLE artworks (
    artwork_id int auto_increment primary key,
    title varchar(255) not null,
    artist_id int not null,
    year_created year null,
    medium varchar(100),
    dimensions varchar(100),
    price decimal(10,2) check (price >= 0),
    is_available int default 1,
    stock int check (stock >= 0),
    created_at timestamp default current_timestamp,
    foreign key (artist_id) references artists(artist_id)
);

CREATE TABLE exhibitions (
    exhibition_id int auto_increment primary key,
    name varchar(255) not null,
    start_date date,
    end_date date,
    location varchar(255),
    description text,
    created_at timestamp default current_timestamp
);

CREATE TABLE exhibition_artworks (
    exhibition_artwork_id int auto_increment primary key,
    exhibition_id int not null,
    artwork_id int not null,
    display_position varchar(100),
    foreign key (exhibition_id) references exhibitions(exhibition_id),
    foreign key (artwork_id) references artworks(artwork_id),
    unique key ux_exh_art (exhibition_id, artwork_id)
);

CREATE TABLE members (
    member_id int auto_increment primary key,
    full_name varchar(50) not null,
    email varchar(50) unique,
    phone varchar(50),
    address text,
    membership_type varchar(20) default 'guest' check (membership_type in ('guest','premium','vip')),
    joined_at timestamp default current_timestamp
);

CREATE TABLE users (
    user_id int auto_increment primary key,
    username varchar(100) unique not null,
    display_name varchar(200),
    role varchar(20) default 'staff',
    created_at timestamp default current_timestamp
);

CREATE TABLE sales (
    sale_id int auto_increment primary key,
    artwork_id int not null,
    member_id int null,
    quantity int not null default 1 check (quantity > 0),
    sale_price decimal(12,2) not null check (sale_price >= 0),
    sale_date timestamp default current_timestamp,
    handled_by int null,
    foreign key (artwork_id) references artworks(artwork_id),
    foreign key (member_id) references members(member_id),
    foreign key (handled_by) references users(user_id)
);

CREATE TABLE audit_logs (
    log_id int auto_increment primary key,
    action_type varchar(50),
    action_by varchar(50),
    action_time timestamp default current_timestamp,
    description text
);

CREATE TABLE auctions (
    auction_id int auto_increment primary key,
    artwork_id int not null,
    start_price decimal(12,2) not null check (start_price >= 0),
    start_time datetime not null,
    end_time datetime not null,
    status varchar(20) default 'upcoming',
    winner_member_id int,
    foreign key (artwork_id) references artworks(artwork_id),
    foreign key (winner_member_id) references members(member_id)
);

CREATE TABLE auction_bids (
    bid_id int auto_increment primary key,
    auction_id int not null,
    member_id int not null,
    bid_amount decimal(12,2) not null check (bid_amount > 0),
    bid_time timestamp default current_timestamp,
    foreign key (auction_id) references auctions(auction_id),
    foreign key (member_id) references members(member_id)
);

ALTER TABLE exhibitions AUTO_INCREMENT = 1;
ALTER TABLE exhibition_artworks AUTO_INCREMENT = 1;
ALTER TABLE members AUTO_INCREMENT = 1;
ALTER TABLE users AUTO_INCREMENT = 1;
ALTER TABLE sales AUTO_INCREMENT = 1;
ALTER TABLE audit_logs AUTO_INCREMENT = 1;
ALTER TABLE auctions AUTO_INCREMENT = 1;
ALTER TABLE auction_bids AUTO_INCREMENT = 1;

INSERT INTO artists (name, biography, country) VALUES
('Leonardo da Vinci', 'Renaissance polymath known for the Mona Lisa and The Last Supper.', 'Italy'),
('Vincent van Gogh', 'Post-Impressionist painter known for Starry Night and Sunflowers.', 'Netherlands'),
('Pablo Picasso', 'Co-founder of Cubist movement, known for Guernica.', 'Spain'),
('Claude Monet', 'Founder of French Impressionist painting, known for Water Lilies.', 'France'),
('Frida Kahlo', 'Known for her many portraits and self-portraits inspired by nature.', 'Mexico'),
('Salvador Dali', 'Surrealist artist known for his bizarre and dream-like paintings.', 'Spain'),
('Michelangelo', 'Renaissance sculptor and painter, known for David and Sistine Chapel.', 'Italy'),
('Rembrandt', 'Dutch Golden Age painter and printmaker.', 'Netherlands');


INSERT INTO artworks 
(title, artist_id, year_created, medium, dimensions, price, stock) 
VALUES
('Mona Lisa', 1, 1955, 'Oil on poplar panel', '77 × 53 cm', 860000.00, 0),
('Starry Night', 2, 1989, 'Oil on canvas', '73.7 × 92.1 cm', 100000.00, 2),
('Guernica', 3, 1937, 'Oil on canvas', '349 × 776 cm', 200000.00, 1),
('Water Lilies', 4, 1915, 'Oil on canvas', '200 × 425 cm', 54000.00, 3),
('The Two Fridas', 5, 1939, 'Oil on canvas', '173 × 173 cm', 35000.00, 2),
('The Persistence of Memory', 6, 1931, 'Oil on canvas', '24 × 33 cm', 15000.00, 1),
('David', 7, 1904, 'Marble sculpture', '517 cm × 199 cm', 50000.00, 0),
('The Night Watch', 8, 1980, 'Oil on canvas', '363 × 437 cm', 50000.00, 1),
('Sunflowers', 2, 1988, 'Oil on canvas', '92 × 73 cm', 85000.00, 4),
('The Weeping Woman', 3, 1937, 'Oil on canvas', '61 × 50 cm', 10000.00, 2);

select * from artworks;

INSERT INTO exhibitions (name, start_date, end_date, location, description) VALUES
('Renaissance Masters', '2024-01-15', '2024-03-15', 'Main Gallery Hall', 'Collection of Renaissance era masterpieces'),
('Impressionist Revolution', '2024-02-01', '2024-04-30', 'East Wing Gallery', 'Works from the Impressionist movement'),
('Modern Art Showcase', '2024-03-10', '2024-06-10', 'West Wing Gallery', 'Contemporary and modern art pieces'),
('Surreal Dreams', '2024-04-05', '2024-07-05', 'Special Exhibition Hall', 'Surrealist art exhibition'),
('Dutch Golden Age', '2024-05-01', '2024-08-01', 'North Gallery', 'Art from the Dutch Golden Age period'),
('Female Artists Collection', '2024-06-15', '2024-09-15', 'South Gallery', 'Celebrating female artists through history'),
('Summer Masterpieces', '2024-07-01', '2024-10-01', 'Central Atrium', 'Seasonal collection of famous works'),
('Cubist Perspectives', '2024-08-10', '2024-11-10', 'Modern Art Wing', 'Exploring Cubist art movement');



INSERT INTO exhibition_artworks (exhibition_id, artwork_id, display_position) VALUES 
(1, 1, 'Hall Center - Position A1'),
(1, 7, 'Hall Right - Position B2'),
(2, 4, 'East Wing - Position E3'),
(2, 9, 'East Wing - Position E5'),
(3, 3, 'West Wing - Position W1'),
(3, 6, 'West Wing - Position W4'),
(4, 6, 'Special Hall - Position S2'),
(4, 10, 'Special Hall - Position S3'),
(5, 8, 'North Gallery - Position N1'),
(6, 5, 'South Gallery - Position S1'),
(7, 2, 'Atrium Center - Position C1'),
(7, 9, 'Atrium Right - Position C3'),
(8, 3, 'Modern Wing - Position M2'),
(8, 10, 'Modern Wing - Position M4');



INSERT INTO members (full_name, email, phone, address, membership_type) VALUES
('John Smith', 'john.smith@email.com', '+1-555-0101', '123 Art Street, New York', 'vip'),
('Emma Johnson', 'emma.j@email.com', '+1-555-0102', '456 Gallery Road, Boston', 'premium'),
('Michael Brown', 'm.brown@email.com', '+1-555-0103', '789 Canvas Ave, Chicago', 'premium'),
('Sarah Davis', 'sarahd@email.com', '+1-555-0104', '321 Brush Lane, LA', 'guest'),
('Robert Wilson', 'rob.wilson@email.com', '+1-555-0105', '654 Palette St, Miami', 'vip'),
('Lisa Anderson', 'lisa.a@email.com', '+1-555-0106', '987 Artist Blvd, Seattle', 'premium'),
('David Miller', 'd.miller@email.com', '+1-555-0107', '147 Sculpture Rd, Austin', 'guest'),
('Jennifer Taylor', 'j.taylor@email.com', '+1-555-0108', '258 Masterpiece Ave, Denver', 'vip');


INSERT INTO users (username, display_name, role) VALUES
('admin', 'System Administrator', 'admin'),
('gallery_manager', 'Gallery Manager', 'manager'),
('sales_staff1', 'Sales Representative 1', 'staff'),
('sales_staff2', 'Sales Representative 2', 'staff'),
('curator1', 'Head Curator', 'curator'),
('curator2', 'Assistant Curator', 'curator'),
('auction_manager', 'Auction Manager', 'manager'),
('front_desk', 'Front Desk Staff', 'staff');


INSERT INTO sales (artwork_id, member_id, quantity, sale_price, sale_date, handled_by) VALUES
(9, 1, 2, 170000.00, '2024-01-20 10:30:00', 3),
(2, 2, 1, 100000.00, '2024-02-05 14:15:00', 4),
(5, 5, 1, 35000.00, '2024-02-12 11:45:00', 3),
(10, 3, 1, 100000.00, '2024-03-01 09:30:00', 4),
(4, 6, 2, 108000.00, '2024-03-15 16:20:00', 3),
(9, 8, 1, 85000.00, '2024-04-02 13:10:00', 4),
(6, 1, 1, 150000.00, '2024-04-10 15:45:00', 3),
(10, 5, 1, 100000.00, '2024-04-18 10:15:00', 4);


INSERT INTO auctions (artwork_id, start_price, start_time, end_time, status, winner_member_id) VALUES
(1, 80000.00, '2024-01-10 09:00:00', '2024-01-20 17:00:00', 'completed', 1),
(3, 180000.00, '2024-02-15 10:00:00', '2024-02-25 18:00:00', 'completed', 5),
(7, 450000.00, '2024-03-01 09:00:00', '2024-03-10 17:00:00', 'completed', 8),
(8, 450000.00, '2024-04-05 10:00:00', '2024-04-15 18:00:00', 'ongoing', NULL),
(2, 90000.00, '2024-05-10 09:00:00', '2024-05-20 17:00:00', 'upcoming', NULL),
(4, 50000.00, '2024-06-01 10:00:00', '2024-06-10 18:00:00', 'upcoming', NULL);


INSERT INTO auction_bids (auction_id, member_id, bid_amount, bid_time) VALUES
(1, 1, 820000000.00, '2024-01-15 14:30:00'),
(1, 5, 840000000.00, '2024-01-16 11:20:00'),
(1, 1, 860000000.00, '2024-01-18 15:45:00'),
(2, 3, 185000000.00, '2024-02-18 12:15:00'),
(2, 5, 195000000.00, '2024-02-20 14:30:00'),
(2, 8, 200000000.00, '2024-02-22 16:45:00'),
(3, 1, 470000000.00, '2024-03-05 10:20:00'),
(3, 8, 500000000.00, '2024-03-08 15:30:00'),
(4, 2, 460000000.00, '2024-04-10 11:45:00'),
(4, 6, 480000000.00, '2024-04-12 14:20:00');






DELIMITER //
CREATE TRIGGER trg_before_sale_check_availability
before insert on sales
for each row
BEGIN
    declare available_stock int;
    select stock into available_stock from artworks where artwork_id = new.artwork_id;
    if available_stock is null then
        signal sqlstate '45000' set message_text = 'Artwork does not exist.';
    end if;
    if available_stock < new.quantity then
        signal sqlstate '45000' set message_text = 'Not enough stock available.';
    end if;
end
//
DELIMITER ;






DELIMITER //
CREATE TRIGGER trg_after_sale_update_stock
after insert on sales
for each row
BEGIN
    update artworks
    set stock = stock - new.quantity,
     is_available = case when (stock - new.quantity <= 0) then 0 
     else 1 end
    where 
        artwork_id = new.artwork_id;
    INSERT INTO audit_logs(action_type, action_by, description)
    values('sale', 'system', concat('Artwork ', new.artwork_id, ' sold, Quantity: ', new.quantity));
end
//
DELIMITER ;






DELIMITER //
CREATE TRIGGER trg_after_update_stock
after update on artworks
for each row
BEGIN
    if old.stock <> new.stock then
        update artworks 
        set is_available = case when new.stock <= 0 
        then 0 
        else 1 
        end
        where artwork_id = new.artwork_id;
    end if;
end
//
DELIMITER ;








DELIMITER //
CREATE TRIGGER trg_before_insert_bid
before insert on auction_bids
for each row
BEGIN
    declare highest_bid decimal(12,2);
    declare start_price decimal(12,2);
    declare a_start datetime;
    declare a_end datetime;

    select auctions.start_price, auctions.start_time, auctions.end_time into start_price, a_start, a_end
    from auctions where auction_id = new.auction_id;

    if now() < a_start or now() > a_end then
        signal sqlstate '45000' set message_text = 'Bidding closed for this auction.';
    end if;

    select max(bid_amount) into highest_bid from auction_bids where auction_id = new.auction_id;

    if highest_bid is null then
        set highest_bid = start_price;
    end if;

    if new.bid_amount <= highest_bid then
        signal sqlstate '45000' set message_text = 'Bid must be higher than the current highest bid.';
    end if;
end
//
DELIMITER ;






DELIMITER //
CREATE TRIGGER trg_after_add_artwork
after insert on artworks
for each row
BEGIN
    INSERT INTO audit_logs(action_type, action_by, description)
    values('add_artwork', 'system', concat('Artwork "', new.title, '" added.'));
end
//
DELIMITER ;








DELIMITER //
CREATE TRIGGER trg_after_register_member
after insert on members
for each row
BEGIN
    INSERT INTO audit_logs(action_type, action_by, description)
    values('register_member', 'system', concat('New member "', new.full_name, '" registered.'));
end
//
DELIMITER ;







DELIMITER //
CREATE TRIGGER trg_after_add_auction
after insert on auctions
for each row
BEGIN
    INSERT INTO audit_logs(action_type, action_by, description)
    values('add_auction', 'system', concat('Auction for artwork id ', new.artwork_id, ' created.'));
end
//
DELIMITER ;





CREATE VIEW view_available_artworks as
select * from artworks where is_available = 1;




CREATE VIEW view_top_selling_artworks as
select a.artwork_id, a.title, sum(s.quantity) as total_sold
from artworks a
join sales s on a.artwork_id = s.artwork_id
group by a.artwork_id, a.title
order by total_sold desc;




CREATE VIEW view_artist_profiles as
select ar.artist_id, ar.name, ar.biography, aw.artwork_id, aw.title
from artists ar
left join artworks aw on ar.artist_id = aw.artist_id;





CREATE VIEW view_auction_status as
select a.auction_id, aw.title, a.start_price, max(b.bid_amount) as highest_bid, a.status
from auctions a
join artworks aw on a.artwork_id = aw.artwork_id
left join auction_bids b on a.auction_id = b.auction_id
group by a.auction_id, aw.title, a.start_price, a.status;







DELIMITER //
CREATE PROCEDURE add_artwork(
    in p_title varchar(255),
    in p_artist_id int,
    in p_year year,
    in p_medium varchar(100),
    in p_dimensions varchar(100),
    in p_price decimal(10,2),
    in p_stock int
)
BEGIN
    INSERT INTO artworks (title, artist_id, year_created, medium, dimensions, price, stock)
    values (p_title, p_artist_id, p_year, p_medium, p_dimensions, p_price, p_stock);
end
//






CREATE PROCEDURE register_member(
    in p_name varchar(200),
    in p_email varchar(200),
    in p_phone varchar(50),
    in p_address text,
    in p_type varchar(20)
)
BEGIN
    INSERT INTO members (full_name, email, phone, address, membership_type)
    values (p_name, p_email, p_phone, p_address, p_type);
end
//






CREATE PROCEDURE add_artist(
    in p_name varchar(200),
    in p_bio text,
    in p_country varchar(100)
)
BEGIN
    INSERT INTO artists (name, biography, country)
    values (p_name, p_bio, p_country);
end
//


CALL add_artist(
    'Diego Rivera',
    'Mexican muralist known for large frescoes.',
    'Mexico'
);



CREATE PROCEDURE show_available_artwork()
BEGIN
    select * from artworks where is_available = 1;
end
//



CREATE PROCEDURE top_selling_artworks()
BEGIN
    select a.artwork_id, a.title, sum(s.quantity) as total_sold
    from artworks a
    join sales s on a.artwork_id = s.artwork_id
    group by a.artwork_id, a.title
    order by total_sold desc;
end
//





CREATE PROCEDURE show_unavailable_artworks()
BEGIN
    select * from artworks where is_available = 0;
end
//






CREATE PROCEDURE show_stock()
BEGIN
    select artwork_id, title, stock from artworks;
end
//






CREATE PROCEDURE artist_details_with_theirartwork()
BEGIN
    select ar.artist_id, ar.name, aw.artwork_id, aw.title
    from artists ar
    left join artworks aw on ar.artist_id = aw.artist_id;
end
//






CREATE PROCEDURE upcoming_exhibition_by_date(in p_date date)
BEGIN
    select * from exhibitions
    where start_date >= p_date
    order by start_date asc;
end
//






CREATE PROCEDURE add_artwork_to_exhibition(
    in p_exhibition_id int,
    in p_artwork_id int,
    in p_position varchar(100)
)
BEGIN
    INSERT INTO exhibition_artworks (exhibition_id, artwork_id, display_position)
    values (p_exhibition_id, p_artwork_id, p_position);
end
//






CREATE PROCEDURE place_bid(
    in p_auction_id int,
    in p_member_id int,
    in p_bid_amount decimal(12,2)
)
BEGIN
    declare highest_bid decimal(12,2);
    declare start_price decimal(12,2);
    declare a_start datetime;
    declare a_end datetime;

    declare exit handler for sqlexception 
    BEGIN
        rollback;
        signal sqlstate '45000' set message_text = 'Bid transaction failed. Rolling back.';
    end;
    start transaction;

    select start_price, start_time, end_time
    into start_price, a_start, a_end
    from auctions
    where auction_id = p_auction_id for update;

    if now() < a_start or now() > a_end then
        rollback;
        signal sqlstate '45000' set message_text = 'Bidding is closed.';
    end if;


    select max(bid_amount) into highest_bid from auction_bids where auction_id = p_auction_id;

    if highest_bid is null then
        set highest_bid = start_price;
    end if;

    if p_bid_amount <= highest_bid then
        rollback;
        signal sqlstate '45000' set message_text = 'Bid must be higher than current highest bid.';
    end if;

    INSERT INTO auction_bids (auction_id, member_id, bid_amount)
    values (p_auction_id, p_member_id, p_bid_amount);

    COMMIT;
end
//








CREATE PROCEDURE add_new_auction(
    in p_artwork_id int,
    in p_start_price decimal(12,2),
    in p_start_time datetime,
    in p_end_time datetime
)
BEGIN
    INSERT INTO auctions (artwork_id, start_price, start_time, end_time)
    values (p_artwork_id, p_start_price, p_start_time, p_end_time);
end
//







CREATE PROCEDURE auction_summary(in p_auction_id int)
BEGIN
    select a.auction_id, aw.title, max(b.bid_amount) as highest_bid, m.full_name as highest_bidder
    from auctions a
    join artworks aw on a.artwork_id = aw.artwork_id
    left join auction_bids b on a.auction_id = b.auction_id
    left join members m on b.member_id = m.member_id
    where a.auction_id = p_auction_id
    group by a.auction_id, aw.title, m.full_name;
end
//









CREATE PROCEDURE add_new_exhibition(
    in p_name varchar(255),
    in p_start date,
    in p_end date,
    in p_location varchar(255),
    in p_desc text
)
BEGIN
    INSERT INTO exhibitions (name, start_date, end_date, location, description)
    values (p_name, p_start, p_end, p_location, p_desc);
end
//




CREATE PROCEDURE make_sale(
    in p_artwork_id int,
    in p_member_id int,
    in p_quantity int,
    in p_sale_price decimal(12,2),
    in p_handled_by int
)
BEGIN
    declare available_stock int default 0;
    declare exit handler for sqlexception 
    BEGIN

        rollback;
        signal sqlstate '45000' set message_text = 'Transaction failed. Rolling back.';
    end;

    start transaction;


    select stock into available_stock from artworks where artwork_id = p_artwork_id for update;
    if available_stock < p_quantity then
        rollback;
        signal sqlstate '45000' set message_text = 'Not enough stock for this sale.';
    end if;


    INSERT INTO sales (artwork_id, member_id, quantity, sale_price, handled_by)
    values (p_artwork_id, p_member_id, p_quantity, p_sale_price, p_handled_by);

 
    update artworks
    set stock = stock - p_quantity,
        is_available = case when stock - p_quantity <= 0 then 0 else 1 end
    where artwork_id = p_artwork_id;

    COMMIT;
end //

DELIMITER ;



CALL add_artist(
    'Diego Rivera',
    'Mexican muralist known for large frescoes.',
    'Mexico'
);


