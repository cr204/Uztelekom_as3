package com.uzbilling.model {

	public class Period extends Object{
		public var PER_NAME: String;
		public var ID:int;
		
		public function Period(obj:Object) {
			ID = obj.ID;
			PER_NAME = obj.PER_NAME;
		}
		
	}
}