{-# LANGUAGE OverloadedStrings #-}
module Lib where

import Foreign.C (CString, newCString)
import Network.HTTP (simpleHTTP, getRequest, getResponseBody)
import Database.SQLite3 (close, open)

-- | export haskell function @chello@ as @hello@.
-- foreign export ccall "hello" chello :: IO CString
foreign export ccall "hello" httpRequest :: IO CString

httpRequest :: IO CString
httpRequest = do
  -- db <- open "file:data.db"
  -- close db
  res <- simpleHTTP (getRequest "http://www.google.com/") >>= fmap (take 100) . getResponseBody
  newCString res

-- | Tiny wrapper to return a CString
chello = newCString hello

-- | Pristine haskell function.
hello = "Hello from Haskell"
