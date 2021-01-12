package com.uzbilling.events {
	
	import flash.events.Event;
	
	public class LanguageEvent extends Event {
		public static const CHANGED = "changed";

		public function LanguageEvent(evt:String):void {
			super(evt);
		}

	}
}