AIRSQLite
=========

AS for SQLite

First:


                var file:File = new File(File.applicationStorageDirectory.nativePath+"/db/demo.sqlite");

                if(!file.exists)
                {
                    var dbFile:File = new File(File.applicationDirectory.nativePath+"/db/torrent.sqlite");
                    if(dbFile.exists)
                    {
                        dbFile.copyTo(file);
                    }
                    else
                    {
                        Alert.show("Data file missing", "Message");
                    }
                }
                
                
                if(!AIRSQLite.setLocalSQLServer(file.nativePath))
                {
                    Alert.show("Can not link to database", "Message");
                }
