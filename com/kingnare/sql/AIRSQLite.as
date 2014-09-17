package com.kingnare.sql
{
	import flash.data.SQLConnection;
	import flash.data.SQLMode;
	import flash.data.SQLResult;
	import flash.data.SQLStatement;
	import flash.errors.SQLError;
	import flash.filesystem.File;
	
	public class AIRSQLite
	{
		// 构建HASH表数据库连接字串类，实现存储多个数据库连接
		public static var localSQLServer:SQLConnection = new SQLConnection();
		
		public function AIRSQLite()
		{
		}
		
		// 连接数据库
		public static function setLocalSQLServer(dbURL:String):Boolean
		{
			try
			{
				var dbFile:File = File.applicationDirectory.resolvePath(dbURL);
				if(localSQLServer.connected)
				{
					return true;
				}
				localSQLServer.open(dbFile, SQLMode.UPDATE);
			}
			catch(error:Error)
			{
				return false;
			}
			return true;
		}
		
		// 执行SQL语句，返回影响的记录数
        public static function executeSql(conn:SQLConnection, sqlString:String, cmdParams:SqlParameter):int
        {
        	var result:SQLResult = querySQL(conn, sqlString, cmdParams);
            return result.rowsAffected;
        }
		
		// 执行查询语句，返回结果数组
		public static function query(conn:SQLConnection, sqlString:String, cmdParams:SqlParameter):Array
		{
			var result:SQLResult = querySQL(conn, sqlString, cmdParams);
			return result.data;
		}
		
		// 执行查询语句，返回结果
		public static function querySQL(conn:SQLConnection, sqlString:String, cmdParams:SqlParameter):SQLResult
		{
			var sqlstatement:SQLStatement = new SQLStatement();
			sqlstatement.sqlConnection = conn;
			sqlstatement.text = sqlString;
			try
			{
				if(cmdParams.length > 0)
				{
					cmdParams.transParameters(sqlstatement);
				}
				sqlstatement.execute();
				//cmdParams.clear();	
			}
			catch(error:SQLError)
			{
				trace(error.details);
				throw SQLError;
			}
			return sqlstatement.getResult();
		}
        
        // 检测一个记录是否存在
        public static function exists(conn:SQLConnection, sqlString:String, cmdParams:SqlParameter):Boolean
        {
            var result:Array = query(conn, sqlString, cmdParams);
            
            if(!result)
                return false;
            
            return result.length > 0;
        }
        
        // 获取表某个字段的最大值
        public static function getMaxID(conn:SQLConnection, FieldName:String, TableName:String):uint
        {
            var sql:String = "SELECT MAX(" + FieldName + ") FROM " + TableName;
             var result:Array = query(conn, sql, new SqlParameter());
            if (result[0][FieldName] != null)
                return result[0][FieldName];
            else
                return 0;
        }
        
        //总记录数
        public static function getRecordNum(conn:SQLConnection, TableName:String, FieldName:String, cmdParams:SqlParameter, wheresql:String = ""):uint
        {
        	var sql:String = "SELECT COUNT(" + FieldName + ") FROM " + TableName;
        	sql += " "+wheresql;
            var result:Array = query(conn, sql, cmdParams);
            return uint(result[0]["COUNT("+FieldName+")"].toString());
        }
        
        //pageSize 每页数据量
        //pageIndex 页数
        public static function pageList(conn:SQLConnection, sqlString:String, cmdParams:SqlParameter, pageSize:uint, pageIndex:uint):Array
        {
        	sqlString += " LIMIT "+(pageSize*(pageIndex-1)).toString()+", "+pageSize.toString();
        	return query(conn, sqlString, cmdParams);
        }
	}
}





