# Design Document

By sinskiy

Video overview: https://youtu.be/hmRjm2BHwdA?feature=shared

## Scope

This app is suppossed to be something between a website called Soundcloud, and a public cloud music storage. You could play music online, but there are no playlists to keep it simple. Everyone can upload songs and albums

## Functional Requirements

In this app, a user can create an account using an email with magic link, so there are no passwords. A user can specify a nickname, add a text bio, upload multiple songs. An uploaded song should be stored as a file on a server's storage. The name of the file should be automatically renamed to the song id using a programming language. A user can follow multiple users, like multiple songs, create albums that contain several songs, add comments to songs and reply to comments

## Representation

### Entities

Almost every table in my database has an id column. Of course, they are all integers and primary keys.
Users table has columns called email, username, nickname, and bio. It's kinda obvious why all of them have type TEXT. Email and username can't be null, because they're used to identify user - the former privately, and the latter publically. But popular usernames would be taken soon, so my table has nicknames. They're not unique unlike usernames - there could be thousands joes.
There is a followers table, and primary key here includes two columns. You can't follow someone twice, so you can't have two repeating pairs. It's almost the same for authors, producers, and likes tables.
There is a table for songs, and it has album_id, title, date and length columns. It's quite obvious why i chose these types - we use numeric for a date in sqlite, title is text, and length is integer.
The next table is albums. It is the shortest table in my database, and it repeats columns from songs, but not every of them.
The last table is comments. We have parent_comment_id. It is usually null, unless your comment is a reply. The table has comment_text row, that has a check constraint for length. A comment can't be longer than 300 characters

### Relationships

![diagram](./diagram.png)

## Optimizations

My database has quite a lot of views, but almost  all of them are the same. They have one or two joins so that i can view data nicely. For example, using liked view you can see who liked which song without looking at non-user friendly ids. However, there are two views that are different: count_likes and count_followers. The former view returns how many likes each song has, the latter returns how many followers each user has. My database has two indexes: the first is for songs title, and the second is for users nickname

## Limitations

Speaking about limitations, my database can't represent playlists. Also it doesn't track how many listening each song has, so you can determine whether song is popular or not only by looking at the amount of likes
