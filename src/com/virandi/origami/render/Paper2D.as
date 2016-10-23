
/*
 * what		: papercraft | origami
 * when		: 16 Juni 2015 - 24 Agustus 2015
 * where	: in your sincere heart
 * who		: yusuf rizky virandi @ .virandi. studio
 *
 * license	: knowledge belongs to the world..
 */

package com.virandi.origami.render
{
	import flash.display.BitmapData;
	import flash.display.CapsStyle;
	import flash.display.JointStyle;
	import flash.display.LineScaleMode;
	import flash.display.PixelSnapping;
	import flash.display.Sprite;
	import flash.display.TriangleCulling;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TouchEvent;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	
	import com.virandi.base.CMath;
	import com.virandi.base.IHandleEvent;
	import com.virandi.origami.core.Level;
	import com.virandi.origami.core.Paper;
	import com.virandi.origami.core.Shape;
	
	public class Paper2D extends Sprite implements IHandleEvent
	{
		////////////////////////////////////////////////////////////////////////////////////////////////////
		
		public var back:BitmapData = null;
		
		public var front:BitmapData = null;
		
		public var mouse:Object = null;
		
		public var paper:Paper = null;
		
		////////////////////////////////////////////////////////////////////////////////////////////////////
		
		public function get Height () : Number
		{
			return this.paper.Height;
		}
		
		public function get Width () : Number
		{
			return this.paper.Width;
		}
		
		////////////////////////////////////////////////////////////////////////////////////////////////////
		
		public function Paper2D ()
		{
			super ();
			
			this.back = null;
			
			this.front = null;
			
			this.mouse = {
						  down:false,
						  v0:new Vector3D (0.0, 0.0, 0.0, 0.0),
						  v1:new Vector3D (0.0, 0.0, 0.0, 0.0),
						  v2:new Vector3D (0.0, 0.0, 0.0, 0.0),
						  v3:new Vector3D (0.0, 0.0, 0.0, 0.0),
						  v4:new Vector3D (0.0, 0.0, 0.0, 0.0)
						 };
			
			this.paper = new Paper ();
			
			this.addEventListener (Event.ADDED_TO_STAGE, this.HandleEvent, false, 0, false);
		}
		
		////////////////////////////////////////////////////////////////////////////////////////////////////
		
		public function HandleEvent (event:Event) : IHandleEvent
		{
			switch (event.currentTarget)
			{
				case this :
				{
					switch (event.type)
					{
						case Event.ADDED_TO_STAGE :
						{
							this.addEventListener (Event.REMOVED_FROM_STAGE, this.HandleEvent, false, 0, false);
							
							this.stage.addEventListener (Event.ENTER_FRAME, this.HandleEvent, false, 0, false);
							this.stage.addEventListener (MouseEvent.CLICK, this.HandleEvent, false, 0, false);
							this.stage.addEventListener (MouseEvent.MOUSE_DOWN, this.HandleEvent, false, 0, false);
							//this.stage.addEventListener (MouseEvent.MOUSE_MOVE, this.HandleEvent, false, 0, false);
							this.stage.addEventListener (MouseEvent.MOUSE_UP, this.HandleEvent, false, 0, false);
							this.stage.addEventListener (TouchEvent.TOUCH_BEGIN, this.HandleEvent, false, 0, false);
							this.stage.addEventListener (TouchEvent.TOUCH_END, this.HandleEvent, false, 0, false);
							this.stage.addEventListener (TouchEvent.TOUCH_MOVE, this.HandleEvent, false, 0, false);
							this.stage.addEventListener (TouchEvent.TOUCH_TAP, this.HandleEvent, false, 0, false);
							
							this.removeEventListener (Event.ADDED_TO_STAGE, this.HandleEvent, false);
							
							break;
						}
						case Event.REMOVED_FROM_STAGE :
						{
							this.stage.removeEventListener (TouchEvent.TOUCH_TAP, this.HandleEvent, false);
							//this.stage.removeEventListener (TouchEvent.TOUCH_MOVE, this.HandleEvent, false);
							this.stage.removeEventListener (TouchEvent.TOUCH_END, this.HandleEvent, false);
							this.stage.removeEventListener (TouchEvent.TOUCH_BEGIN, this.HandleEvent, false);
							this.stage.removeEventListener (MouseEvent.MOUSE_UP, this.HandleEvent, false);
							this.stage.removeEventListener (MouseEvent.MOUSE_MOVE, this.HandleEvent, false);
							this.stage.removeEventListener (MouseEvent.MOUSE_DOWN, this.HandleEvent, false);
							this.stage.removeEventListener (MouseEvent.CLICK, this.HandleEvent, false);
							this.stage.removeEventListener (Event.ENTER_FRAME, this.HandleEvent, false);
							
							this.removeEventListener (Event.REMOVED_FROM_STAGE, this.HandleEvent, false);
							
							this.addEventListener (Event.ADDED_TO_STAGE, this.HandleEvent, false,0, false);
							
							break;
						}
						default :
						{
							break;
						}
					}
					
					break;
				}
				case this.stage :
				{
					switch (event.type)
					{
						case Event.ENTER_FRAME :
						{
							this.Draw ();
							
							if (this.mouse.down == false)
							{
							}
							else
							{
								this.mouse.v1.x = this.mouseX;
								this.mouse.v1.y = this.mouseY;
								
								this.mouse.v2 = this.mouse.v1.subtract (this.mouse.v0);
								{
									this.mouse.v2.scaleBy (0.5);
								}
								this.mouse.v2 = this.mouse.v2.add (this.mouse.v0);
								
								this.mouse.v3 = CMath.RotateVector (-CMath.ANGLE_90, this.mouse.v2, this.mouse.v1);
								this.mouse.v4 = CMath.RotateVector (+CMath.ANGLE_90, this.mouse.v2, this.mouse.v1);
								
								this.DrawLine (0xFF0000, 2.0, this.mouse.v3, this.mouse.v4).Fold (this.mouse.v3, this.mouse.v4);
							}
							
							break;
						}
						case MouseEvent.CLICK :
						case TouchEvent.TOUCH_TAP :
						{
							(((event as MouseEvent).ctrlKey == false) ? (((event as MouseEvent).shiftKey == false) ? null : this.Print ()) : this.UnX ());
							
							break;
						}
						case MouseEvent.MOUSE_DOWN :
						case TouchEvent.TOUCH_BEGIN :
						{
							if ((((event as MouseEvent).controlKey == false) && ((event as MouseEvent).shiftKey == false)) && ((event.target == this) == false) && (this.mouse.down == false))
							{
								if ((this.paper.fold.length - 1) < this.paper.level.limit)
								{
									this.mouse.down = true;
									
									this.mouse.v0.x = this.mouseX;
									this.mouse.v0.y = this.mouseY;
								}
							}
							
							break;
						}
						case MouseEvent.MOUSE_UP :
						case TouchEvent.TOUCH_END :
						{
							if (this.mouse.down == false)
							{
							}
							else
							{
								this.mouse.down = false;
								
								this.X ();
							}
							
							break;
						}
						default :
						{
							break;
						}
					}
					
					break;
				}
				default :
				{
					break;
				}
			}
			
			return this;
		}
		
		////////////////////////////////////////////////////////////////////////////////////////////////////
		
		public function Create (back:BitmapData, front:BitmapData, level:Level, object:Object) : Paper2D
		{
			var i:int = 0;
			
			var vertex:Array = null;
			
			if (object is Array)
			{
				vertex = (object as Array);
			}
			else
			{
				vertex = [new Vector3D (0.0, 0.0, 0.0, 0.0),
						  new Vector3D (object.width, 0.0, 0.0, 0.0),
						  new Vector3D (object.width, object.height, 0.0, 0.0),
						  new Vector3D (0.0, object.height, 0.0, 0.0)];
				//vertex = [new Vector3D (-(object.width * 0.5), -(object.height * 0.5), 0.0, 0.0),
						  //new Vector3D ((object.width * 0.5), -(object.height * 0.5), 0.0, 0.0),
						  //new Vector3D ((object.width * 0.5), (object.height * 0.5), 0.0, 0.0),
						  //new Vector3D (-(object.width * 0.5), (object.height * 0.5), 0.0, 0.0)];
			}
			
			this.back = ((back == null) ? new BitmapData (this.paper.Width, this.paper.Height, true, 0x7FFF0000) : back);
			
			this.front = ((front == null) ? new BitmapData (this.paper.Width, this.paper.Height, true, 0x7F0000FF) : front);
			
			this.paper.Create (level, vertex);
			
			return this;
		}
		
		public function Debug () : Paper2D
		{
			if ((this.mouse == null) || (this.mouse.down == false))
			{
			}
			else
			{
				this.graphics.lineStyle (1.0, 0x000000, 1.0);
				this.graphics.drawRect (0.0, 0.0, this.paper.width, this.paper.height);
				this.graphics.endFill ();
				
				this.DrawLine (1.0, 0x000000, this.mouse.v0, this.mouse.v1)
					.DrawLine (1.0, 0x000000, this.mouse.v0, this.mouse.v2)
					.DrawLine (1.0, 0xFFFFFF, this.mouse.v2, this.mouse.v3)
					.DrawLine (1.0, 0xFFFFFF, this.mouse.v2, this.mouse.v4);
			}
			
			return this;
		}
		
		public function Destroy () : Paper2D
		{
			((this.parent == null) ? null : this.parent.removeChild (this));
			
			this.paper.Destroy ();
			
			return this;
		}
		
		public function Draw () : Paper2D
		{
			var i:int = 0;
			
			var j:int = 0;
			
			var shape:Shape = null;
			
			var pointA:Point = new Point (0.0, 0.0);
			
			var pointB:Point = new Point (0.0, 0.0);
			
			this.graphics.clear ();
			
			for (i = 0; i != this.paper.shape.length; ++i)
			{
				shape = this.paper.shape [i];
				
				if ((shape == null) || (shape.vertex == null) || (shape.vertex.length == 0))
				{
				}
				else
				{
					this.graphics.lineStyle (null, 0x000000, 0.0, false, LineScaleMode.NONE, CapsStyle.SQUARE, JointStyle.MITER, 1.0);
					this.graphics.beginBitmapFill (((shape.triangleCulling == TriangleCulling.NEGATIVE) ? this.front : this.back), null, false, true);
					this.graphics.drawTriangles (shape.vertex, shape.indice, shape.uv, shape.triangleCulling);
					this.graphics.endFill ();
					
					this.graphics.lineStyle (2.0, 0x000000, 1.0, false, LineScaleMode.NORMAL, CapsStyle.SQUARE, JointStyle.MITER, 1.0);
					this.graphics.moveTo (shape.vertex [0], shape.vertex [1]);
					for (j = shape.vertex.length; j != 0; j = (j - 2))
					{
						this.graphics.lineTo (shape.vertex [(j - 2)], shape.vertex [(j - 1)]);
					}
				}
			}
			
			if (this.paper.level == null)
			{
			}
			else
			{
				this.graphics.lineStyle (2.0, 0xFFFFFF, 1.0, false, LineScaleMode.NONE, CapsStyle.SQUARE, JointStyle.MITER, 1.0);
				this.graphics.moveTo ((this.paper.level.vertex [0] * this.paper.vertex [0]), (this.paper.level.vertex [1] * this.paper.vertex [1]));
				
				for (i = this.paper.level.vertex.length; i != 0; i = (i - 2))
				{
					this.graphics.lineTo ((this.paper.level.vertex [(i - 2)] * this.paper.vertex [(i - 2)]), (this.paper.level.vertex [(i - 1)] * this.paper.vertex [(i - 1)]));
				}
			}
			
			this.paper.Draw ();
			
			return this;
		}
		
		public function Fold (v0:Vector3D, v1:Vector3D) : Paper2D
		{
			this.paper.Fold (v0, v1);
			
			return this;
		}
		
		public function Print () : Paper2D
		{
			this.paper.Print ();
			
			return this;
		}
		
		public function Score () : Number
		{
			return this.paper.Score ();
		}
		
		public function UnX () : Paper2D
		{
			this.paper.UnX ();
			
			return this.Draw ();
		}
		
		public function X () : Paper2D
		{
			this.paper.X ();
			
			return this;
		}
		
		////////////////////////////////////////////////////////////////////////////////////////////////////
		
		public function DrawLine (color:uint, thickness:Number, v0:Vector3D, v1:Vector3D) : Paper2D
		{
			this.graphics.lineStyle (thickness, color, 1.0);
			{
				this.graphics.moveTo (v0.x, v0.y);
				this.graphics.lineTo (v1.x, v1.y);
			}
			
			return this;
		}
		
		public function DrawVertex (alpha:Number, color:uint, radius:Number, v0:Vector3D) : Paper2D
		{
			this.graphics.beginFill (color, alpha);
			{
				this.graphics.drawCircle (v0.x, v0.y, radius);
			}
			this.graphics.endFill ();
			
			return this;
		}
		
		////////////////////////////////////////////////////////////////////////////////////////////////////
	}
}
