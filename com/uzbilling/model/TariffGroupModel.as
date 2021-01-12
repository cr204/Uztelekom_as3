package com.uzbilling.model {

	public class TariffGroupModel {
		public var t_name:String;
		public var tariffArray:Array = [];
		
		public function TariffGroupModel() {
			// constructor code
		}
		
		public function setObject(obj:Object):void {
			t_name = obj.name;
			
			for each (var tm in obj.items) {
				var tempTM:TariffModel = new TariffModel()
				tempTM.setObject(tm);
				tariffArray.push(tempTM);
			}
		}		
	}
	
}