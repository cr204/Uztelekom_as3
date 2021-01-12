package com.uzbilling.events {
	
	import flash.events.Event;
	
	public class InfoCellEvent extends Event {
		public static const EXPANDED = "expanded";
		public static const DETAILED = "detailed";
		public static const SERVICE_ACTION = "serviceAction";
		public var serviceID:int = -1;
		public var serviceST:String = "";
		public var cellID:String = "-1";
		
		public function InfoCellEvent(evt:String, sID:int=-1, sST:String="", cID:String="-1"):void {
			super(evt);
			serviceID = sID;
			serviceST = sST;
			cellID = cID;
		}

	}
}