package com.alonepig.utils
{
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;

	public class LoaderUtil
	{
		private var respon:Function;
		
		public function LoaderUtil()
		{
		}
		
		public function load(url:String, _respon:Function):void
		{
			respon = _respon;
			var loader:Loader = new Loader();
			loader.mouseChildren = loader.mouseEnabled = false;
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			loader.load( new URLRequest(url) );
		}
		
		private function onIOError(event:IOErrorEvent):void
		{
			trace("error");
		}
		
		private function onComplete(event:Event):void
		{
			var loaderInfo:LoaderInfo = event.target as LoaderInfo;
			loaderInfo.loader.mouseEnabled = false;  
			if(respon != null && loaderInfo.content)
				respon(loaderInfo.loader);
		}
		
		
	}
}