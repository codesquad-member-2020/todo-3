drop table if exists col;
drop table if exists card;

CREATE TABLE col
(
    id       int primary key auto_increment,
    col_name VARCHAR(100) not null,
    deleted  boolean
);



CREATE TABLE card
(
    id           int primary key auto_increment,
    title        varchar(100),
    contents     varchar(500) not null,
    writer       varchar(50)  not null,
    deleted      boolean,
    written_time datetime     not null,
    col          int references col (id),
    col_key      int
);

INSERT INTO col (col_name, deleted) VALUES ("To do", false);
INSERT INTO col (col_name, deleted) VALUES ("In Progress", false);
INSERT INTO col (col_name, deleted) VALUES ("Done", false);
