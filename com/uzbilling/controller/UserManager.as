package com.uzbilling.controller {
	import com.uzbilling.model.UserDetails;
	import com.uzbilling.model.PhoneList;
	import flash.net.SharedObject;
	import flash.net.SharedObjectFlushStatus;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.net.URLRequestMethod;
	import flash.net.URLLoader;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.NetStatusEvent;
	
	public class UserManager {
		private static var instance:UserManager;
		private static var allowInstance:Boolean;

		private static var userDetails:UserDetails;
		
		public function UserManager() {
			// constructor code
			if(!allowInstance) {
				throw new Error("Error: use UserManager.getInstance() instead of new keyword");
			}
		}
		
		public static function getInstance():UserManager {
			if(instance == null) {
				allowInstance = true;
				instance = new UserManager();
				allowInstance = false;
				return instance;
			} else {
				//trace("UserManager instance already exists");
			}
			return instance;
		}
		
		public function init():void {
			//
		}
		
		public function setUserDetails(obj:Object):void {
			if(!userDetails) {
				userDetails = new UserDetails();
			}
			userDetails.setObject(obj);
			//PhoneList.getInstance().init(obj.tell_list);
		}
		
		public function setMacAdress(s:String):void {
			if(!userDetails) {
				userDetails = new UserDetails();
			}
			userDetails.macAddress = s;
		}
		
		public function getMacAdress():String {
			return userDetails.macAddress;
		}
		
		public function getUserDetails():UserDetails {
			return userDetails;
		}
				
		public function checkCurrentUser():UserDetails {
			return userDetails;
		}
		
		
		
	}
}