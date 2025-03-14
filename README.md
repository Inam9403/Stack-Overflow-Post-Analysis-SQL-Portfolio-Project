# Stack-Overflow-Post-Analysis-SQL-Portfolio-Project

## 📌 Project Overview

This project analyzes Stack Overflow post data to gain insights into user interactions, content evolution, and platform activity while refining SQL skills.

## 📊 Dataset

The dataset is sourced from Kaggle and consists of multiple tables tracking posts, comments, votes, user badges, and more.

## 🎯 Objectives

Understand user activity trends through SQL queries.

Analyze relationships between posts, votes, and badges.

Implement advanced SQL techniques including joins, subqueries, CTEs, and window functions.

## 🗂️ Dataset Tables & Key Fields

badges: User achievements (id, user_id, name, date)

comments: User comments on posts (id, post_id, user_id, creation_date, text)

post_history: Edits and changes to posts (id, post_history_type_id, post_id, user_id, text, creation_date)

post_links: Links between related posts (id, post_id, related_post_id, link_type_id)

posts_answers: Questions & answers (id, post_type_id, creation_date, score, view_count, owner_user_id)

tags: Tags assigned to posts (id, tag_name)

users: User details (id, display_name, reputation, creation_date)

votes: User voting activity (id, post_id, vote_type_id, creation_date)

posts: Main post data (id, title, post_type_id, creation_date, score, view_count, owner_user_id)

## 🔍 SQL Concepts Covered

### 🔹 Basic Queries

Exploring data using SELECT, WHERE, ORDER BY

Aggregations (COUNT, AVG, SUM)

### 🔹 Joins & Relationships

INNER JOIN, LEFT JOIN, RIGHT JOIN

Multi-table joins for deeper insights

### 🔹 Subqueries

Finding top users, highest-scoring posts

Correlated subqueries for linked posts

### 🔹 CTEs & Window Functions

Recursive queries for post-link hierarchy

Ranking posts based on yearly scores

Running totals of earned badges

## 📌 Key Insights

Identified top contributors based on comments, edits, and votes.

Analyzed the most commonly earned badges and top badge earners.

Found the tags linked to the highest-scoring posts.

Examined the frequency and significance of related post links.
