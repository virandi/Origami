
package
{
	import flash.data.SQLConnection;
	import flash.data.SQLMode;
	import flash.data.SQLStatement;
	import flash.filesystem.File;
	import flash.utils.Dictionary;
	
	public class DB
	{
		////////////////////////////////////////////////////////////////////////////////////////////////////
		
		static public var instance:DB = null;
		
		static public function get Instance () : DB
		{
			return (DB.instance = ((DB.instance == null) ? new DB () : DB.instance));
		}
		
		////////////////////////////////////////////////////////////////////////////////////////////////////
		
		public const CACHE_LEVEL:Dictionary = new Dictionary (false);
		
		public const CACHE_RECORD:Dictionary = new Dictionary (false);
		
		////////////////////////////////////////////////////////////////////////////////////////////////////
		
		public var file:File = null;
		
		public var sqlConnection:SQLConnection = null;
		
		public var sqlStatement:SQLStatement = null;
		
		////////////////////////////////////////////////////////////////////////////////////////////////////
		
		public function DB ()
		{
			super ();
			
			this.file = null;
			
			this.sqlConnection = null;
			
			this.sqlStatement = null;
		}
		
		////////////////////////////////////////////////////////////////////////////////////////////////////
		
		public function DeInitialize () : DB
		{
			if (this.sqlConnection == null)
			{
			}
			else
			{
				this.sqlConnection.close (null);
			}
			
			this.sqlStatement = null;
			
			this.sqlConnection = null;
			
			this.file = null;
			
			return this;
		}
		
		public function Initialize (db:String) : DB
		{
			var data:Object = null;
			
			try
			{
				this.file = File.applicationDirectory.resolvePath (db);
				
				trace (this.file.nativePath);
				
				this.sqlConnection = ((this.sqlConnection == null) ? new SQLConnection () : this.sqlConnection);
				
				this.sqlStatement = ((this.sqlStatement == null) ? new SQLStatement () : this.sqlStatement);
				
				for (; this.sqlConnection.connected == false; )
				{
					this.sqlConnection.open (this.file, SQLMode.CREATE, false, 1024, null);
				}
				
				this.Execute ("CREATE TABLE IF NOT EXISTS T_LEVEL (FOLD INTEGER NOT NULL, ID TEXT PRIMARY KEY NOT NULL, STAR TEXT NOT NULL, VERTEX STRING NOT NULL);");
				this.Execute ("CREATE TABLE IF NOT EXISTS T_RECORD (LEVEL_ID TEXT NOT NULL, SCORE INTEGER NOT NULL);");
				
				this.Execute ("INSERT INTO T_LEVEL (FOLD, ID, STAR, VERTEX) VALUES (22091986, '.VIRANDI.', '80.0|90.0|95.0|97.5', '0.0|0.0|0.5|0.0|0.5|0.5|0.0|0.5');");
				//this.Execute ("INSERT INTO T_LEVEL (FOLD, ID, STAR, VERTEX) VALUES (2, 'RECTANGLE', '80.0|90.0|95.0|97.5', '0.0|0.0|0.5|0.0|0.5|0.5|0.0|0.5');");
				//this.Execute ("INSERT INTO T_LEVEL (FOLD, ID, STAR, VERTEX) VALUES (3, 'TRIANGLE', '80.0|90.0|95.0|97.5', '0.0|0.0|0.5|0.0|0.0|0.5');");
			}
			catch (error:Error)
			{
				trace (error.getStackTrace ());
			}
			
			return this;
		}
		
		////////////////////////////////////////////////////////////////////////////////////////////////////
		
		public function Cache () : DB
		{
			var data:Object = null;
			
			this.Execute ("SELECT * FROM T_LEVEL;");
			{
				for each (data in this.sqlStatement.getResult ().data)
				{
					this.CACHE_LEVEL [data.ID] = data;
				}
			}
			
			this.Execute ("SELECT * FROM T_RECORD;");
			{
				for each (data in this.sqlStatement.getResult ().data)
				{
					this.CACHE_RECORD [data.LEVEL_ID] = data;
				}
			}
			
			return this;
		}
		
		public function Execute (string:String) : DB
		{
			if ((string == null) || (this.file == null) || (this.sqlConnection == null) || (this.sqlStatement == null))
			{
			}
			else
			{
				this.sqlStatement.sqlConnection = this.sqlConnection;
				this.sqlStatement.text = string;
				
				this.sqlStatement.execute (-1, null);
			}
			
			return this;
		}
		
		public function Flush () : DB
		{
			var data:Object = null;
			
			this.sqlStatement.clearParameters ();
			{
				this.Execute ("DELETE FROM T_LEVEL;");
				
				for each (data in this.CACHE_LEVEL)
				{
					this.sqlStatement.parameters [":FOLD"] = data.FOLD;
					this.sqlStatement.parameters [":ID"] = data.ID;
					this.sqlStatement.parameters [":STAR"] = data.STAR;
					this.sqlStatement.parameters [":VERTEX"] = data.VERTEX;
					
					this.Execute ("INSERT INTO T_LEVEL (FOLD, ID, STAR, VERTEX) VALUES (:FOLD, :ID, :STAR, :VERTEX);");
				}
			}
			this.sqlStatement.clearParameters ();
			
			this.sqlStatement.clearParameters ();
			{
				this.Execute ("DELETE FROM T_RECORD;");
				
				for each (data in this.CACHE_RECORD)
				{
					this.sqlStatement.parameters [":LEVEL_ID"] = data.LEVEL_ID;
					this.sqlStatement.parameters [":SCORE"] = data.SCORE;
					
					this.Execute ("INSERT INTO T_RECORD (LEVEL_ID, SCORE) VALUES (:LEVEL_ID, :SCORE)");
				}
			}
			this.sqlStatement.clearParameters ();
			
			return this;
		}
		
		////////////////////////////////////////////////////////////////////////////////////////////////////
	}
}
