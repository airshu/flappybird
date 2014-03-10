package
{
	import com.alonepig.model.ModelLocator;
	import com.alonepig.utils.LoaderUtil;
	import com.alonepig.utils.SoundPlayer;
	import com.alonepig.view.WaterPipe;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	[SWF(width="288", height="510")]
	public class FlappyBird extends Sprite
	{
		[Embed(source="assets/swf/bird.swf")]
		private var BirdClass:Class;
		
		[Embed(source="assets/swf/tap.swf")]
		private var TapClass:Class;
		[Embed(source="assets/swf/playbtn.swf")]
		private var PlayBtnClass:Class;
		private var playBtnUrl:String = "assets/image/playBtn.png";
		
		private var bird:MovieClip;
		private var tap:MovieClip;
		
		private var model:ModelLocator;
		
		private var backLayer:Sprite;
		
		private var animateLayer:Sprite;
		
		private var scoreText:TextField;
		private var score:int;
		
		private var isAllowed:Boolean;
		private var isReady:Boolean;//素材是否加载完毕
		private var iSPlaying:Boolean;
		public var vertSpeed:Number;//竖直方向的速度
		public var gravity:Number;// 重力加速度
		
		private var playButton:MovieClip;
		public var isFallen:Boolean;
		
		private var loaderUtil:LoaderUtil;
		private var allImageUrl:String = "assets/image/all.png";
		
		private var dayBackground:Bitmap;
		private var nightBackground:Bitmap;
		private var bottomBackground:Bitmap;
		
		public function FlappyBird()
		{
			addEventListener(Event.ADDED_TO_STAGE, onAddToStage);
		}
		
		private function onAddToStage(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddToStage);
				
			model = ModelLocator.getInstance();
			
			backLayer = new Sprite();
			addChild( backLayer );
			
			animateLayer = new Sprite();
			addChild( animateLayer );
			init();
			
			addEventListener(Event.ENTER_FRAME, tickTock);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, flapWing);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, flapWing);
		}
		
		private function init():void
		{
			loaderUtil = new LoaderUtil();
			loaderUtil.load(allImageUrl, loadAllImageComplete);
			
			bird = new BirdClass();
			bird.mouseEnabled = bird.mouseChildren = false;
			animateLayer.addChild( bird )
			bird.x = (stage.stageWidth-bird.width)/2 + 20;
			bird.y = (stage.stageHeight-bird.height)/2 + 80;
			
			tap = new TapClass();
			tap.mouseEnabled = tap.mouseChildren = false;
			animateLayer.addChild(tap);
			tap.x = (stage.stageWidth-tap.width)/2;
			tap.y = (stage.stageHeight-tap.height)/2-20;
			
			playButton = new PlayBtnClass();
			animateLayer.addChild(playButton);
			playButton.x = (stage.stageWidth-tap.width)/2;
			playButton.y = (stage.stageHeight-tap.height)/2+120;	
			playButton.addEventListener( MouseEvent.CLICK, onPlayClick);
			
			for (var i:int = 1; i <= 3; i++) 
			{
				var wp:WaterPipe = new WaterPipe();
				pipes.push( wp );
				animateLayer.addChildAt(wp, 0);
				wp.x = model.BACKGROUND_WIDTH + pipes.length*100;
			}
			
		}
		
		private function flapWing(event:Event):void
		{
			if(isAllowed)
			{
				if(iSPlaying)
				{
					vertSpeed = -5;
					SoundPlayer.playFlapWing();
				}
			}
		}
		
		private function resetGame():void
		{
			playButton.visible = false;
			vertSpeed = 0;
			gravity = 0.6;
			score = 0;
			bird.x = 159;
			bird.y = 240;
			bird.rotation = 0;
			playButton.visible = false;
			tap.visible = false;
			isAllowed = true;
			iSPlaying = true;
			
			startPip();
			
			if(Math.random()*10>5)
			{
				dayBackground.visible = true;
				nightBackground.visible = false;
			}
			else
			{
				dayBackground.visible = false;
				nightBackground.visible = true;
			}
		}
		
		private function startPip():void
		{
			for (var i:int = 0; i < pipes.length; i++) 
			{
				pipes[i].x = model.BACKGROUND_WIDTH + (i+1)*162;
			}
		}
		
		private var pipes:Array = [];
		private var horizontalSpeed:Number = 3;
		
		public function tickTock(event:Event):void
		{
			if(!isAllowed || !iSPlaying)
			{
				return;
			}

			if(bird.y>=model.BACKGROUND_TOP_HEIGHT-30)
			{
				gameOver();
			}
			
			vertSpeed += gravity;
			bird.y += vertSpeed;
			
			if(vertSpeed>0)
			{
				bird.rotation = 60;
			}
			else 
			{
				bird.rotation = -45;
			}
			
			var index:int = 0;
			var wp:WaterPipe;
			while(index < animateLayer.numChildren)
			{
				if(animateLayer.getChildAt(index) is WaterPipe)
				{
					wp = animateLayer.getChildAt(index) as WaterPipe;
					if(wp.x < -52)
					{
						wp.refresh();
						wp.x = 424;
					}
					else
					{
						wp.x -= horizontalSpeed;
						index++;
						
						if(wp.x < bird.x && !wp.isPass)
						{
							wp.isPass = true;
							score++;
							scoreText.text = String(score);
							SoundPlayer.playPassPipeSound();
						}
						
						if(wp.topPipe.hitTestPoint(bird.x, bird.y) || wp.bottomPipe.hitTestPoint(bird.x, bird.y))
						{
							gameOver();
						}
					}
				}
				else
					index++;
			}
		}
		
		private function loadAllImageComplete(loader:Loader):void
		{
			var day_btmd:BitmapData = new BitmapData(model.BACKGROUND_WIDTH, model.BACKGROUND_TOP_HEIGHT);
			day_btmd.draw(loader.content, null, null, null, new Rectangle(0, 0, model.BACKGROUND_WIDTH, model.BACKGROUND_TOP_HEIGHT));
			dayBackground = new Bitmap(day_btmd);
			backLayer.addChild( dayBackground );
			
			var night_btmd:BitmapData =  new BitmapData(model.BACKGROUND_WIDTH, model.BACKGROUND_TOP_HEIGHT);
			night_btmd.draw(loader.content, new Matrix(1,0,0,1,-model.BACKGROUND_WIDTH-4,0), null, null);
			nightBackground = new Bitmap(night_btmd);
			backLayer.addChild( nightBackground );
			
			var bottom_btmd:BitmapData = new BitmapData(model.BACKGROUND_WIDTH, model.BACKGROUND_BOTTOM_HEIGHT);
			bottom_btmd.draw( loader.content, new Matrix(1,0,0,1,-model.BACKGROUND_WIDTH*2-8, 0) );
			bottomBackground = new Bitmap(bottom_btmd);
			backLayer.addChild( bottomBackground );
			bottomBackground.y = model.BACKGROUND_TOP_HEIGHT;
			
			scoreText = new TextField();
			backLayer.addChild( scoreText );
			scoreText.x = 10;
			scoreText.y = 10;
			scoreText.text = String(score);
		}
		
		
		private function onPlayClick(event:Event):void
		{
			resetGame();	
		}	
		
		private function gameOver():void
		{
			SoundPlayer.playGameOverSound();
			playButton.visible = true;
			iSPlaying = false;
		}
	}
}