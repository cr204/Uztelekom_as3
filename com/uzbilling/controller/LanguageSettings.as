package com.uzbilling.controller {
	import com.uzbilling.model.UserDetails;
	import flash.net.SharedObject;
	import flash.net.SharedObjectFlushStatus;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.net.URLRequestMethod;
	import flash.net.URLLoader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.NetStatusEvent;
	import com.uzbilling.model.LanguageDetails;
	
	public class LanguageSettings {
		private static var instance:LanguageSettings;
		private static var allowInstance:Boolean;
		private static var languageDetails:LanguageDetails;
		private static var lID:int = 0;

		public function LanguageSettings() {
			// constructor code
			if(!allowInstance) {
				throw new Error("Error: Use LanguageSettings.getInstance() instead of new keyword");
			}
		}
		
		public static function getInstance():LanguageSettings {
			if(instance == null) {
				allowInstance = true;
				instance = new LanguageSettings();
				allowInstance = false;
				return instance;
			} else {
				//trace("LanguageSettings instance already exists");
			}
			return instance;
		}
		
		public function init():void {
			var file:String = NetworkManager.getInstance().langSettingsPath();
			var req:URLRequest = new URLRequest(file);
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, onSettingsLoaded);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler, false, 0, true);
			urlLoader.load(req);
		}
		
		public function languageID(n:int):void {
			lID = n;
		}
		
		public function getLangID():int {
			return lID;
		}
		
		public function getLangPfx():String {
			var ret:String;
			switch(lID) {
				case 0:
					ret = "ru";
					break;
				case 1:
					ret = "uz";
					break;
				case 2:
					ret = "uzl";
					break;
			}
			return ret;
		}
		
		public function getLangPrefix():String {
			var ret:String;
			switch(lID) {
				case 0:
					ret = "Ру";
					break;
				case 1:
					ret = "Уз";
					break;
				case 2:
					ret = "O'z";
					break;
			}
			return ret;
		}
		
		public function getData(key:String):String {
			return languageDetails.getData(key, lID);
		}
		
		private function onSettingsLoaded(e:Event):void {
			trace("LS.onSettingsLoaded: ");
			languageDetails = new LanguageDetails();
			languageDetails.setObject(e.target.data as String);
		}
		
		private function ioErrorHandler( e:IOErrorEvent ):void {
			trace("Error loading language Settings! Error: " + e.errorID);
		}

		
		
	}
}