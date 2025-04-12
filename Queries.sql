-- Social Media Analytics
USE social_media;
-- ----------------------------------------------------------
-- Query 1
-- Selecting users on basis of number of posts (with atleast 1 post) 

SELECT  users.user_id,
		users.username, 
		Count(post.user_id) AS total_posts
FROM users
INNER JOIN post
ON users.user_id=post.user_id
GROUP BY users.user_id, users.username
ORDER BY total_posts DESC;

-- ----------------------------------------------------------
-- Query 2
-- Selecting posts on basis of number of likes 

SELECT users.user_id,
	   users.username,
       post.caption, 
	   COUNT(post_likes.user_id) AS total_likes
FROM users
LEFT JOIN post
ON users.user_id=post.user_id
LEFT JOIN post_likes
ON post.post_id=post_likes.post_id
GROUP BY users.user_id,users.username, post.caption
ORDER BY total_likes DESC;

-- ----------------------------------------------------------
-- Query 3
-- Users without a single post (Inactive users check) 

SELECT*
FROM users
LEFT JOIN post
ON users.user_id=post.user_id
WHERE post.user_id IS NULL;

-- ----------------------------------------------------------
-- Query 4
-- Users with most combined likes on all posts 

SELECT users.user_id,
	   username,
	   COUNT(DISTINCT post.post_id) AS total_posts,
	   COUNT(post_likes.user_id) AS total_likes,
	   COUNT(post_likes.user_id)/COUNT(DISTINCT post.post_id) AS avg_likes_per_post
FROM users
LEFT JOIN post
ON users.user_id=post.user_id
LEFT JOIN post_likes
ON post.post_id=post_likes.post_id
GROUP BY users.user_id,username
ORDER BY total_likes DESC;

-- ----------------------------------------------------------
-- Query 5
-- Average post by users

SELECT ROUND(COUNT(post_id)/(SELECT(COUNT(user_id))
					   FROM users),1) AS avg_posts_per_user		  	
FROM post;

-- ----------------------------------------------------------
-- Query 6
-- Most used photos in posts 

SELECT post.photo_id, 
	   Photos.photo_url,
	   COUNT(post.photo_id) total_usage
FROM post
LEFT JOIN photos
ON post.photo_id=photos.photo_id
GROUP BY post.photo_id,Photos.photo_url
ORDER BY total_usage DESC;

-- ----------------------------------------------------------
-- Query 7
-- Most used videos in posts

SELECT post.video_id, 
	   videos.video_url,
	   COUNT(videos.video_id) total_usage
FROM post
LEFT JOIN videos
ON post.video_id=videos.video_id
GROUP BY post.video_id,videos.video_url
ORDER BY total_usage DESC;

-- ----------------------------------------------------------
-- Query 8
-- Selecting users on basis of number of logins (with atleast 1 login)

SELECT login.user_id,username, 
	   COUNT(login_id) AS total_logins
FROM users
INNER JOIN login
ON users.user_id=login.user_id
GROUP BY login.user_id,username
ORDER BY total_logins DESC;

-- ----------------------------------------------------------
-- Query 9
-- Users with No logins (Inactive users check)

SELECT user_id, username
FROM users
WHERE user_id NOT IN (SELECT user_id
					  FROM login)
ORDER BY user_id ASC;

-- ----------------------------------------------------------
-- Query 10
-- Selecting posts on basis of total bookmarks (with atleast 1 bookmark)

SELECT bookmarks.post_id,
	   caption,
	   COUNT(bookmarks.post_id) AS total_bookmarks
FROM post
INNER JOIN bookmarks
ON bookmarks.post_id=post.post_id
GROUP BY post_id, caption
ORDER BY total_bookmarks DESC;

-- ----------------------------------------------------------
-- Query 11
-- posts with 0 bookmarks

SELECT post_id, caption
FROM post
WHERE post_id NOT IN (SELECT post_id
					  FROM bookmarks);
                      
-- ----------------------------------------------------------
-- Query 12
-- Top 5 longest captions in post

SELECT post_id, caption,
	   CHAR_LENGTH(caption) AS total_characters
FROM post
ORDER BY total_characters DESC
LIMIT 5;

-- ----------------------------------------------------------
-- Query 13
-- Selecting posts on basis of number comments

SELECT users.user_id,
	   username,
	   caption, 
       Count(Comments.post_id) AS total_comments
FROM Post
LEFT JOIN comments
ON post.post_id=comments.post_id
INNER JOIN users
ON users.user_id=post.user_id
GROUP BY  users.user_id, username, caption
ORDER BY total_comments DESC;

-- ----------------------------------------------------------
-- Query 14
-- Users who recievd most cummulative comments on posts

SELECT users.user_id,
	   username,
       COUNT(Comments.post_id) AS total_comments_recieved,
       COUNT(DISTINCT post.post_id) AS total_posts,
       COUNT(Comments.post_id)/COUNT(DISTINCT post.post_id) AS avg_comments
