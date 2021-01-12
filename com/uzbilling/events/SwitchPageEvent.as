package com.uzbilling.events {
	
	import flash.events.Event;
	
	public class SwitchPageEvent extends Event {
		public static const SWITCHED = "switched";
		public static const SLIDED = "slided";
		public var pageID:String;

		public function SwitchPageEvent(evt:String, id:String):void {
			pageID = id;
			super(evt);
		}

	}
}