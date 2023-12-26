-- user opens the home page and sees songs and artists to check out
SELECT username, title FROM authored
ORDER BY RANDOM() -- in real world i would generate a random number (x) with a programming language
--and use something like LIMIT x, 10
LIMIT 10;
SELECT username FROM users
WHERE id IN (
    SELECT DISTINCT user_id FROM authors
)
ORDER BY RANDOM()
LIMIT 10;
-- user creates an account
INSERT INTO users (email, username) VALUES ('mplf5yk1@duck.com', 'Sinskiy');
-- user edits profile
UPDATE users
SET email = 'reu6aked@duck.com', nickname = 'Sinskiy', bio = 'i''m a newbie'
WHERE id = 2; -- the first id is for deleted users
-- user uploads a song
-- length should be computed using file metadata, but i would need a programming language like go, rust, python, js etc. for that
BEGIN TRANSACTION;
INSERT INTO songs (title, length_seconds) VALUES ('my first song', 120);
INSERT INTO authors (user_id, song_id) VALUES (2, 1);
INSERT INTO producers (user_id, song_id) VALUES (2, 1);
COMMIT;
-- user adds a comment to his song
INSERT INTO comments (user_id, song_id, comment_text) VALUES (2, 1, 'hope you enjoy it!');
-- another user creates an account
INSERT INTO users (email, username) VALUES ('hwqk5k1@duck.com', 'kilwinta');
-- new user checks the song likes count
SELECT title, likes FROM count_likes
WHERE song_id = 1;
-- new user likes the song
INSERT INTO likes (user_id, song_id) VALUES (3, 1);
-- they subscribe to each other
INSERT INTO followers VALUES (3, 2);
INSERT INTO followers VALUES (2, 3);
-- the first user checks his followers
SELECT username, followers FROM count_followers
WHERE id = 2;
-- the first user edits song's title
UPDATE songs
SET title = 'My first song'
WHERE id = 1;
-- the first user uploads an album
BEGIN TRANSACTION;
INSERT INTO albums (title) VALUES ('my first album');
INSERT INTO songs (album_id, title, length_seconds) VALUES (1, 'my second song', 120), (1, 'my third song', 120), (1, 'my fourth song', 120), (1, 'my fifth song', 120);
INSERT INTO authors (user_id, song_id) VALUES (2, 2), (2, 3), (2, 4), (2, 5), (3, 5);
INSERT INTO producers (user_id, song_id) VALUES (2, 2), (2, 3), (2, 4), (2, 5), (3, 2), (3, 3), (3, 4), (3, 5);
COMMIT;
-- the second user checks the new album
SELECT song FROM album_songs
WHERE album_id = 1;

-- someone searches a user
SELECT username, nickname FROM users
WHERE username LIKE '%Sinskiy%'
OR nickname LIKE '%Sinskiy%';

-- the second user deletes their account
DELETE FROM users
WHERE id = 3;
