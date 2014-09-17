package com.kingnare.data.db
{
    import com.kingnare.sql.AIRSQLite;
    import com.kingnare.sql.SqlParameter;

    /**
     *  
     * @author king
     * 
     */    
    public class TagListDBOperator
    {
        /**
         * 读取记录列表
         * @param page 页数
         * @return 
         * 
         */        
        public static function getList(tagID:uint, page:int=0):Array
        {
            var sql:String = "SELECT * FROM taglist WHERE tagId=@tagID ORDER BY id DESC";
            
            var parameters:SqlParameter = new SqlParameter();
            parameters["@tagID"] = tagID;
            
            var result:Array = AIRSQLite.query(AIRSQLite.localSQLServer, sql, parameters);
            if(result && result.length>0)
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
            return result; 
        }
        
        /**
         * 添加一条记录
         * @param status
         * @return 
         * 
         */        
        public static function addItem(item:Object):Boolean
        {
            if(!item)
                return false;
            
            var parameters:SqlParameter = new SqlParameter();
            var sql:String = "INSERT INTO taglist " + 
                "(path, name, size, taskname, tagId) " + 
                "VALUES " + 
                "(@path, @name, @size, @taskname, @tagId)";
            
            parameters["@path"] = item.filepath;
            parameters["@name"] = item.name;
            parameters["@size"] = item.size;
            parameters["@taskname"] = item.taskname;
            parameters["@tagId"] = item.tagID;
            
            return AIRSQLite.executeSql(AIRSQLite.localSQLServer, sql, parameters)>0;
        }
        
        
        public static function removeItem(id:uint):Boolean
        {
            var sql:String = "DELETE FROM taglist WHERE id=@id";
            var parameters:SqlParameter = new SqlParameter();
            parameters["@id"] = id;
            return AIRSQLite.executeSql(AIRSQLite.localSQLServer, sql, parameters)>0;
        }
        
        public static function isExist(item:Object):Boolean
        {
            var sql:String = "SELECT id FROM taglist WHERE path=@path AND name=@name AND size=@size";
            
            var parameters:SqlParameter = new SqlParameter();
            parameters["@path"] = item.filepath;
            parameters["@name"] = item.name;
            parameters["@size"] = item.size;
            
            return AIRSQLite.exists(AIRSQLite.localSQLServer, sql, parameters);
        }
        
        /**
         * 分页
         * @param pageIndex
         * @param pageSize
         * @return 
         * 
         */        
        public static function pageList(tagID:uint, pageIndex:uint, pageSize:uint):Object
        {
            var wheresql:String = "WHERE tagId=@tagID ORDER BY id DESC";
            var parameters:SqlParameter = new SqlParameter();
            parameters["@tagID"] = tagID;
            var total:uint = AIRSQLite.getRecordNum(AIRSQLite.localSQLServer, "taglist", "id", parameters, wheresql);
            //
            var sql:String = "SELECT * FROM taglist WHERE tagId=@tagID ORDER BY id DESC";
            var result:Array = AIRSQLite.pageList(AIRSQLite.localSQLServer, sql, parameters, pageSize, pageIndex);
            var totalPage:uint = total%pageSize == 0?Math.floor(total/pageSize):Math.floor(total/pageSize)+1;
            
            /*for (var i:int = 0; i < result.length; i++)
            {
                var output:String = "";
                var row:Object = result[i];
                for (var prop:String in row)
                {
                    output += prop+":"+row[prop]+", ";
                }
                trace(output);
            }*/
            
            trace("总记录数:"+total);
            trace("总页数:"+totalPage)
            trace("每页记录数:"+pageSize);
            trace("当前页数:"+pageIndex);
            return {total:total, pageSize:pageSize, pageIndex:pageIndex, totalPage:totalPage, data:result};
        }
        
        /**
         * 按ID清空数据
         * @return 
         * 
         */        
        public static function clearByTagID(id:uint):Boolean
        {
            var sql:String = "DELETE FROM taglist where tagId=@tagId";
            var parameters:SqlParameter = new SqlParameter();
            parameters["@tagId"] = id;
            return AIRSQLite.executeSql(AIRSQLite.localSQLServer, sql, parameters)>0;
        }
        
        /**
         * 清空数据
         * @return 
         * 
         */        
        public static function clear():Boolean
        {
            var sql:String = "DELETE FROM taglist";
            var parameters:SqlParameter = new SqlParameter();
            return AIRSQLite.executeSql(AIRSQLite.localSQLServer, sql, parameters)>0;
        }
    }
}