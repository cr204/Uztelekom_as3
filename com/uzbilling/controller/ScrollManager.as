package com.uzbilling.controller {
	
	public class ScrollManager {
		private static var instance:ScrollManager;
		private static var allowInstance:Boolean;
		public static var scrolled:Boolean = false;
		
		public function ScrollManager() {
			// constructor code
			if(!allowInstance) {
				throw new Error("Error: use ScreenManager.getInstance() instead of new keyword");
			}
		}
		
		public static function getInstance():ScrollManager {
			if(instance == null) {
				allowInstance = true;
				instance = new ScrollManager();
				allowInstance = false;
				return instance;
			} else {
				//trace("ScrollManager instance already exists");
			}
			return instance;
		}
		
	}
}