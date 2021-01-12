package com.uzbilling.events {
	
	import flash.events.Event;
	
	public class RightMenuEvent extends Event {
		public static const OPENED = "opened";
		public static const CLOSED = "closed";
		public static const PRESSED = "pressed";
		public var menuID:String;

		public function RightMenuEvent(evt:String, id:String=""):void {
			menuID = id;
			super(evt);
		}

	}
}