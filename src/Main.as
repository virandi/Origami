
/*
 * what		: origami
 * when		: 16 Juni 2015 - 02 December 2015
 * where	: in your sincere heart
 * who		: yusuf rizky virandi @ .virandi. studio
 *
 * license	: knowledge belongs to the world..
 */

package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.PixelSnapping;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import flash.display.TriangleCulling;
	import flash.events.Event;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.BlurFilter;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	
	import com.virandi.base.CMain;
	import com.virandi.base.IHandleEvent;
	import com.virandi.base.IState;
	import com.virandi.origami.core.Level;
	import com.virandi.origami.render.Paper2D;
	import com.virandi.origami.state.StatePlay;
	
	public class Main extends CMain
	{
		////////////////////////////////////////////////////////////////////////////////////////////////////
		
		static public var instance:Main = null;
		
		static public function get Instance () : Main
		{
			return Main.instance;
		}
		
		////////////////////////////////////////////////////////////////////////////////////////////////////
		
		public var audio:Object = null;
		
		public var level:Object = null;
		
		////////////////////////////////////////////////////////////////////////////////////////////////////
		
		override public function get Height () : Number
		{
			return 720.0;
		}
		
		override public function get Width () : Number
		{
			return 1280.0;
		}
		
		////////////////////////////////////////////////////////////////////////////////////////////////////
		
		public function Main ()
		{
			super ();
			
			Main.instance = this;
			
			DB.Instance.Initialize ("DB_ORIGAMI").Cache ();
		}
		
		////////////////////////////////////////////////////////////////////////////////////////////////////
		
		override public function HandleEvent (event:Event) : IHandleEvent
		{
			super.HandleEvent (event);
			
			//var i:int = 0;
			//
			//var shape:Shape = null;
			//
			//var vertex:Vector.<Number> = null;
			
			switch (event.currentTarget)
			{
				case this.stage :
				{
					switch (event.type)
					{
						case Event.ENTER_FRAME :
						{
							//this.graphics.clear ();
							//for each (shape in this.paper2D.paper.shape)
							//{
								//vertex = shape.uv.concat ();
								//
								//for (i = 0; i != vertex.length; i = (i + 2))
								//{
									//vertex [i] = (vertex [i] * this.paper2D.Width);
									//vertex [i + 1] = (vertex [i + 1] * this.paper2D.Height);
								//}
								//
								//this.graphics.lineStyle (null, 0x000000, 0.0);
								//this.graphics.beginBitmapFill (((shape.triangleCulling == TriangleCulling.NEGATIVE) ? this.paper2D.front : this.paper2D.back), null, false, true);
								//this.graphics.drawTriangles (vertex, shape.indice, shape.uv, TriangleCulling.NONE);
								//this.graphics.endFill ();
								//
								//this.graphics.lineStyle (1.0, 0xFF0000, 1.0);
								//this.graphics.moveTo (shape.uv [0] * this.paper2D.Width, shape.uv [1] * this.paper2D.Height);
								//for (i = 2; i != shape.vertex.length; i = (i + 2))
								//{
									//this.graphics.lineTo (shape.uv [i] * this.paper2D.Width, shape.uv [i + 1] * this.paper2D.Height);
								//}
								//this.graphics.lineTo (shape.uv [0] * this.paper2D.Width, shape.uv [1] * this.paper2D.Height);
								//this.graphics.endFill ();
							//}
							
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
		
		override public function DeInitialize () : IState
		{
			DB.Instance.Flush ().DeInitialize ();
			
			super.DeInitialize ();
			
			return this;
		}
		
		override public function Initialize () : IState
		{
			super.Initialize ();
			
			var data:Object = null;
			
			var i:int = 0;
			
			this.audio = new Object ();
			
			this.level = new Object ();
			
			this.opaqueBackground = 0x333333;
			
			this.audio.flag = true;
			
			this.level.list = new Vector.<Object> ();
			{
				for each (data in DB.Instance.CACHE_LEVEL)
				{
					this.level.list.unshift ({FOLD:data.FOLD, ID:data.ID, LOCK:(((DB.Instance.CACHE_RECORD [data.ID] == null) || (DB.Instance.CACHE_RECORD [data.ID] == undefined)) ? true : false), SCORE:(((DB.Instance.CACHE_RECORD [data.ID] == null) || (DB.Instance.CACHE_RECORD [data.ID] == undefined)) ? 0.0 : DB.Instance.CACHE_RECORD [data.ID].SCORE), STAR:data.STAR, VERTEX:data.VERTEX});
					
					for (i = 0, this.level.list [0].STAR = this.level.list [0].STAR.split ("|", uint.MAX_VALUE); i != this.level.list [0].STAR.length; ++i)
					{
						this.level.list [0].STAR [i] = new Number (this.level.list [0].STAR [i]);
					}
					
					for (i = 0, this.level.list [0].VERTEX = this.level.list [0].VERTEX.split ("|", uint.MAX_VALUE); i != this.level.list [0].VERTEX.length; ++i)
					{
						this.level.list [0].VERTEX [i] = new Number (this.level.list [0].VERTEX [i]);
					}
				}
			}
			this.level.list = this.level.list.reverse ();
			this.level.play = new Level ();
			this.level.select = this.level.list [0];
			
			this.stage.align = StageAlign.TOP_LEFT;
			this.stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
			this.stage.scaleMode = StageScaleMode.NO_SCALE;
			
			this.graphics.clear ();
			this.graphics.beginFill (int (this.opaqueBackground), 1.0);
			this.graphics.drawRect (0.0, 0.0, this.Width, this.Height);
			this.graphics.endFill ();
			
			//this.level.list.push ({id:"RECTANGLE", limit:2, lock:false, paper:{height:100.0, width:100.0}, score:0.0, vertex:new <Number> [0.0, 0.0, 200.0, 0.0, 200.0, 200.0, 0.0, 200.0], win:{bronze:90.0, gold:97.5, nope:80.0, silver:95.0}});
			//this.level.list.push ({id:"TRIANGLE", limit:3, lock:false, paper:{height:100.0, width:100.0}, score:0.0, vertex:new <Number> [0.0, 0.0, 200.0, 200.0, 0.0, 200.0], win:{bronze:90.0, gold:97.5, silver:95.0}});
			//this.level.list.push ({id:"", limit:3, lock:false, paper:{height:100.0, width:100.0}, score:0.0, vertex:new <Number> [], win:{bronze:90.0, gold:97.5, silver:95.0}});
			//this.level.list.push ({id:"", limit:3, lock:false, paper:{height:100.0, width:100.0}, score:0.0, vertex:new <Number> [], win:{bronze:90.0, gold:97.5, silver:95.0}});
			//this.level.list.push ({id:"", limit:3, lock:false, paper:{height:100.0, width:100.0}, score:0.0, vertex:new <Number> [], win:{bronze:90.0, gold:97.5, silver:95.0}});
			
			Main.Instance.PushState (StatePlay.Instance);
			
			//var paper2D:Paper2D = new Paper2D ().Create (Library.Instance.dictionary [Library.IMAGE_VIRANDI_STUDIO].bitmapData, Library.Instance.dictionary [Library.IMAGE_VIRANDI_STUDIO].bitmapData, new Level ().Create ("TRIANGLE", 2, new <Number> [0.0, 0.0, 100.0, 0.0, 100.0, 100.0, 0.0, 100.0]), {height:200.0, width:200.0});
			//
			//paper2D.x = (this.Width * 0.5);
			//paper2D.y = (this.Height * 0.5);
			//
			//this.addChild (paper2D);
			//this.addChildAt (Library.Instance.dictionary [Library.MC_BACKGROUND], 0);
			//
			//this.paper2D.paper.fold.push ({flag:false, v0:new Vector3D(405, 179, 0), v1:new Vector3D(159, -143, 0)});
			//this.paper2D.paper.fold.push ({flag:false, v0:new Vector3D(83, -181, 0), v1:new Vector3D(386, 254, 0)});
			//this.paper2D.paper.fold.push ({flag:false, v0:new Vector3D(180, 15, 0), v1:new Vector3D(185, 11, 0)});
			//this.paper2D.paper.fold.push ({flag:false, v0:new Vector3D(134, 16, 0), v1:new Vector3D(-6, 128, 0)});
			
			//this.paper2D.paper.fold.push ({flag:false, v0:new Vector3D(362, 174, 0), v1:new Vector3D(144, -192, 0)});
			//this.paper2D.paper.fold.push ({flag:false, v0:new Vector3D(83, -181, 0), v1:new Vector3D(386, 254, 0)});
			//this.paper2D.paper.fold.push ({flag:false, v0:new Vector3D(180, 15, 0), v1:new Vector3D(185, 11, 0)});
			//this.paper2D.paper.fold.push ({flag:false, v0:new Vector3D(134, 16, 0), v1:new Vector3D(-6, 128, 0)});
			
			//this.paper2D.paper.fold.push ({flag:false, v0:new Vector3D(541, 45, 0), v1:new Vector3D(274, 1, 0)});
			//this.paper2D.paper.fold.push ({flag:false, v0:new Vector3D(83, -181, 0), v1:new Vector3D(386, 254, 0)});
			//this.paper2D.paper.fold.push ({flag:false, v0:new Vector3D(180, 15, 0), v1:new Vector3D(185, 11, 0)});
			//this.paper2D.paper.fold.push ({flag:false, v0:new Vector3D(134, 16, 0), v1:new Vector3D(-6, 128, 0)});
			
			//this.paper2D.paper.fold.push ({flag:false, v0:new Vector3D(441, 15, 0), v1:new Vector3D(263, -40, 0)});
			//this.paper2D.paper.fold.push ({flag:false, v0:new Vector3D(83, -181, 0), v1:new Vector3D(386, 254, 0)});
			//this.paper2D.paper.fold.push ({flag:false, v0:new Vector3D(180, 15, 0), v1:new Vector3D(185, 11, 0)});
			//this.paper2D.paper.fold.push ({flag:false, v0:new Vector3D(134, 16, 0), v1:new Vector3D(-6, 128, 0)});
			
			//this.paper2D.paper.fold.push ({flag:false, v0:new Vector3D(219, -135, 0), v1:new Vector3D(171, 221, 0)});
			
			//this.paper2D.paper.fold.push ({flag:false, v0:new Vector3D(203, -182, 0), v1:new Vector3D(199, 206, 0)});
			
			//this.paper2D.paper.fold.push ({flag:false, v0:new Vector3D(-24, 343, 0), v1:new Vector3D(38, -30, 0)});
			
			//this.paper2D.paper.fold.push ({flag:false, v0:new Vector3D(368, 190, 0), v1:new Vector3D(418, 137, 0)});
			//this.paper2D.paper.fold.push ({flag:false, v0:new Vector3D(221, -138, 0), v1:new Vector3D(219, 186, 0)});
			
			//this.paper2D.paper.fold.push ({flag:false, v0:new Vector3D(62, 14, 0), v1:new Vector3D(39, 43, 0)});
			//this.paper2D.paper.fold.push ({flag:false, v0:new Vector3D(31, 122, 0), v1:new Vector3D(81, 171, 0)});
			//this.paper2D.paper.fold.push ({flag:false, v0:new Vector3D(180, 103, 0), v1:new Vector3D(92, 22, 0)});
			
			//this.paper2D.paper.fold.push ({flag:false, v0:new Vector3D(185, 172, 0), v1:new Vector3D(23, 21, 0)});
			
			//this.paper2D.paper.fold.push ({flag:false, v0:new Vector3D(207, 183, 0), v1:new Vector3D(61, 12, 0)});
			//this.paper2D.paper.fold.push ({flag:false, v0:new Vector3D(135, 97, 0), v1:new Vector3D(225, 226, 0)});
			//this.paper2D.paper.fold.push ({flag:false, v0:new Vector3D(249, 54, 0), v1:new Vector3D(138, 99, 0)});
			
			//this.paper2D.paper.fold.push ({flag:false, v0:new Vector3D(219, 204, 0), v1:new Vector3D(67, 28, 0)});
			//this.paper2D.paper.fold.push ({flag:false, v0:new Vector3D(135, 97, 0), v1:new Vector3D(225, 226, 0)});
			//this.paper2D.paper.fold.push ({flag:false, v0:new Vector3D(249, 54, 0), v1:new Vector3D(138, 99, 0)});
			
			//this.paper2D.paper.fold.push ({flag:false, v0:new Vector3D(206, 187, 0), v1:new Vector3D(95, -30, 0)});
			//this.paper2D.paper.fold.push ({flag:false, v0:new Vector3D(135, 97, 0), v1:new Vector3D(225, 226, 0)});
			//this.paper2D.paper.fold.push ({flag:false, v0:new Vector3D(249, 54, 0), v1:new Vector3D(138, 99, 0)});
			
			//this.paper2D.paper.fold.push ({flag:false, v0:new Vector3D(173, 99, 0), v1:new Vector3D(100, 365, 0)});
			//this.paper2D.paper.fold.push ({flag:false, v0:new Vector3D(193, 4, 0), v1:new Vector3D(193, 4, 0)});
			
			//this.paper2D.paper.fold.push ({flag:false, v0:new Vector3D(303, 0, 0), v1:new Vector3D(11, 293, 0)});
			
			//this.paper2D.paper.fold.push ({flag:false, v0:new Vector3D(51, 115, 0), v1:new Vector3D(-79, 41, 0)});
			
			//this.paper2D.paper.fold.push ({flag:false, v0:new Vector3D(177, 178, 0), v1:new Vector3D(26, 29, 0)});
			
			//this.paper2D.paper.fold.push ({flag:false, v0:new Vector3D(173, 162, 0), v1:new Vector3D(35, 33, 0)});
			
			//this.paper2D.paper.fold.push ({flag:false, v0:new Vector3D(226, 287, 0), v1:new Vector3D(-9, 148, 0)});
			//this.paper2D.paper.fold.push ({flag:false, v0:new Vector3D(249, 54, 0), v1:new Vector3D(138, 99, 0)});
			
			//this.paper2D.paper.fold.push ({flag:false, v0:new Vector3D(115, 180, 0), v1:new Vector3D(-152, 117, 0)});
			
			//this.paper2D.paper.fold.push ({flag:false, v0:new Vector3D(196, 143, 0), v1:new Vector3D(50, 36, 0)});
			
			//this.paper2D.paper.fold.push ({flag:false, v0:new Vector3D(197, 165, 0), v1:new Vector3D(33, 28, 0)});
			
			//this.paper2D.paper.fold.push ({flag:false, v0:new Vector3D(203, 114, 0), v1:new Vector3D(67, 38, 0)});
			
			//this.paper2D.paper.fold.push ({flag:false, v0:new Vector3D(8, 11, 0), v1:new Vector3D(182, 182, 0)});
			
			//this.paper2D.paper.fold.push ({flag:false, v0:new Vector3D(225, 202, 0), v1:new Vector3D(66, 16, 0)});
			//this.paper2D.paper.fold.push ({flag:false, v0:new Vector3D(135, 97, 0), v1:new Vector3D(225, 226, 0)});
			//this.paper2D.paper.fold.push ({flag:false, v0:new Vector3D(249, 54, 0), v1:new Vector3D(138, 99, 0)});
			
			//this.paper2D.paper.fold.push ({flag:false, v0:new Vector3D(231, 233, 0), v1:new Vector3D(53, -16, 0)});
			//this.paper2D.paper.fold.push ({flag:false, v0:new Vector3D(135, 97, 0), v1:new Vector3D(225, 226, 0)});
			//this.paper2D.paper.fold.push ({flag:false, v0:new Vector3D(249, 54, 0), v1:new Vector3D(138, 99, 0)});
			
			//this.paper2D.paper.fold.push ({flag:false, v0:new Vector3D(0, 250, 0), v1:new Vector3D(0, -101, 0)});
			
			//this.paper2D.paper.fold.push ({flag:false, v0:new Vector3D(182, 51, 0), v1:new Vector3D(153, 0, 0)});
			//this.paper2D.paper.fold.push ({flag:false, v0:new Vector3D(180, 15, 0), v1:new Vector3D(185, 11, 0)});
			//this.paper2D.paper.fold.push ({flag:false, v0:new Vector3D(134, 16, 0), v1:new Vector3D(-6, 128, 0)});
			
			//this.paper2D.paper.fold.push ({flag:false, v0:new Vector3D(165, 175, 0), v1:new Vector3D(79, -55, 0)});
			//this.paper2D.paper.fold.push ({flag:false, v0:new Vector3D(135, 97, 0), v1:new Vector3D(225, 226, 0)});
			//this.paper2D.paper.fold.push ({flag:false, v0:new Vector3D(249, 54, 0), v1:new Vector3D(138, 99, 0)});
			
			//this.paper2D.paper.fold.push ({flag:false, v0:new Vector3D(191, 191, 0), v1:new Vector3D(27, 27, 0)});
			
			//this.paper2D.paper.fold.push ({flag:false, v0:new Vector3D(185, 15, 0), v1:new Vector3D(6, 194, 0)});
			
			//this.paper2D.paper.fold.push ({flag:false, v0:new Vector3D(199, 220, 0), v1:new Vector3D(199, 42, 0)});
			//this.paper2D.paper.fold.push ({flag:false, v0:new Vector3D(135, 97, 0), v1:new Vector3D(225, 226, 0)});
			//this.paper2D.paper.fold.push ({flag:false, v0:new Vector3D(249, 54, 0), v1:new Vector3D(138, 99, 0)});
			
			//this.paper2D.paper.fold.push ({flag:false, v0:new Vector3D(196, 196, 0), v1:new Vector3D(195, 37, 0)});
			//this.paper2D.paper.fold.push ({flag:false, v0:new Vector3D(135, 97, 0), v1:new Vector3D(225, 226, 0)});
			//this.paper2D.paper.fold.push ({flag:false, v0:new Vector3D(249, 54, 0), v1:new Vector3D(138, 99, 0)});
			
			//this.paper2D.paper.fold.push ({flag:true, v0:new Vector3D(4.2862637970157365e-15, 141, 0), v1:new Vector3D(4.2862637970157365e-15, 281, 0)});
			//this.paper2D.paper.fold.push ({flag:true, v0:new Vector3D(-122.5, 341.5, 0), v1:new Vector3D(48.5, 267.5, 0)});
			//this.paper2D.paper.fold.push ({flag:true, v0:new Vector3D(66, 149, 0), v1:new Vector3D(-139, 68, 0)});
			//this.paper2D.paper.fold.push ({flag:true, v0:new Vector3D(17, 383, 0), v1:new Vector3D(369, 31, 0)});
			//this.paper2D.paper.fold.push ({flag:true, v0:new Vector3D(385, 386, 0), v1:new Vector3D(11, 12, 0)});
			
			//this.paper2D.paper.fold.push ({flag:false, v0:new Vector3D(0, 144, 0), v1:new Vector3D(5, 253, 0)});
			//this.paper2D.paper.fold.push ({flag:true, v0:new Vector3D(-122.5, 341.5, 0), v1:new Vector3D(48.5, 267.5, 0)});
			//this.paper2D.paper.fold.push ({flag:true, v0:new Vector3D(66, 149, 0), v1:new Vector3D(-139, 68, 0)});
			//this.paper2D.paper.fold.push ({flag:true, v0:new Vector3D(17, 383, 0), v1:new Vector3D(369, 31, 0)});
			//this.paper2D.paper.fold.push ({flag:true, v0:new Vector3D(385, 386, 0), v1:new Vector3D(11, 12, 0)});
			
			//this.paper2D.paper.fold.push ({flag:false, v0:new Vector3D(1, 142, 0), v1:new Vector3D(7, 264, 0)});
			//this.paper2D.paper.fold.push ({flag:true, v0:new Vector3D(-122.5, 341.5, 0), v1:new Vector3D(48.5, 267.5, 0)});
			//this.paper2D.paper.fold.push ({flag:true, v0:new Vector3D(66, 149, 0), v1:new Vector3D(-139, 68, 0)});
			//this.paper2D.paper.fold.push ({flag:true, v0:new Vector3D(17, 383, 0), v1:new Vector3D(369, 31, 0)});
			//this.paper2D.paper.fold.push ({flag:true, v0:new Vector3D(385, 386, 0), v1:new Vector3D(11, 12, 0)});
			
			//this.paper2D.paper.fold.push ({flag:true, v0:new Vector3D(3.5000000000000036, 157.5, 0), v1:new Vector3D(0.5000000000000036, 271.5, 0)});
			//this.paper2D.paper.fold.push ({flag:true, v0:new Vector3D(-122.5, 341.5, 0), v1:new Vector3D(48.5, 267.5, 0)});
			//this.paper2D.paper.fold.push ({flag:true, v0:new Vector3D(66, 149, 0), v1:new Vector3D(-139, 68, 0)});
			//this.paper2D.paper.fold.push ({flag:true, v0:new Vector3D(17, 383, 0), v1:new Vector3D(369, 31, 0)});
			//this.paper2D.paper.fold.push ({flag:true, v0:new Vector3D(385, 386, 0), v1:new Vector3D(11, 12, 0)});
			
			//this.paper2D.paper.fold.push ({flag:false, v0:new Vector3D(-1, 116, 0), v1:new Vector3D(0, 283, 0)});
			//this.paper2D.paper.fold.push ({flag:true, v0:new Vector3D(-122.5, 341.5, 0), v1:new Vector3D(48.5, 267.5, 0)});
			//this.paper2D.paper.fold.push ({flag:true, v0:new Vector3D(66, 149, 0), v1:new Vector3D(-139, 68, 0)});
			//this.paper2D.paper.fold.push ({flag:true, v0:new Vector3D(17, 383, 0), v1:new Vector3D(369, 31, 0)});
			//this.paper2D.paper.fold.push ({flag:true, v0:new Vector3D(385, 386, 0), v1:new Vector3D(11, 12, 0)});
			
			//this.paper2D.paper.fold.push ({flag:false, v0:new Vector3D(-1, 139, 0), v1:new Vector3D(1, 261, 0)});
			//this.paper2D.paper.fold.push ({flag:true, v0:new Vector3D(-122.5, 341.5, 0), v1:new Vector3D(48.5, 267.5, 0)});
			//this.paper2D.paper.fold.push ({flag:true, v0:new Vector3D(66, 149, 0), v1:new Vector3D(-139, 68, 0)});
			//this.paper2D.paper.fold.push ({flag:true, v0:new Vector3D(17, 383, 0), v1:new Vector3D(369, 31, 0)});
			//this.paper2D.paper.fold.push ({flag:true, v0:new Vector3D(385, 386, 0), v1:new Vector3D(11, 12, 0)});
			
			//this.paper2D.paper.fold.push ({flag:false, v0:new Vector3D(200, 206, 0), v1:new Vector3D(200, 36, 0)});
			//this.paper2D.paper.fold.push ({flag:false, v0:new Vector3D(135, 97, 0), v1:new Vector3D(225, 226, 0)});
			//this.paper2D.paper.fold.push ({flag:false, v0:new Vector3D(249, 54, 0), v1:new Vector3D(138, 99, 0)});
			
			//this.paper2D.paper.fold.push ({flag:null, v0:new Vector3D(0, 0, 0), v1:new Vector3D(0, 0, 0)});
			//this.paper2D.paper.fold.push ({flag:true, v0:new Vector3D(235, 221, 0), v1:new Vector3D(40, -21, 0)});
			//this.paper2D.paper.fold.push ({flag:true, v0:new Vector3D(135, 97, 0), v1:new Vector3D(225, 226, 0)});
			//this.paper2D.paper.fold.push ({flag:true, v0:new Vector3D(249, 54, 0), v1:new Vector3D(138, 99, 0)});
			
			//this.paper2D.paper.fold.push ({flag:false, v0:new Vector3D(0, 141, 0), v1:new Vector3D(0, 261, 0)});
			//this.paper2D.paper.fold.push ({flag:true, v0:new Vector3D(-122.5, 341.5, 0), v1:new Vector3D(48.5, 267.5, 0)});
			//this.paper2D.paper.fold.push ({flag:true, v0:new Vector3D(66, 149, 0), v1:new Vector3D(-139, 68, 0)});
			//this.paper2D.paper.fold.push ({flag:true, v0:new Vector3D(17, 383, 0), v1:new Vector3D(369, 31, 0)});
			//this.paper2D.paper.fold.push ({flag:true, v0:new Vector3D(385, 386, 0), v1:new Vector3D(11, 12, 0)});
			
			//this.paper2D.paper.fold.push ({flag:false, v0:new Vector3D(-1, 377, 0), v1:new Vector3D(-1, 17, 0)});
			//this.paper2D.paper.fold.push ({flag:true, v0:new Vector3D(-122.5, 341.5, 0), v1:new Vector3D(48.5, 267.5, 0)});
			//this.paper2D.paper.fold.push ({flag:true, v0:new Vector3D(66, 149, 0), v1:new Vector3D(-139, 68, 0)});
			//this.paper2D.paper.fold.push ({flag:true, v0:new Vector3D(17, 383, 0), v1:new Vector3D(369, 31, 0)});
			//this.paper2D.paper.fold.push ({flag:true, v0:new Vector3D(385, 386, 0), v1:new Vector3D(11, 12, 0)});
			
			//this.paper2D.paper.fold.push ({flag:false, v0:new Vector3D(175, 175, 0), v1:new Vector3D(11, 11, 0)});
			
			//this.paper2D.paper.fold.push ({flag:null, v0:new Vector3D(0, 0, 0), v1:new Vector3D(0, 0, 0)});
			//this.paper2D.paper.fold.push ({flag:null, v0:new Vector3D(186, 184, 0), v1:new Vector3D(9, 8, 0)});
			
			//this.paper2D.paper.fold.push ({flag:null, v0:new Vector3D(0, 0, 0), v1:new Vector3D(0, 0, 0)});
			//this.paper2D.paper.fold.push ({flag:true, v0:new Vector3D(106, 177, 0), v1:new Vector3D(-163, 112, 0)});
			//this.paper2D.paper.fold.push ({flag:true, v0:new Vector3D(192, 192, 0), v1:new Vector3D(7, 7, 0)});
			
			//this.paper2D.paper.fold.push ({flag:null, v0:new Vector3D(0, 0, 0), v1:new Vector3D(0, 0, 0)});
			//this.paper2D.paper.fold.push ({flag:true, v0:new Vector3D(103, 175, 0), v1:new Vector3D(-156, 108, 0)});
			//this.paper2D.paper.fold.push ({flag:true, v0:new Vector3D(192, 192, 0), v1:new Vector3D(7, 7, 0)});
			
			//this.paper2D.paper.fold.push ({flag:null, v0:new Vector3D(0, 0, 0), v1:new Vector3D(0, 0, 0)});
			//this.paper2D.paper.fold.push ({flag:true, v0:new Vector3D(125, 188, 0), v1:new Vector3D(-158, 143, 0)});
			//this.paper2D.paper.fold.push ({flag:true, v0:new Vector3D(192, 192, 0), v1:new Vector3D(7, 7, 0)});
			
			//this.paper2D.paper.fold.push ({flag:null, v0:new Vector3D(0, 0, 0), v1:new Vector3D(0, 0, 0)});
			//this.paper2D.paper.fold.push ({flag:null, v0:new Vector3D(180, 180, 0), v1:new Vector3D(11, 11, 0)});
			
			//this.paper2D.paper.fold.push ({flag:null, v0:new Vector3D(0, 0, 0), v1:new Vector3D(0, 0, 0)});
			//this.paper2D.paper.fold.push ({flag:true, v0:new Vector3D(180, 20, 0), v1:new Vector3D(5, 195, 0)});
			
			//this.paper2D.paper.fold.push ({flag:null, v0:new Vector3D(0, 0, 0), v1:new Vector3D(0, 0, 0)});
			//this.paper2D.paper.fold.push ({flag:true, v0:new Vector3D(185, 185, 0), v1:new Vector3D(6, 5, 0)});
			
			//this.paper2D.paper.fold.push ({flag:true, v0:new Vector3D(10, 5, 0), v1:new Vector3D(189, 189, 0)});
			//this.paper2D.paper.fold.push ({flag:true, v0:new Vector3D(385, 386, 0), v1:new Vector3D(11, 12, 0)});
			
			//this.paper2D.paper.fold.push ({flag:null, v0:new Vector3D(0, 0, 0), v1:new Vector3D(0, 0, 0)});
			//this.paper2D.paper.fold.push ({flag:null, v0:new Vector3D(46, 46, 0), v1:new Vector3D(187, 187, 0)});
			//this.paper2D.paper.fold.push ({flag:true, v0:new Vector3D(190, 10, 0), v1:new Vector3D(2, 198, 0)});
			//this.paper2D.paper.fold.push ({flag:true, v0:new Vector3D(190, 190, 0), v1:new Vector3D(14, 14, 0)});
			
			//this.paper2D.paper.fold.push ({flag:null, v0:new Vector3D(0, 0, 0), v1:new Vector3D(0, 0, 0)});
			//this.paper2D.paper.fold.push ({flag:null, v0:new Vector3D(0, 137, 0), v1:new Vector3D(0, -90, 0)});
			
			//this.paper2D.paper.fold.push ({flag:null, v0:new Vector3D(0, 0, 0), v1:new Vector3D(0, 0, 0)});
			//this.paper2D.paper.fold.push ({flag:true, v0:new Vector3D(0, 384, 0), v1:new Vector3D(0, 13, 0)});
			//this.paper2D.paper.fold.push ({flag:true, v0:new Vector3D(168, 167, 0), v1:new Vector3D(26, 26, 0)});
			
			//this.paper2D.paper.fold.push ({flag:null, v0:new Vector3D(0, 0, 0), v1:new Vector3D(0, 0, 0)});
			//this.paper2D.paper.fold.push ({flag:true, v0:new Vector3D(1, 389, 0), v1:new Vector3D(0, 4, 0)});
			//this.paper2D.paper.fold.push ({flag:true, v0:new Vector3D(168, 167, 0), v1:new Vector3D(26, 26, 0)});
			
			//this.paper2D.paper.fold.push ({flag:null, v0:new Vector3D(0, 0, 0), v1:new Vector3D(0, 0, 0)});
			//this.paper2D.paper.fold.push ({flag:true, v0:new Vector3D(0, 351, 0), v1:new Vector3D(-2, 30, 0)});
			//this.paper2D.paper.fold.push ({flag:true, v0:new Vector3D(168, 167, 0), v1:new Vector3D(26, 26, 0)});
			
			//this.paper2D.paper.fold.push ({flag:null, v0:new Vector3D(0, 0, 0), v1:new Vector3D(0, 0, 0)});
			//this.paper2D.paper.fold.push ({flag:null, v0:new Vector3D(204, -128, 0), v1:new Vector3D(200, 200, 0)});
			
			//this.paper2D.paper.fold.push ({flag:null, v0:new Vector3D(0, 0, 0), v1:new Vector3D(0, 0, 0)});
			//this.paper2D.paper.fold.push ({flag:null, v0:new Vector3D(174, 174, 0), v1:new Vector3D(12, 12, 0)});
			
			//this.paper2D.paper.fold.push ({flag:true, v0:new Vector3D(200, 12, 0), v1:new Vector3D(199, 387, 0)});
			//this.paper2D.paper.fold.push ({flag:true, v0:new Vector3D(192, 8, 0), v1:new Vector3D(-2, 202, 0)});
			
			//this.paper2D.paper.fold.push ({flag:null, v0:new Vector3D(0, 0, 0), v1:new Vector3D(0, 0, 0)});
			//this.paper2D.paper.fold.push ({flag:true, v0:new Vector3D(200, 5, 0), v1:new Vector3D(203, 372, 0)});
			//this.paper2D.paper.fold.push ({flag:true, v0:new Vector3D(192, 8, 0), v1:new Vector3D(-2, 202, 0)});
			
			//this.paper2D.paper.fold.push ({flag:null, v0:new Vector3D(0, 0, 0), v1:new Vector3D(0, 0, 0)});
			//this.paper2D.paper.fold.push ({flag:null, v0:new Vector3D(211, 5, 0), v1:new Vector3D(167, -14, 0)});
			
			//this.addChild (this.paper2D);
			
			return this;
		}
		
		////////////////////////////////////////////////////////////////////////////////////////////////////
	}
}
