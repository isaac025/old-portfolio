module Db.Blog where

import Blog
import Database.PostgreSQL.Simple.SqlQQ (sql)
import Db.Functions
import Error

getBlogByTitle :: (WithDb env m, WithError m) => Title -> m [Blog]
getBlogByTitle t = query [sql| SELECT * FROM blogs WHERE title like ? |] t

getBlogs :: (WithDb env m, WithError m) => m [Blog]
getBlogs = queryRaw [sql| SELECT * FROM blogs |]
