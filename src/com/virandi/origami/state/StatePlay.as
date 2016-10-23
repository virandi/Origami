
package com.virandi.origami.state
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TouchEvent;
	
	import com.virandi.base.CState;
	import com.virandi.base.IHandleEvent;
	import com.virandi.base.IRender;
	import com.virandi.base.IState;
	import com.virandi.base.IUpdate;
	import com.virandi.origami.core.Level;
	import com.virandi.origami.core.Shape;
	import com.virandi.origami.render.Paper2D;
	
	public class StatePlay extends CState
	{
		////////////////////////////////////////////////////////////////////////////////////////////////////
		
		static public var instance:StatePlay = null;
		
		static public function get Instance () : StatePlay
		{
			return (StatePlay.instance = ((StatePlay.instance == null) ? new StatePlay () : StatePlay.instance));
		}
		
		////////////////////////////////////////////////////////////////////////////////////////////////////
		
		public var paper2D:Paper2D = null;
		
		////////////////////////////////////////////////////////////////////////////////////////////////////
		
		public function StatePlay ()
		{
			super ();
			
			this.paper2D = new Paper2D ();
			
			this.gui.displayObjectContainer = null;
		}
		
		////////////////////////////////////////////////////////////////////////////////////////////////////
		
		override public function HandleEvent (event:Event) : IHandleEvent
		{
			super.HandleEvent (event);
			
			return this;
		}
		
		////////////////////////////////////////////////////////////////////////////////////////////////////
		
		override public function Render () : IRender
		{
			super.Render ();
			
			return this;
		}
		
		////////////////////////////////////////////////////////////////////////////////////////////////////
		
		override public function DeInitialize () : IState
		{
			if (Main.Instance.level.select.SCORE < Main.Instance.level.select.STAR [0])
			{
			}
			else
			{
				if ((DB.Instance.CACHE_RECORD [Main.Instance.level.select.ID] == null) || (DB.Instance.CACHE_RECORD [Main.Instance.level.select.ID] == undefined))
				{
					DB.Instance.CACHE_RECORD [Main.Instance.level.select.ID] = {LEVEL_ID:null, SCORE:0.0};
				}
				
				DB.Instance.CACHE_RECORD [Main.Instance.level.select.ID].LEVEL_ID = Main.Instance.level.select.ID;
				DB.Instance.CACHE_RECORD [Main.Instance.level.select.ID].SCORE = Math.max (DB.Instance.CACHE_RECORD [Main.Instance.level.select.ID].SCORE, Main.Instance.level.select.SCORE);
				
				DB.Instance.Flush ();
			}
			
			this.paper2D.Destroy ();
			
			super.DeInitialize ();
			
			return this;
		}
		
		override public function Initialize () : IState
		{
			super.Initialize ();
			
			this.paper2D = this.paper2D.Create (Library.Instance.dictionary [Library.IMAGE_VIRANDI_STUDIO].bitmapData,
												Library.Instance.dictionary [Library.IMAGE_VIRANDI_STUDIO].bitmapData,
												Main.Instance.level.play.Create (Main.Instance.level.select.ID, Main.Instance.level.select.FOLD, Main.Instance.level.select.VERTEX),
												{height:400.0, width:400.0});
			
			this.paper2D.alpha = 0.9;
			this.paper2D.x = ((Main.Instance.Width * 0.5) - (this.paper2D.Width * 0.5));
			this.paper2D.y = ((Main.Instance.Height * 0.5) - (this.paper2D.Height * 0.5));
			
			this.addChild (this.paper2D);
			
			return this;
		}
		
		override public function Pause () : IState
		{
			super.Pause ();
			
			return this;
		}
		
		override public function Resume () : IState
		{
			super.Resume ();
			
			return this;
		}
		
		////////////////////////////////////////////////////////////////////////////////////////////////////
		
		override public function Update () : IUpdate
		{
			super.Update ();
			
			return this;
		}
		
		////////////////////////////////////////////////////////////////////////////////////////////////////
	}
}
