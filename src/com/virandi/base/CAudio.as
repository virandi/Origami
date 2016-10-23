
package com.virandi.base
{
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundMixer;
	import flash.media.SoundTransform;
	import flash.utils.Dictionary;
	
	public class CAudio
	{
		////////////////////////////////////////////////////////////////////////////////////////////////////
		
		static public const PLAY_FOREVER:int = int.MAX_VALUE;
		
		static public const STATE_MUTE:int = 0;
		
		static public const STATE_OFF:int = 1;
		
		static public const STATE_ON:int = 2;
		
		////////////////////////////////////////////////////////////////////////////////////////////////////
		
		static public var instance:CAudio = null;
		
		static public function get Instance () : CAudio
		{
			return (CAudio.instance = ((CAudio.instance == null) ? new CAudio () : CAudio.instance));
		}
		
		////////////////////////////////////////////////////////////////////////////////////////////////////
		
		public var dictionary:Dictionary = null;
		
		public var state:int = 0;
		
		////////////////////////////////////////////////////////////////////////////////////////////////////
		
		public function CAudio ()
		{
			super ();
		}
		
		////////////////////////////////////////////////////////////////////////////////////////////////////
		
		public function DeInitialize () : CAudio
		{
			this.state = CAudio.STATE_OFF;
			
			this.dictionary = null;
			
			return this;
		}
		
		public function Initialize () : CAudio
		{
			this.dictionary = new Dictionary (false);
			
			this.state = CAudio.STATE_ON;
			
			return this;
		}
		
		////////////////////////////////////////////////////////////////////////////////////////////////////
		
		public function Play (sound:Sound, loop:int) : CAudio
		{
			if (sound == null)
			{
			}
			else
			{
				if (this.dictionary [sound] == null)
				{
					this.dictionary [sound] = {loop:loop, pause:false, play:true, position:0.0, sound:sound, soundChannel:sound.play (0.0, loop, SoundMixer.soundTransform)};
				}
			}
			
			return this;
		}
		
		public function Pause (sound:Sound) : CAudio
		{
			if (sound == null)
			{
			}
			else
			{
				if (this.dictionary [sound] == null)
				{
				}
				else
				{
					this.dictionary [sound].pause = true;
					this.dictionary [sound].position = this.dictionary [sound].soundChannel.position;
					
					this.dictionary [sound].soundChannel.stop ();
				}
			}
			
			return this;
		}
		
		public function Resume (sound:Sound) : CAudio
		{
			if (sound == null)
			{
			}
			else
			{
				if (this.dictionary [sound] == null)
				{
				}
				else
				{
					if (this.dictionary [sound].pause == false)
					{
					}
					else
					{
						this.dictionary [sound].pause = false;
						
						this.dictionary [sound].soundChannel = sound.play (this.dictionary [sound].position, this.dictionary [sound].loop, SoundMixer.soundTransform);
					}
				}
			}
			
			return this;
		}
		
		public function Stop (sound:Sound) : CAudio
		{
			if (sound == null)
			{
			}
			else
			{
				if (this.dictionary [sound] == null)
				{
				}
				else
				{
					this.dictionary [sound].play = false;
					this.dictionary [sound].position = 0.0;
					
					this.dictionary [sound].soundChannel.stop ();
				}
				
				this.dictionary [sound] = null;
			}
			
			return this;
		}
		
		////////////////////////////////////////////////////////////////////////////////////////////////////
		
		public function State (state:int) : CAudio
		{
			var object:Object = null;
			
			this.state = state;
			
			for each (object in this.dictionary)
			{
				if (object.play == false)
				{
				}
				else
				{
					if ((this.state == CAudio.STATE_MUTE) || (this.state == CAudio.STATE_OFF))
					{
						this.Pause (object.sound);
					}
					else if (this.state == CAudio.STATE_ON)
					{
						this.Resume (object.sound);
					}
				}
			}
			
			return this;
		}
		
		////////////////////////////////////////////////////////////////////////////////////////////////////
	}
}
