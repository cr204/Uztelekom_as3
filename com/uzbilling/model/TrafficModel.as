package com.uzbilling.model {

	public class TrafficModel {
		public var vol_used_inet:String;
		public var vol_cost_inet:String;
		public var ordered:String;
		public var vol_used_tasx:String;
		public var interval_time:String;
		public var service_name:String;
		public var day_date:String;
		public var mac_address:String;
		private var rex:RegExp = /[\s\r\n]+/gim;
		
		public function TrafficModel() {
			// constructor code
		}
		
		public function setObject(obj:Object):void {
			vol_used_inet = obj.VOL_USED_INET.replace(rex,'');
			vol_cost_inet = obj.VOL_COST_INET.replace(rex,'');
			ordered = obj.ORDERED;
			vol_used_tasx = obj.VOL_USED_TASX.replace(rex,'');
			interval_time = obj.INTERVAL_TIME.replace(rex,'');
			service_name = obj.SERVISE_NAME;
			day_date = obj.DAY_DATE.replace(rex,'');
			mac_address = obj.MAC_ADDRESS;
		}		
	}
	
}