package com.uzbilling.events {
	
	import flash.events.Event;
	
	public class TopSliderEvent extends Event {
		public static const SELECTED = "selected";
		public static const SHOWED = "showed";
		public static const CLOSED = "closed";
		public var selectID:String;

		public function TopSliderEvent(evt:String, id:String):void {
			selectID = id;
			super(evt);
		}

	}
}