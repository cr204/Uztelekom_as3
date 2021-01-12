package com.uzbilling.model {

	public class TariffModel {
		public var t_id:String;
		public var inet_traffic:String;
		public var t_ammount:String;
		public var daily_amount:String;
		public var nightly_ammount:String;
		public var t_name:String;
		public var g_name:String;
		public var inet_speed:String;
		public var tasx_speed:String;
		public var traffic_world:String;
		public var traffic_tasix:String;
		public var daily_period:String;
		public var nightly_period:String;
		public var reserved:Boolean;
		
		public function TariffModel() {
			// constructor code
		}
		
		public function setObject(obj:Object):void {
			t_id = obj.t_id;
			inet_traffic = obj.inet_traffic;
			t_ammount = obj.t_ammount;
			daily_amount = obj.daily_amount;
			nightly_ammount = obj.nightly_ammount;
			t_name = obj.t_name;
			g_name = obj.g_name;
			inet_speed = obj.inet_speed;
			tasx_speed = obj.tasx_speed;
			traffic_world = obj.traffic_world;
			traffic_tasix = obj.traffic_tasix;
			daily_period = obj.daily_period;
			nightly_period = obj.nightly_period;
		}		
	}
	
}