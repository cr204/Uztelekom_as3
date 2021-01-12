package com.uzbilling.events {
	
	import flash.events.Event;
	
	public class NetworkDataEvent extends Event {
		public static const LOADED = "loaded";
		public static const ERROR = "error";
		public var dataType:String;

		public function NetworkDataEvent(evt:String, dt:String):void {
			dataType = dt;
			super(evt);
		}

	}
}