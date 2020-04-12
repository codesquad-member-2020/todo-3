INSERT INTO col (col_name, deleted)
VALUES ("To do", false);
INSERT INTO col (col_name, deleted)
VALUES ("In Progress", false);
INSERT INTO col (col_name, deleted)
VALUES ("Done", false);

INSERT INTO card (row, title, contents, writer, deleted, written_time, col, col_key)
VALUES (1, "title1", "contents1", "todo3people", false, now(), 1, 0);
INSERT INTO card (row, title, contents, writer, deleted, written_time, col, col_key)
VALUES (2, "title2", "contents2", "todo3people", false, now(), 1, 1);
INSERT INTO card (row, title, contents, writer, deleted, written_time, col, col_key)
VALUES (3, "title3", "contents3", "todo3people", false, now(), 1, 2);

INSERT INTO card (row, title, contents, writer, deleted, written_time, col, col_key)
VALUES (1, "title1", "contents1", "todo3people", false, now(), 2, 0);
INSERT INTO card (row, title, contents, writer, deleted, written_time, col, col_key)
VALUES (2, "title2", "contents2", "todo3people", false, now(), 2, 1);
INSERT INTO card (row, title, contents, writer, deleted, written_time, col, col_key)
VALUES (3, "title3", "contents3", "todo3people", false, now(), 2, 2);

INSERT INTO card (row, title, contents, writer, deleted, written_time, col, col_key)
VALUES (1, "title1", "contents1", "todo3people", false, now(), 3, 0);
INSERT INTO card (row, title, contents, writer, deleted, written_time, col, col_key)
VALUES (2, "title2", "contents2", "todo3people", false, now(), 3, 1);
INSERT INTO card (row, title, contents, writer, deleted, written_time, col, col_key)
VALUES (3, "title3", "contents3", "todo3people", false, now(), 3, 2);

INSERT INTO user(user_name, user_id, user_password)
values ("alexName", "alexID", "alexPW");
INSERT INTO user(user_name, user_id, user_password)
values ("mochaName", "mochaID", "mochaPW");
INSERT INTO user(user_name, user_id, user_password)
values ("ariName", "ariID", "ariPW");
INSERT INTO user(user_name, user_id, user_password)
values ("lenaName", "lenaID", "lenaPW");
