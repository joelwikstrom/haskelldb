-----------------------------------------------------------
-- |
-- Module      :  HaskellDB
-- Copyright   :  Daan Leijen (c) 1999, daan@cs.uu.nl
--                HWT Group (c) 2003, haskelldb-users@lists.sourceforge.net
-- License     :  BSD-style
-- 
-- Maintainer  :  haskelldb-users@lists.sourceforge.net
-- Stability   :  experimental
-- Portability :  non-portable
--
--
-- $Revision: 1.11 $
-----------------------------------------------------------
module Database.HaskellDB.HSQL.MySQL (
		   MySQLOptions(..),
		   mysqlConnect,
		   driver
		  ) where

import Database.HaskellDB.Database
import Database.HaskellDB.HSQL.Common
import Database.HaskellDB.DriverAPI
import qualified Database.HSQL.MySQL as MySQL (connect) 

data MySQLOptions = MySQLOptions { 
				  server :: String, -- ^ server name
				  db :: String,     -- ^ database name
				  uid :: String,    -- ^ user id
				  pwd :: String     -- ^ password
                  		 }

mysqlConnect :: MySQLOptions -> (Database -> IO a) -> IO a
mysqlConnect = 
    hsqlConnect (\opts -> MySQL.connect 
		            (server opts) (db opts) (uid opts) (pwd opts))

mysqlConnectOpts :: [(String,String)] -> (Database -> IO a) -> IO a
mysqlConnectOpts opts f = 
    do
    [a,b,c,d] <- getOptions ["server","db","uid","pwd"] opts
    mysqlConnect (MySQLOptions {server = a,
				db = b,
				uid = c,
				pwd = d}) f

driver = defaultdriver {connect = mysqlConnectOpts}
