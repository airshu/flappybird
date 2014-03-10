package com.alonepig.utils
{
	import flash.media.Sound;

	public class SoundPlayer
	{
		[Embed(source="assets/sound/sound2.mp3")]
		private static var flapWingClass:Class;
		private static var flapWingSound:Sound;
		
		[Embed(source="assets/sound/sound3.mp3")]
		private static var passPipeClass:Class;
		private static var passPipeSound:Sound;
		
		
		[Embed(source="assets/sound/sound4.mp3")]
		private static var gameOverClass:Class;
		private static var gameOverSound:Sound;
		
		[Embed(source="assets/sound/sound5.mp3")]
		private static var backgroundClass:Class;
		private static var backgroundSound:Sound;
		
		public function SoundPlayer()
		{
		}
		
		public static function playFlapWing():void
		{
			if(!flapWingSound)
				flapWingSound = new flapWingClass();
			flapWingSound.play();
		}
		
		public static function playPassPipeSound():void
		{
			if(!passPipeSound)
				passPipeSound = new passPipeClass();
			passPipeSound.play();
		}
		
		public static function playGameOverSound():void
		{
			if(!gameOverSound)
				gameOverSound = new gameOverClass();
			gameOverSound.play();
		}
		
		public static function playBackgroundSound():void
		{
			if(!backgroundSound)
				backgroundSound = new backgroundClass();
			backgroundSound.play();
		}
		
	}
}