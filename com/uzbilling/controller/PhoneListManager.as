package com.uzbilling.controller {
	
	public class PhoneListManager {
		private static var instance:PhoneListManager;
		private static var allowInstance:Boolean;

		private static var phoneList:Array;
		
		public function PhoneListManager() {
			// constructor code
			if(!allowInstance) {
				throw new Error("Error: use PhoneListManager.getInstance() instead of new keyword");
			}
		}
		
		public static function getInstance():PhoneListManager {
			if(instance == null) {
				allowInstance = true;
				instance = new PhoneListManager();
				allowInstance = false;
				return instance;
			} else {
				//trace("UserManager instance already exists");
			}
			return instance;
		}
		
		public function init(s:String):void {
//			s = s.slice(1, s.length-1);
			phoneList = s.split(", ");
			trace("PhoneListManager.init: " + phoneList[0]);
		}
		
		public function getPhoneList():Array {
			return phoneList;
		}
		
		public function getPhoneID(i:Number=0):String {
			return phoneList[i];
		}
		
		
		
		
	}
}