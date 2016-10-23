
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
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.Graphics;
	import flash.display.PixelSnapping;
	import flash.display.Sprite;
	import flash.display.TriangleCulling;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	import flash.system.System;
	import flash.utils.ByteArray;
	
	import com.virandi.base.CMath;
	
	public class Paper
	{
		////////////////////////////////////////////////////////////////////////////////////////////////////
		
		public var fold:Vector.<Object> = null;
		
		public var height:Number = 0.0;
		
		public var level:Level = null;
		
		public var min:Point = null;
		
		public var shape:Vector.<Shape> = null;
		
		public var uv:Vector.<Number> = null;
		
		public var vertex:Vector.<Number> = null;
		
		public var width:Number = 0.0;
		
		////////////////////////////////////////////////////////////////////////////////////////////////////
		
		public function Paper ()
		{
			super ();
			
			this.fold = new Vector.<Object> ();
			
			this.height = 0.0;
			
			this.level = null;
			
			this.min = new Point (0.0, 0.0);
			
			this.shape = new Vector.<Shape> ();
			
			this.uv = new Vector.<Number> ();
			
			this.vertex = new Vector.<Number> ();
			
			this.width = 0.0;
		}
		
		////////////////////////////////////////////////////////////////////////////////////////////////////
		
		public function get Height () : Number
		{
			var i:int = 0;
			
			var maxY:Number = 0.0;
			
			var minY:Number = 0.0;
			
			var shape:Shape = null;
			
			for each (shape in this.shape)
			{
				for (i = 0; i != shape.vertex.length; i = (i + 2))
				{
					maxY = Math.max (maxY, shape.vertex [i + 1]);
					
					minY = Math.min (minY, shape.vertex [i + 1]);
				}
			}
			
			return ((this.shape.length == 0) ? this.height : (maxY - minY));
		}
		
		public function get Width () : Number
		{
			var i:int = 0;
			
			var maxX:Number = 0.0;
			
			var minX:Number = 0.0;
			
			var shape:Shape = null;
			
			for each (shape in this.shape)
			{
				for (i = 0; i != shape.vertex.length; i = (i + 2))
				{
					maxX = Math.max (maxX, shape.vertex [i]);
					
					minX = Math.min (minX, shape.vertex [i]);
				}
			}
			
			return ((this.shape.length == 0) ? this.width : (maxX - minX));
		}
		
		////////////////////////////////////////////////////////////////////////////////////////////////////
		
		public function Create (level:Level, vertex:Array) : Paper
		{
			var maxX:Number = 0.0;
			
			var maxY:Number = 0.0;
			
			var minX:Number = 0.0;
			
			var minY:Number = 0.0;
			
			var v:Vector3D = null;
			
			for each (v in vertex)
			{
				maxX = Math.max (maxX, v.x);
				
				maxY = Math.max (maxY, v.y);
				
				minX = Math.min (minX, v.x);
				
				minY = Math.min (minY, v.y);
			}
			
			this.Destroy ();
			
			this.fold [0] = null;
			
			this.height = (maxY - minY);
			
			this.level = level;
			
			this.min = new Point (minX, minY);
			
			this.width = (maxX - minX);
			
			for each (v in vertex)
			{
				this.uv.push (((v.x - this.min.x) / this.width), ((v.y - this.min.y) / this.height));
				
				this.vertex.push (v.x, v.y);
			}
			
			this.X ();
			
			return this;
		}
		
		public function Destroy () : Paper
		{
			this.vertex.length = 0;
			
			this.uv.length = 0;
			
			this.shape.length = 0;
			
			this.fold.length = 0;
			
			this.level = null;
			
			return this;
		}
		
		public function Draw () : Paper
		{
			var a:int = 0;
			
			var b:int = 0;
			
			var c:int = 0;
			
			var d:int = 0;
			
			var flag:Object = null;
			
			var fold:Array = new Array ();
			
			var i:int = 0;
			
			var j:int = 0;
			
			var k:int = 0;
			
			var l:int = 0;
			
			var m:int = 0;
			
			var n:int = 0;
			
			var o:int = 0;
			
			var p:int = 0;
			
			var q:int = 0;
			
			var shape:Shape = null;
			
			var triangleCulling:String = null;
			
			var uv:Vector3D = new Vector3D (0.0, 0.0, 0.0, 0.0);
			
			var uv0:Vector.<Number> = new Vector.<Number> ();
			
			var uv1:Vector.<Number> = new Vector.<Number> ();
			
			var v:Vector.<Shape> = new Vector.<Shape> ();
			
			var v0:Vector3D = null;
			
			var v1:Vector3D = null;
			
			var v2:Vector3D = new Vector3D (0.0, 0.0, 0.0, 0.0);
			
			var v3:Vector3D = new Vector3D (0.0, 0.0, 0.0, 0.0);
			
			var v4:Vector3D = new Vector3D (0.0, 0.0, 0.0, 0.0);
			
			var v5:Vector3D = new Vector3D (0.0, 0.0, 0.0, 0.0);
			
			var vertex0:Vector.<Number> = new Vector.<Number> ();
			
			var vertex1:Vector.<Number> = new Vector.<Number> ();
			
			var vX:Vector3D = null;
			
			this.shape.length = 0;
			
			this.shape [0] = new Shape ().Create (new Array (), TriangleCulling.NEGATIVE, this.uv, this.vertex);
			
			for (i = this.fold.length; i != 0; )
			{
				flag = false;
				
				i = (i - 1);
				
				v0 = this.fold [i].v0;
				
				v1 = this.fold [i].v1;
				
				if (Vector3D.distance (v0, v1) < 10.0)
				{
				}
				else
				{
					v.length = 0;
					
					for (j = this.shape.length; j != 0; )
					{
						shape = this.shape [--j];
						
						if ((shape == null) || (shape.vertex == null))
						{
						}
						else
						{
							fold.length = 0;
							
							triangleCulling = shape.triangleCulling;
							
							uv0.length = 0;
							
							uv1.length = 0;
							
							vertex0.length = 0;
							
							vertex1.length = 0;
							
							for (l = shape.vertex.length, m = l; l != 0; )
							{
								a = --l;
								
								b = --l;
								
								c = (a + 2);
								
								d = (b + 2);
								
								v2.x = shape.vertex [b];
								v2.y = shape.vertex [a];
								
								v3.x = shape.vertex [(d % m)];
								v3.y = shape.vertex [(c % m)];
								
								vX = CMath.IntersectionLine (v0, v1, v2, v3, false);
								
								if (vX == null)
								{
								}
								else
								{
									n = Vector3D.distance (v2, v3);
									
									o = Vector3D.distance (v2, vX);
									
									p = Vector3D.distance (v3, vX);
									
									if ((n < o) || (n < p))
									{
									}
									else
									{
										//Main.Instance.paper2D.DrawVertex (1.0, 0xFFFFFF, 4.0, vX);
										
										if (o == 0)
										{
											fold.unshift (b);
										}
										else if (p == 0)
										{
											q = (d % m);
											
											if (fold.indexOf (q, 0) == -1)
											{
												fold.unshift (q);
											}
										}
										else
										{
											if (fold.indexOf (d, 0) == -1)
											{
												for (q = fold.length; q != 0; )
												{
													q = (q - 1);
													
													if (d < fold [q])
													{
														fold [q] = (fold [q] + 2);
													}
												}
												
												uv.x = (Math.floor (vX.x * 10.0) / 10.0);
												uv.y = (Math.floor (vX.y * 10.0) / 10.0);
												
												for (q = shape.mirror.length; q != 0; )
												{
													uv = CMath.MirrorVector (uv, shape.mirror [--q].v0, shape.mirror [q].v1);
												}
												
												uv.x = ((uv.x - this.min.x) / this.width);
												uv.y = ((uv.y - this.min.y) / this.height);
												
												fold.unshift (d);
												
												shape.uv.splice (d, 0, uv.x, uv.y);
												
												shape.vertex.splice (d, 0, vX.x, vX.y);
											}
										}
									}
								}
							}
							
							for (l = shape.vertex.length; l != 0; )
							{
								a = --l;
								
								b = --l;
								
								v2.x = (Math.floor (shape.vertex [b] * 10.0) / 10.0);
								v2.y = (Math.floor (shape.vertex [a] * 10.0) / 10.0);
								
								if (fold.indexOf (b, 0) == -1)
								{
									if (v0.subtract (v2).crossProduct (v1.subtract (v2)).z <= 0.0)
									{
										uv0.unshift (shape.uv [b], shape.uv [a]);
										
										vertex0.unshift (v2.x, v2.y);
									}
									else
									{
										flag = true;
										
										v2 = CMath.MirrorVector (v2, v0, v1);
										
										uv1.unshift (shape.uv [b], shape.uv [a]);
										
										vertex1.unshift (v2.x, v2.y);
									}
								}
								else
								{
									uv0.unshift (shape.uv [b], shape.uv [a]);
									
									uv1.unshift (shape.uv [b], shape.uv [a]);
									
									vertex0.unshift (v2.x, v2.y);
									
									vertex1.unshift (v2.x, v2.y);
								}
							}
							
							//trace ("fold", fold);
							//trace ("shape", shape.vertex);
							//trace ("v0", vertex0);
							//trace ("v1", vertex1);
							
							((vertex1.length < 6) ? null : this.shape.push (new Shape ().Create (shape.mirror.concat (this.fold [i]), ((triangleCulling == TriangleCulling.NEGATIVE) ? TriangleCulling.POSITIVE : TriangleCulling.NEGATIVE), uv1, vertex1)));
							
							((vertex0.length < 6) ? this.shape.splice (j, 1) [0].Destroy () : shape.Create (shape.mirror, triangleCulling, uv0, vertex0));
						}
					}
				}
				
				this.fold [i].flag = flag;
			}
			
			return this;
		}
		
		public function Fold (v0:Vector3D, v1:Vector3D) : Paper
		{
			this.fold [0].v0.x = (Math.floor (v0.x * 10.0) / 10.0);
			this.fold [0].v0.y = (Math.floor (v0.y * 10.0) / 10.0);
			this.fold [0].v0.z = (Math.floor (v0.z * 10.0) / 10.0);
			
			this.fold [0].v1.x = (Math.floor (v1.x * 10.0) / 10.0);
			this.fold [0].v1.y = (Math.floor (v1.y * 10.0) / 10.0);
			this.fold [0].v1.z = (Math.floor (v1.z * 10.0) / 10.0);
			
			return this;
		}
		
		public function Print () : Paper
		{
			var i:int = 0;
			
			var string:String = new String ();
			
			for (i = 0; i != this.fold.length; ++i)
			{
				string = string.concat ("this.paper2D.paper.fold.push ({flag:", this.fold [i].flag, ", ", "v0:new ", this.fold [i].v0, ", ", "v1:new ", this.fold [i].v1, "});", "\n");
			}
			
			trace (string);
			
			System.setClipboard (string);
			
			return this;
		}
		
		public function Score () : Number // optimize this using byteArray of bitmapData..
		{
			var bitmapData:BitmapData  = null;
			
			var color:Object = {green:0, red:0, yellow:0};
			
			var i:int = 0;
			
			var pixel:int = 0x0;
			
			var score:Number = 0.0;
			
			var shape:Shape = null;
			
			var spriteA:Sprite = new Sprite ();
			
			var spriteB:Sprite = new Sprite ();
			
			var x:int = 0;
			
			var y:int = 0;
			
			spriteA.graphics.beginFill (0xFF0000, 1.0);
			{
				spriteA.graphics.moveTo (this.level.vertex [(this.level.vertex.length - 2)] * this.vertex [(this.level.vertex.length - 2)], this.level.vertex [(this.level.vertex.length - 1)] * this.vertex [(this.level.vertex.length - 1)]);
				
				for (i = this.level.vertex.length; i != 0; i = (i - 2))
				{
					spriteA.graphics.lineTo (this.level.vertex [(i - 2)] * this.vertex [(i - 2)], this.level.vertex [(i - 1)] * this.vertex [(i - 1)]);
				}
			}
			spriteA.graphics.endFill ();
			
			for each (shape in this.shape)
			{
				if ((shape == null) || (shape.vertex == null) || (shape.vertex.length < 6))
				{
				}
				else
				{
					spriteB.graphics.beginFill (0x00FF00, 1.0);
					{
						spriteB.graphics.moveTo (shape.vertex [(shape.vertex.length - 2)], shape.vertex [(shape.vertex.length - 1)]);
						
						for (i = shape.vertex.length; i != 0; i = (i - 2))
						{
							spriteB.graphics.lineTo (shape.vertex [(i - 2)], shape.vertex [(i - 1)]);
						}
					}
					spriteB.graphics.endFill ();
				}
			}
			
			bitmapData = new BitmapData (Math.max (spriteA.width, spriteB.width), Math.max (spriteA.height, spriteB.height), false, 0x00000000);
			
			bitmapData.draw (spriteA, null, null, BlendMode.ADD, null, false);
			bitmapData.draw (spriteB, null, null, BlendMode.ADD, null, false);
			
			for (y = bitmapData.height; y != 0; )
			{
				--y;
				
				for (x = bitmapData.width; x != 0; )
				{
					--x;
					
					pixel = bitmapData.getPixel (x, y);
					
					color.yellow = (color.yellow + ((pixel == 0xFFFF00) ? 1 : 0));
					color.red = (color.red + ((pixel == 0xFF0000) ? 1 : 0));
					color.green = (color.green + ((pixel == 0x00FF00) ? 1 : 0));
				}
			}
			
			score = Math.max (0.0, Math.min (1.0, ((color.yellow - Math.max (color.red, color.green)) / (color.yellow + color.red))));
			
			spriteB = null;
			
			spriteA = null;
			
			color = null;
			
			bitmapData = null;
			
			return score;
		}
		
		public function UnX () : Paper
		{
			this.fold [0] = this.fold.shift ();
			
			return this.Draw ();
		}
		
		public function X () : Paper
		{
			if (this.fold [0] == null)
			{
			}
			else
			{
				if (this.fold [0].flag == false)
				{
					this.fold [0] = null;
				}
				else
				{
					this.fold.unshift (null);
				}
			}
			
			if (this.fold [0] == null)
			{
				this.fold [0] = {flag:false, v0:new Vector3D (0.0, 0.0, 0.0, 0.0), v1:new Vector3D (0.0, 0.0, 0.0, 0.0)};
			}
			
			return this;
		}
		
		////////////////////////////////////////////////////////////////////////////////////////////////////
	}
}
