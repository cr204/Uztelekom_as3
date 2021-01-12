package com.uzbilling.model {
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.net.URLRequestMethod;
	import flash.net.URLLoader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.NetStatusEvent;
	import com.uzbilling.controller.NetworkManager;

	public class PhoneList {
		public static var DATA_ARRAY:Array = [];
		private static var selPhone:String = "";
		private static var instance:PhoneList;
		private static var allowInstance:Boolean;
		
		public function PhoneList() {
			if(!allowInstance) {
				throw new Error("Error: Use PhoneList.getInstance() instead of new keyword");
			}
		}
		
		public static function getInstance():PhoneList {
			if(instance == null) {
				allowInstance = true;
				instance = new PhoneList();
				allowInstance = false;
				return instance;
			} else {
				//trace("SelectList instance already exists");
			}
			return instance;
		}
		
		public function init(s:String):void {
			var tempArr:Array = s.split(", ");
			
			for(var i:int=0; i<tempArr.length; ++i) {
				var phone:Object = new Object();
				phone.ID = tempArr[i];
				phone.PER_NAME = tempArr[i];
				
				// NOTE: PopUpSelect.as da faqat Period model ishlatilgani uchun berda ham shuni ishlatisha majbur bo'ldim!
				var period:Period = new Period(phone);
				DATA_ARRAY.push(period);
			}
			selPhone = tempArr[0];
		}
		
		public function getPhoneList():Array {
			return DATA_ARRAY;
		}
		
		public function getPhoneID(i:Number=0):String {
			return DATA_ARRAY[i].PER_NAME;
		}
		
		public function setSelectedPhoneNumber(s:String):void {
			selPhone = s;
		}
		
		public function getSelectedPhoneNumber():String {
			if(selPhone=="") selPhone=getPhoneID(0);
			return selPhone
		}
		
	}
}