package com.alonepig.model
{
	public class ModelLocator
	{
		/**
		 * 舞台宽 
		 */		
		public var BACKGROUND_WIDTH:int = 288;
		/**
		 * 舞台高 
		 */		
		public var BACKGROUND_TOP_HEIGHT:int = 400;
		
		public var BACKGROUND_BOTTOM_HEIGHT:int = 110;
		
		private static var instance:ModelLocator;
		
		public function ModelLocator()
		{
		}
		
		public static function getInstance():ModelLocator
		{
			if(!instance)
				instance = new ModelLocator();
			return instance;
		}
	}
}