package com.uzbilling.model {
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.net.URLRequestMethod;
	import flash.net.URLLoader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.NetStatusEvent;
	import com.uzbilling.controller.NetworkManager;

	public class SelectList {
		public static var DATE_ARRAY:Array = []; //["01, 2017", "12, 2016", "11, 2016", "10, 2016", "09, 2016", "08, 2016", "07, 2016", "06, 2016", "05, 2016", "04, 2016", "03, 2016", 
		//										"02, 2016", "01, 2016", "12, 2015", "11, 2015", "10, 2015", "09, 2015", "08, 2015", "07, 2015"];
		private static var instance:SelectList;
		private static var allowInstance:Boolean;
		
		public function SelectList() {
			if(!allowInstance) {
				throw new Error("Error: Use LanguageSettings.getInstance() instead of new keyword");
			}
		}
		
		public static function getInstance():SelectList {
			if(instance == null) {
				allowInstance = true;
				instance = new SelectList();
				allowInstance = false;
				return instance;
			} else {
				//trace("SelectList instance already exists");
			}
			return instance;
		}
		
		public function init():void {
			var url:String = NetworkManager.getInstance().SERVER + "pcFltrList?gr_n=SUBSCR_MTY_TELL&sct_n=p_start_in2";
			var req:URLRequest = new URLRequest(url);
			var urlLoader:URLLoader = new URLLoader();
			
/*			var reqVars:URLVariables = new URLVariables();
			reqVars.gr_n = "SUBSCR_MTY_TELL";
			reqVars.sct_n = "p_start_in";
			
			req.data = reqVars;
			req.method = URLRequestMethod.POST;  */
			
			urlLoader.addEventListener(Event.COMPLETE, onListLoaded);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler, false, 0, true);
			urlLoader.load(req);
		}
		
		public function getLastPeriod():Period {
			return DATE_ARRAY[0];
		}
		
		public function getPenultPeriod():Period {
			return DATE_ARRAY[1];
		}
		
		private function onListLoaded(e:Event):void {
			trace("SelectList.onListLoaded: " + e.target.data as String);
			
			var res:Object = JSON.parse(e.target.data);
//			trace("Len: " + res.length);
//			trace(res[0].ID);
//			trace(res[0].PER_NAME);
			
			for(var obj:Object in res) {
				var per:Period = new Period(res[obj]);
				DATE_ARRAY.push(per);
//				trace(res[obj].ID + " - " + res[obj].PER_NAME);
			}
			
			
		}
		
		private function ioErrorHandler( e:IOErrorEvent ):void {
			trace("Error loading Filter list! Error: " + e.text);
		}
		
		
	}
}