FROM Post
LEFT JOIN comments
ON post.post_id=comments.post_id
INNER JOIN users
ON users.user_id=post.user_id
GROUP BY users.user_id, username
ORDER BY total_comments_recieved DESC;

-- ----------------------------------------------------------
-- Query 15
-- Selecting users by number of comments (Including those with 0 comments)

SELECT users.user_id,
	   username,
       COUNT(comments.user_id) AS Total_comments
FROM users
LEFT JOIN comments
ON users.user_id=comments.user_id
GROUP BY users.user_id, username
ORDER BY total_comments;

-- ----------------------------------------------------------
-- Query 16
-- Average comment/per user

SELECT ROUND(COUNT(comment_id)/(SELECT COUNT(user_id)	
						  FROM users),2) AS avg_comments
FROM comments;
-- ----------------------------------------------------------
-- Query 17
-- Longest comment by characters

SELECT ROUND(COUNT(comment_id)/(SELECT COUNT(user_id)	
						  FROM users),2) AS avg_comments
FROM comments;

-- ----------------------------------------------------------
-- Query 18
-- Selecting comments on basis of number of comment_likes

SELECT users.user_id,
	   username,
	   comment_text,
       COUNT(comment_likes.comment_id) AS total_comment_likes
FROM comments
LEFT JOIN users
ON users.user_id=comments.user_id
LEFT JOIN comment_likes
ON comments.comment_id=comment_likes.comment_id
GROUP BY users.user_id, username,comment_text
ORDER BY total_comment_likes DESC;

-- ----------------------------------------------------------
-- Query 19
-- Users who recieved most cummulative likes on their comments

SELECT users.user_id,
	   username,
       COUNT(comment_likes.comment_id) AS total_comment_likes
FROM comments
LEFT JOIN users
ON users.user_id=comments.user_id
LEFT JOIN comment_likes
ON comments.comment_id=comment_likes.comment_id
GROUP BY users.user_id,username
ORDER BY total_comment_likes DESC;

-- ----------------------------------------------------------
-- Query 20
-- users who liked most number of comments

SELECT users.user_id,
	   username,
	   COUNT(comment_likes.comment_id) AS number_of_comments_liked
FROM users
INNER JOIN comment_likes
ON users.user_id=comment_likes.user_id
GROUP BY users.user_id,username
ORDER BY number_of_comments_liked DESC;

-- ----------------------------------------------------------
-- Query 21
-- Average likes per comment

SELECT ROUND(COUNT(user_id)/(SELECT COUNT(comment_id)
					   FROM comments),2) AS Avg_likes_per_comment
FROM comment_likes;

-- ----------------------------------------------------------
-- Query 22
-- Selecting hashtags on basis of usage

SELECT hashtag_name,
	   COUNT(post_tags.post_id) AS Usage_of_hashtag
FROM hashtags
INNER JOIN post_tags
ON hashtags.hashtag_id=post_tags.hashtag_id
GROUP BY hashtag_name
ORDER BY Usage_of_hashtag DESC;

-- ----------------------------------------------------------
-- Query 23
-- Most followed hashtag

SELECT  hashtag_name,
		COUNT(hashtag_follow.user_id) AS followers
FROM hashtags
LEFT JOIN hashtag_follow
ON hashtags.hashtag_id=hashtag_follow.hashtag_id
GROUP BY hashtag_name
ORDER BY followers DESC;

-- ----------------------------------------------------------
-- Query 24
-- Selecting users on basis of followers

SELECT  user_id,
		username,
		COUNT(followee_id) AS total_followers
FROM users
LEFT JOIN follows
ON user_id=follower_id
WHERE follower_id != followee_id
GROUP BY user_id, username
ORDER BY total_followers DESC;

-- ----------------------------------------------------------
-- Query 25
-- Selecting accounts on basis of how many other accounts they follow

SELECT  user_id,
		username,
		COUNT(follower_id) AS accounts_followed
FROM users
LEFT JOIN follows
ON users.user_id=followee_id
WHERE  follower_id != followee_id
GROUP BY user_id, username
ORDER BY accounts_followed DESC;

-- ----------------------------------------------------------
-- Query 26
-- Selecting accounts who have followed themselves (Glitch)

SELECT  user_id,
		username
FROM users
INNER JOIN follows
ON users.user_id=followee_id
WHERE  follower_id = followee_id
ORDER BY user_id ASC;

-- ----------------------------------------------------------
-- Query 27
-- Selecting users on basis of posts liked

SELECT users.user_id,
	   username,
       COUNT(post_id) AS posts_liked
FROM users
INNER JOIN post_likes
ON users.user_id=post_likes.user_id
GROUP BY users.user_id, username
ORDER BY posts_liked DESC;

--  DONE ----------------------------------------------


