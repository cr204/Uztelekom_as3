package com.uzbilling.model {
	import flash.utils.Dictionary;

	public class LanguageDetails {
		private var dataDict = new Dictionary();
		
		public function LanguageDetails() {
			// constructor code
		}
		
		public function setObject(obj:String):void {
			var dataArr:Array = obj.split('\n');
			//trace("LanguageDetails: \n" + dataArr[0]);
			//trace("Lang:");
			for (var i:int=0; i<dataArr.length; i++) {
				var str:String = dataArr[i];
				//var key:String = String(dataArr[i]).index(":");
				//trace(str.indexOf(":"));
				//trace(str.slice(0, str.indexOf(":")) + " ---->   " + str.slice(str.indexOf(":") + 1, str.length));
				dataDict[str.slice(0, str.indexOf(":"))] = str.slice(str.indexOf(":") + 2, str.length);
			}
			trace(dataDict["mn.tf1"]);
		}
		
		public function getData(key:String, ln:int):String {
			var tmpArr:Array = String(dataDict[key]).split(", ");
			return tmpArr[ln].toString();
		}
		
		
	}
	
}