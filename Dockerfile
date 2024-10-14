FROM debian:latest

# Install SQLite and necessary packages
RUN apt-get update && \
    apt-get install -y sqlite3 libsqlite3-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Set the working directory
WORKDIR /data/db

# Create a default SQLite database file
RUN sqlite3 blog.db "CREATE TABLE IF NOT EXISTS blog_post (id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT NOT NULL, content TEXT NOT NULL);"

# Start SQLite shell
CMD ["sqlite3", "blog.db"]
