drop table if exists col;
drop table if exists card;
drop table if exists user;

CREATE TABLE col
(
    id       int primary key auto_increment,
    col_name VARCHAR(100) not null,
    deleted  boolean
);



CREATE TABLE card
(
    id           int primary key auto_increment,
    row          int,
    title        varchar(100),
    contents     varchar(500) not null,
    writer       varchar(50)  not null,
    deleted      boolean,
    written_time datetime     not null,
    col          int references col (id),
    col_key      int
);

CREATE  TABLE user
(
    id int primary key auto_increment,
    user_name varchar(50),
    user_id varchar(50),
    user_password varchar(50)
)


