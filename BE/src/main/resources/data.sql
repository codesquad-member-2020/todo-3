INSERT INTO col (col_name, category_name, deleted)
VALUES ("To Do", "todo", false);
INSERT INTO col (col_name, category_name, deleted)
VALUES ("In Progress", "doing", false);
INSERT INTO col (col_name, category_name, deleted)
VALUES ("Done", "done", false);

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
values ("alex", "alexID", "alexPW");
INSERT INTO user(user_name, user_id, user_password)
values ("mocha", "mochaID", "mochaPW");
INSERT INTO user(user_name, user_id, user_password)
values ("ari", "ariID", "ariPW");
INSERT INTO user(user_name, user_id, user_password)
values ("lena", "lenaID", "lenaPW");
INSERT INTO user(user_name, user_id, user_password)
values ("unknown", "unknownID", "unknownPW");
