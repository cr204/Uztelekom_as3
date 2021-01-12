package com.uzbilling.events {
	
	import flash.events.Event;
	
	public class SlidePageEvent extends Event {
		public static const SLIDED_SWITCH = "slidedSwitch";
		public var pageID:String;

		public function SlidePageEvent(evt:String, id:String):void {
			pageID = id;
			super(evt);
		}

	}
}