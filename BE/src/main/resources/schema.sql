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
    row          int,
    title        varchar(100),
    contents     varchar(500) not null,
    writer       varchar(50)  not null,
    deleted      boolean,
    written_time datetime     not null,
    col          int references col (id),
    col_key      int
);

INSERT INTO col (col_name, deleted)
VALUES ("To do", false);
INSERT INTO col (col_name, deleted)
VALUES ("In Progress", false);
INSERT INTO col (col_name, deleted)
VALUES ("Done", false);

INSERT INTO card (row, title, contents, writer, deleted, written_time, col, col_key) VALUES ( 1,"title1","contents1","todo3people",false,now(),1,0 );
INSERT INTO card (row, title, contents, writer, deleted, written_time, col, col_key) VALUES ( 2,"title2","contents2","todo3people",false,now(),1,1 );
INSERT INTO card (row, title, contents, writer, deleted, written_time, col, col_key) VALUES ( 3,"title3","contents3","todo3people",false,now(),1,2 );
INSERT INTO card (row, title, contents, writer, deleted, written_time, col, col_key) VALUES ( 4,"title4","contents4","todo3people",false,now(),1,3 );
INSERT INTO card (row, title, contents, writer, deleted, written_time, col, col_key) VALUES ( 5,"title5","contents5","todo3people",false,now(),1,4 );
INSERT INTO card (row, title, contents, writer, deleted, written_time, col, col_key) VALUES ( 6,"title6","contents6","todo3people",false,now(),1,5 );
INSERT INTO card (row, title, contents, writer, deleted, written_time, col, col_key) VALUES ( 7,"title7","contents7","todo3people",false,now(),1,6 );

INSERT INTO card (row, title, contents, writer, deleted, written_time, col, col_key) VALUES ( 1,"title1","contents1","todo3people",false,now(),2,0 );
INSERT INTO card (row, title, contents, writer, deleted, written_time, col, col_key) VALUES ( 2,"title2","contents2","todo3people",false,now(),2,1 );
INSERT INTO card (row, title, contents, writer, deleted, written_time, col, col_key) VALUES ( 3,"title3","contents3","todo3people",false,now(),2,2 );
INSERT INTO card (row, title, contents, writer, deleted, written_time, col, col_key) VALUES ( 4,"title4","contents4","todo3people",false,now(),2,3 );
INSERT INTO card (row, title, contents, writer, deleted, written_time, col, col_key) VALUES ( 5,"title5","contents5","todo3people",false,now(),2,4 );
INSERT INTO card (row, title, contents, writer, deleted, written_time, col, col_key) VALUES ( 6,"title6","contents6","todo3people",false,now(),2,5 );
INSERT INTO card (row, title, contents, writer, deleted, written_time, col, col_key) VALUES ( 7,"title7","contents7","todo3people",false,now(),2,6 );

INSERT INTO card (row, title, contents, writer, deleted, written_time, col, col_key) VALUES ( 1,"title1","contents1","todo3people",false,now(),3,0 );
INSERT INTO card (row, title, contents, writer, deleted, written_time, col, col_key) VALUES ( 2,"title2","contents2","todo3people",false,now(),3,1 );
INSERT INTO card (row, title, contents, writer, deleted, written_time, col, col_key) VALUES ( 3,"title3","contents3","todo3people",false,now(),3,2 );
INSERT INTO card (row, title, contents, writer, deleted, written_time, col, col_key) VALUES ( 4,"title4","contents4","todo3people",false,now(),3,3 );
INSERT INTO card (row, title, contents, writer, deleted, written_time, col, col_key) VALUES ( 5,"title5","contents5","todo3people",false,now(),3,4 );
INSERT INTO card (row, title, contents, writer, deleted, written_time, col, col_key) VALUES ( 6,"title6","contents6","todo3people",false,now(),3,5 );
INSERT INTO card (row, title, contents, writer, deleted, written_time, col, col_key) VALUES ( 7,"title7","contents7","todo3people",false,now(),3,6 );

