
/*
 * what		: origami
 * when		: 16 Juni 2015 - 24 Agustus 2015
 * where	: in your sincere heart
 * who		: yusuf rizky virandi @ .virandi. studio
 *
 * license	: knowledge belongs to the world..
 */

package com.virandi.origami.core
{
	public class Shape
	{
		////////////////////////////////////////////////////////////////////////////////////////////////////
		
		public var indice:Vector.<int> = null;
		
		public var mirror:Array = null;
		
		public var triangleCulling:String = null;
		
		public var uv:Vector.<Number> = null;
		
		public var vertex:Vector.<Number> = null;
		
		////////////////////////////////////////////////////////////////////////////////////////////////////
		
		public function Shape ()
		{
			super ();
			
			this.indice = null;
			
			this.mirror = null;
			
			this.triangleCulling = null;
			
			this.uv = null;
			
			this.vertex = null;
		}
		
		////////////////////////////////////////////////////////////////////////////////////////////////////
		
		public function Create (mirror:Array, triangleCulling:String, uv:Vector.<Number>, vertex:Vector.<Number>) : Shape
		{
			var a:int = 0;
			
			var b:int = 0;
			
			var c:int = 0;
			
			var i:int = 0;
			
			this.Destroy ();
			
			if (vertex.length < 6)
			{
			}
			else
			{
				this.indice = new Vector.<int> ();
				
				this.mirror = mirror.concat ();
				
				this.triangleCulling = triangleCulling;
				
				this.uv = uv.concat ();
				
				this.vertex = vertex.concat ();
				
				for (i = 0; i != this.vertex.length; ++i)
				{
					this.vertex [i] = (Math.floor (this.vertex [i] * 10.0) / 10.0);
				}
				
				for (i = 0; ; )
				{
					if ((i + 2) == (this.vertex.length >> 1))
					{
						break;
					}
					else
					{
						this.indice.push (0, ++i, ++i);
						
						--i;
					}
				}
			}
			
			return this;
		}
		
		public function Destroy () : Shape
		{
			((this.vertex == null) ? null : (this.vertex.length = 0));
			
			((this.uv == null) ? null : (this.uv.length = 0));
			
			((this.indice == null) ? null : (this.indice.length = 0));
			
			this.vertex = null;
			
			this.uv = null;
			
			this.triangleCulling = null;
			
			this.indice = null;
			
			return this;
		}
		
		////////////////////////////////////////////////////////////////////////////////////////////////////
	}
}
