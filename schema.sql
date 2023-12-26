-- This app is suppossed to be something between a website called Soundcloud, and a public cloud music storage. You could play music online, but there are no playlists to keep it simple. Everyone can upload songs song and albums

-- a user can create an account using a magic email link, so there are no passwords. A user can specify a nickname. It doesn't have to be unique unlike username. A user can add a text bio
CREATE TABLE users (
    id INTEGER PRIMARY KEY,
    email TEXT NOT NULL UNIQUE,
    username TEXT NOT NULL UNIQUE, -- serves as a public and user-frindly id
    nickname TEXT DEFAULT NULL, -- if it's null, app will use a username,
    bio TEXT DEFAULT NULL
);

CREATE INDEX nickname_index ON users (nickname);


-- this is needed to reference deleted users in authors and producers tables
INSERT INTO users (id, email, username) VALUES (1, 'example@example.com', 'DELETED');


CREATE TABLE followers (
    follower_id INTEGER,
    followee_id INTEGER,
    PRIMARY KEY (follower_id, followee_id),
    FOREIGN KEY(follower_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY(followee_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE VIEW followed AS
SELECT follower_id, users_followers.username AS follower, followee_id, users_followees.username AS followee FROM followers
INNER JOIN users users_followers ON users_followers.id = followers.follower_id
INNER JOIN users users_followees ON users_followees.id = followers.followee_id;

CREATE VIEW count_followers AS
SELECT followee_id AS id, username, COUNT(followee_id) AS followers FROM followers
INNER JOIN users ON users.id = followers.follower_id
GROUP BY followee_id;


-- songs table does not store author's id and producer's id, because it can have multiple authors and producers
CREATE TABLE songs (
    id INTEGER PRIMARY KEY,
    album_id INTEGER DEFAULT NULL,
    title TEXT NOT NULL,
    date NUMERIC NOT NULL DEFAULT CURRENT_DATE, -- publication date of a song
    length_seconds INTEGER NOT NULL CHECK(length_seconds > 0), -- length of a song should be obtained using a file metadata
    FOREIGN KEY(album_id) REFERENCES albums(id) ON DELETE SET NULL
);

CREATE INDEX title_index ON songs (title);


CREATE TABLE albums (
    id INTEGER PRIMARY KEY,
    title TEXT NOT NULL,
    date NUMERIC NOT NULL DEFAULT CURRENT_DATE -- publication date of an album
);

CREATE VIEW album_songs AS
SELECT songs.id, songs.title AS "song", album_id, albums.title AS "album" FROM songs
INNER JOIN albums ON albums.id = songs.album_id;


CREATE TABLE authors (
    user_id INTEGER DEFAULT 1,
    song_id INTEGER,
    PRIMARY KEY(user_id, song_id),
    FOREIGN KEY(user_id) REFERENCES users(id) ON DELETE SET DEFAULT,
    FOREIGN KEY(song_id) REFERENCES songs(id) ON DELETE CASCADE
);

CREATE VIEW authored AS
SELECT authors.user_id, username, authors.song_id, title FROM authors
INNER JOIN users ON authors.user_id = users.id
INNER JOIN songs ON authors.song_id = songs.id;


CREATE TABLE producers (
    user_id INTEGER DEFAULT 1,
    song_id INTEGER,
    PRIMARY KEY(user_id, song_id),
    FOREIGN KEY(user_id) REFERENCES users(id) ON DELETE SET DEFAULT,
    FOREIGN KEY(song_id) REFERENCES songs(id) ON DELETE CASCADE
);

CREATE VIEW produced AS
SELECT producers.user_id, username, producers.song_id, title FROM producers
INNER JOIN users ON users.id = producers.user_id
INNER JOIN songs ON songs.id = producers.song_id;


CREATE TABLE likes (
    user_id INTEGER,
    song_id INTEGER,
    PRIMARY KEY (user_id, song_id),
    FOREIGN KEY(user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY(song_id) REFERENCES songs(id) ON DELETE CASCADE
);

CREATE VIEW liked AS
SELECT username, title FROM likes
INNER JOIN users ON users.id = likes.user_id
INNER JOIN songs ON songs.id = likes.song_id;

CREATE VIEW count_likes AS
SELECT song_id, title, COUNT(title) AS likes FROM likes
INNER JOIN songs ON songs.id = likes.song_id
GROUP BY song_id;


CREATE TABLE comments (
    id INTEGER PRIMARY KEY,
    parent_comment_id INTEGER DEFAULT NULL,
    user_id INTEGER,
    song_id INTEGER,
    comment_text TEXT NOT NULL CHECK(LENGTH(comment_text) < 300),
    FOREIGN KEY(parent_comment_id) REFERENCES comments(id) ON DELETE CASCADE,
    FOREIGN KEY(user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY(song_id) REFERENCES songs(id) ON DELETE CASCADE
);

CREATE VIEW commented AS
SELECT user_id, username, song_id, title AS song_title, comments.id, comment_text FROM comments
INNER JOIN users ON users.id = comments.user_id
INNER JOIN songs ON songs.id = comments.song_id;
-- possible: download a song, create an account, upload a song with account, follow someone, like some song, comment some song, reply to some comment
-- limitations: no playlists, no songs by popularity or listenings
