package com.uzbilling.events {
	
	import flash.events.Event;
	import com.uzbilling.model.Period;
	
	public class RadioButtonEvent extends Event {
		public static const SELECTED = "selected";
		public var selectPeriod:Period;

		public function RadioButtonEvent(evt:String, per:Period):void {
			selectPeriod = per;
			super(evt);
		}
	}
}