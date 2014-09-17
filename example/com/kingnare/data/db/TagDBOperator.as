package com.kingnare.data.db
{
    import com.kingnare.sql.AIRSQLite;
    import com.kingnare.sql.SqlParameter;

    public class TagDBOperator
    {
        /**
         * 添加一条记录
         * @param status
         * @return 
         * 
         */        
        public static function addTag(item:Object):Boolean
        {
            if(!item)
                return false;
            
            var parameters:SqlParameter = new SqlParameter();
            var sql:String = "INSERT INTO tags " + 
                "(tagName, txtClr, bgClr) " + 
                "VALUES " + 
                "(@tagName, @txtClr, @bgClr)";
            
            parameters["@tagName"] = item.tagName;
            parameters["@txtClr"] = item.txtClr;
            parameters["@bgClr"] = item.bgClr;
            
            return AIRSQLite.executeSql(AIRSQLite.localSQLServer, sql, parameters)>0;
        }
        
        public static function removeTag(id:uint):Boolean
        {
            var sql:String = "DELETE FROM tags WHERE id=@id";
            var parameters:SqlParameter = new SqlParameter();
            parameters["@id"] = id;
            return AIRSQLite.executeSql(AIRSQLite.localSQLServer, sql, parameters)>0;
        }
        
        public static function updateTag(item:Object):Boolean
        { 
            if(!item)
                return false;
            
            var parameters:SqlParameter = new SqlParameter();
            var sql:String = "UPDATE tags SET " + 
                "tagName=@tagName, txtClr=@txtClr, bgClr=@bgClr " + 
                "WHERE id=@id";
            
            parameters["@tagName"] = item.tagName;
            parameters["@txtClr"] = item.txtClr;
            parameters["@bgClr"] = item.bgClr;
            parameters["@id"] = item.tagID;
            
            return AIRSQLite.executeSql(AIRSQLite.localSQLServer, sql, parameters)>0;
        }
        
        public static function isExist(item:Object):Boolean
        {
            var sql:String = "SELECT id FROM tags WHERE tagName=@tagName";
            
            var parameters:SqlParameter = new SqlParameter();
            parameters["@tagName"] = item.tagName;
            
            return AIRSQLite.exists(AIRSQLite.localSQLServer, sql, parameters);
        }
        
        public static function getTagIDByName(name:String):uint
        {
            var sql:String = "SELECT id FROM tags WHERE tagName=@tagName";
            
            var parameters:SqlParameter = new SqlParameter();
            parameters["@tagName"] = name;
            
            var re:Array = AIRSQLite.query(AIRSQLite.localSQLServer, sql, parameters);
            if(re.length>0)
            {
                return uint(re[0].id);
            }
            else
            {
                return NaN;
            }
        }
        
        /**
         * 读取记录列表
         * @param page 页数
         * @return 
         * 
         */        
        public static function getList():Array
        {
            var parameters:SqlParameter = new SqlParameter();
            var sql:String = "SELECT * FROM tags ORDER BY id DESC";
            
            var result:Array = AIRSQLite.query(AIRSQLite.localSQLServer, sql, parameters);
            /*if(result)
            {
                for (var i:int = 0; i < result.length; i++)
                {
                    var output:String = "";
                    var row:Object = result[i];
                    for (var prop:String in row)
                    {
                        output += prop+":"+row[prop]+", ";
                    }
                    //trace(output);
                }
            }*/
            return result; 
        }
        
        
        /**
         * 清空数据
         * @return 
         * 
         */        
        public static function clear():Boolean
        {
            var sql:String = "DELETE FROM tags";
            var parameters:SqlParameter = new SqlParameter();
            return AIRSQLite.executeSql(AIRSQLite.localSQLServer, sql, parameters)>0;
        }
    }
}