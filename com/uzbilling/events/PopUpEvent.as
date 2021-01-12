package com.uzbilling.events {
	
	import flash.events.Event;
	
	public class PopUpEvent extends Event {
		public static const POPUP = "popUp";
		public static const REFRESH = "refresh";
		public static const CLOSE = "close";
		public var popUpID:String;

		public function PopUpEvent(evt:String, id:String=""):void {
			popUpID = id;
			super(evt);
		}

	}
}