package com.uzbilling.controller {
	
	
	
	public class ScreenManager {
		private static var instance:ScreenManager;
		private static var allowInstance:Boolean;
		
		private static var screenWidth:Number;
		private static var screenHeight:Number;
		public static var deviceType:Number;
		public static var aspectRation:Number;
		
		public function ScreenManager() {
			// constructor code
			if(!allowInstance) {
				throw new Error("Error: use ScreenManager.getInstance() instead of new keyword");
			}
		}
		
		public static function getInstance():ScreenManager {
			if(instance == null) {
				allowInstance = true;
				instance = new ScreenManager();
				allowInstance = false;
				return instance;
			} else {
				//trace("ScreenManager instance already exists");
			}
			return instance;
		}
		
		public function setDeviceType(n:int):void {
			if(n==0) {
				aspectRation = 750;
			} else {
				aspectRation = 720;
			}
			deviceType = n;
		}
		
		
		public function setScreenSize(w:Number, h:Number):void {
			screenWidth = w;
			screenHeight = h;
		}
		
		public function getWidth():Number {
			return screenWidth;
		}
		
		public function getHeight():Number {
			return screenHeight;
		}
	}
}