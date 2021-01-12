package com.uzbilling.model {

	public class TariffHistoryModel {
		public var service_name:String;
		public var state_name:String;
		public var state:String;
		public var cmd_send_date:String;
		public var tf_date_beg:String;
		public var tf_date_end:String;
		
		public function TariffHistoryModel() {
			// constructor code
		}
		
		public function setObject(obj:Object):void {
			service_name = obj.service_name;
			state_name = obj.state_name;
			state = obj.state;
			cmd_send_date = obj.cmd_send_date;
			tf_date_beg = obj.tf_date_beg;
			tf_date_end = obj.tf_date_end;
		}		
	}
	
}