package com.uzbilling.model {
	
	public class Globals {
		private static var instance:Globals;
		private static var allowInstance:Boolean;
		
		private static var _token:String = "";
		private static var _date_begin:String = "01.04.2018";
		private static var _date_end:String = "11.04.2018";
		private static var _currTarifID:String = "";
		private static var _reservedTarifID:String = "";
		
		public function Globals() {
			if(!allowInstance) {
				throw new Error("Error: use Globals.getInstance() instead of new keyword");
			}
		}
		
		public static function getInstance():Globals {
			if(instance == null) {
				allowInstance = true;
				instance = new Globals();
				allowInstance = false;
				//trace(":::: Globals instance created");
				return instance;
			} else {
				//trace("XMLSettings instance already exists");
			}
			return instance;
		}
		
		public function set token(s:String):void {
			_token = "Bearer " + s;
		}
		
		public function get token():String {
			return _token;
		}
		
		public function set date_begin(s:String):void {
			_date_begin = s;
		}
		
		public function get date_begin():String {
			return _date_begin;
		}
		
		public function set date_end(s:String):void {
			_date_end = s;
		}
		
		public function get date_end():String {
			return _date_end;
		}
		
		public function set tariff_id(s:String):void {
			_currTarifID = s;
		}
		
		public function get tariff_id():String {
			return _currTarifID;
		}
		
		public function set reservedTarifID(s:String):void {
			_reservedTarifID = s;
		}
		
		public function get reservedTarifID():String {
			return _reservedTarifID;
		}
	}
	
}