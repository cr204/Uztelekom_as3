package com.uzbilling.events {
	
	import flash.events.Event;
	
	public class SliderInfoEvent extends Event {
		public static const SLIDED = "slided";
		public var pageID:int;

		public function SliderInfoEvent(evt:String, id:int):void {
			pageID = id;
			super(evt);
		}

	}
}