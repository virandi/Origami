
package com.virandi.origami.core
{
	public class Level
	{
		////////////////////////////////////////////////////////////////////////////////////////////////////
		
		public var id:String = null;
		
		public var limit:int = 0;
		
		public var vertex:Vector.<Number> = null;
		
		////////////////////////////////////////////////////////////////////////////////////////////////////
		
		public function Level ()
		{
			super ();
			
			this.id = null;
			
			this.limit = 0;
			
			this.vertex = null;
		}
		
		////////////////////////////////////////////////////////////////////////////////////////////////////
		
		public function Create (id:String, limit:int, vertex:Object) : Level
		{
			var v:Number = 0.0;
			
			this.Destroy ();
			
			this.id = id;
			
			this.limit = limit;
			
			if (vertex == null)
			{
			}
			else
			{
				if (vertex is Array)
				{
					this.vertex = new Vector.<Number> ();
					
					for each (v in vertex)
					{
						this.vertex.push (v);
					}
				}
				else
				{
					this.vertex = vertex.concat ();
				}
			}
			
			return this;
		}
		
		public function Destroy () : Level
		{
			if (this.vertex == null)
			{
			}
			else
			{
				this.vertex.length = 0;
			}
			
			this.vertex = null;
			
			this.limit = 0;
			
			this.id = null;
			
			return this;
		}
		
		////////////////////////////////////////////////////////////////////////////////////////////////////
	}
}
