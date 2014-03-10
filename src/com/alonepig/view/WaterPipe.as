package com.alonepig.view
{
	import com.alonepig.model.ModelLocator;
	import com.alonepig.utils.LoaderUtil;
	import com.alonepig.utils.Scale9GridBitmap;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.Sprite;

	public class WaterPipe extends Sprite
	{
		public var topPipe:Scale9GridBitmap;
		
		public var bottomPipe:Scale9GridBitmap;
		
		private var topPipImgUrl:String = "assets/image/toppipe.png";
		private var bottomPipImgUrl:String = "assets/image/bottompipe.png";
		
		
		[Embed(source="assets/image/toppipe.png")]
		public var TopPipeClass:Class; 
		
		[Embed(source="assets/image/bottompipe.png")]
		public var BottomPipeClass:Class;
		
		private var model:ModelLocator;
		
		private var space:int = 100;
		
		private var respon:Function;
		
		public var isPass:Boolean;
		
		
		public function WaterPipe(_respon:Function=null)
		{
			respon = _respon;
			
			model = ModelLocator.getInstance();
			
			var loader1:LoaderUtil = new LoaderUtil();
			loader1.load(topPipImgUrl, onTopPipeLoadComplete);
			
			var loader2:LoaderUtil = new LoaderUtil();
			loader2.load(bottomPipImgUrl, onBottomPipeLoadComplete);
		}
		
		private function onTopPipeLoadComplete(loader:Loader):void
		{
			topPipe = new Scale9GridBitmap();
			topPipe.sourceBitmapData = Bitmap(loader.content).bitmapData;
			addChild( topPipe );
			
			
			refresh();
		}
		
		private function onBottomPipeLoadComplete(loader:Loader):void
		{
			bottomPipe = new Scale9GridBitmap();
			bottomPipe.sourceBitmapData = Bitmap(loader.content).bitmapData;
			addChild( bottomPipe );
			
			refresh();
		}
		
		public function refresh():void
		{
			if(!topPipe || !bottomPipe)
				return;
			
			var h:Number = int(Math.random()*250);
			
			topPipe.height = h;
			
			bottomPipe.height = model.BACKGROUND_TOP_HEIGHT-h-space;
			
			bottomPipe.y = model.BACKGROUND_TOP_HEIGHT-bottomPipe.height;
			
			if(respon != null)
				respon();
		}
		
	}
}