package com.kingnare.data.db
{
    import com.kingnare.sql.AIRSQLite;
    import com.kingnare.sql.SqlParameter;

    public class HistoryDBOperator
    {
        /**
         * 添加一条记录
         * @param status
         * @return 
         * 
         */        
        public static function addItem(item:Object):Boolean
        {
            var bool:Boolean = false;
            
            if(!item)
                return false;
            
            var parameters:SqlParameter = new SqlParameter();
            var sql:String = "INSERT INTO history " + 
                "(filepath, name, size, taskname) " + 
                "VALUES " + 
                "(@filepath, @name, @size, @taskname)";
            
            parameters["@filepath"] = item.filepath;
            parameters["@name"] = item.name;
            parameters["@size"] = item.size;
            parameters["@taskname"] = item.taskname;
            
            if(AIRSQLite.executeSql(AIRSQLite.localSQLServer, sql, parameters)>0)
            {
                var re:Array = getList();
                if(re.length > Config.HistoryNum)
                {
                    removeItem(re[re.length-1].id);
                }
                
                bool = true;
            }
            
            return bool;
        }
        
        
        public static function removeItem(id:uint):Boolean
        {
            var sql:String = "DELETE FROM history WHERE id=@id";
            var parameters:SqlParameter = new SqlParameter();
            parameters["@id"] = id;
            return AIRSQLite.executeSql(AIRSQLite.localSQLServer, sql, parameters)>0;
        }
        
        public static function isExist(item:Object):Boolean
        {
            var sql:String = "SELECT id FROM history WHERE filepath=@filepath AND name=@name AND size=@size";
            
            var parameters:SqlParameter = new SqlParameter();
            parameters["@filepath"] = item.filepath;
            parameters["@name"] = item.name;
            parameters["@size"] = item.size;
            
            return AIRSQLite.exists(AIRSQLite.localSQLServer, sql, parameters);
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
            var sql:String = "SELECT * FROM history ORDER BY id DESC";
            
            var result:Array = AIRSQLite.query(AIRSQLite.localSQLServer, sql, parameters);
            if(result)
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
            }
            else
            {
                result = [];
            }
            return result; 
        }
        
        
        /**
         * 清空数据
         * @return 
         * 
         */        
        public static function clear():Boolean
        {
            var sql:String = "DELETE FROM history";
            var parameters:SqlParameter = new SqlParameter();
            return AIRSQLite.executeSql(AIRSQLite.localSQLServer, sql, parameters)>0;
        }
    }
}