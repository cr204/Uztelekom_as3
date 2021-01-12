package com.uzbilling.view {
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.net.URLLoader;
	import flash.net.URLRequestMethod;
	import com.uzbilling.events.PopUpEvent;
	import com.uzbilling.controller.NetworkManager;
	import com.uzbilling.controller.LanguageSettings;
	import com.uzbilling.controller.UserManager;
	
	public class PopUpLanguage extends PopUp {
		private var SERVER_PATH:String;
		
		public function PopUpLanguage() {
			// constructor code
		}
		
		override protected function init(e:Event):void {
			super.init(e);
			SERVER_PATH = NetworkManager.getInstance().SERVER;
			initScreenAssets();
		}

		
		override protected function deinit(e:Event):void {
			super.deinit(e);
		}
		
		override public function updateTexts(s1:String, s2:String):void {
			cont.tf1.text = s1;
		}
		
		private function initScreenAssets():void {
			screenBg.width = super.thisPageWidth;
			screenBg.height = super.thisPageHeight;
			
			cont.rb1.setText("O'zbekcha");
			cont.rb2.setText("Узбекча");
			cont.rb3.setText("Русский");
			selectLanguage();
			
			if(super.thisPageWidth<700 ||
			   super.thisPageWidth>800) {
				cont.scaleX = cont.scaleY = super.thisPageWidth / 720;
			}
			
			cont.x = Math.round((super.thisPageWidth - cont.width) * .5);
			this.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			this.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
		}
				
		private function selectLanguage():void {
			trace("selectLanguage: " + LanguageSettings.getInstance().getLangID());
			cont.rb1.selected(false);
			cont.rb2.selected(false);
			cont.rb3.selected(false);
			switch(LanguageSettings.getInstance().getLangID()) {
				case 0:
					cont.rb3.selected(true);
					break;
				case 1:
					cont.rb2.selected(true);
					break;
				case 2:
					cont.rb1.selected(true);
					break;
			}
		}
		
		private function mouseDownHandler(e:MouseEvent):void {
			var sel:String = e.target.name;
			if(sel=="rb1" || sel=="rb2" || sel=="rb3") {
				cont.rb1.selected(false);
				cont.rb2.selected(false);
				cont.rb3.selected(false);
				if(sel=="rb1") cont.rb1.selected(true);
				if(sel=="rb2") cont.rb2.selected(true);
				if(sel=="rb3") cont.rb3.selected(true);
			} else {
				this.dispatchEvent(new PopUpEvent(PopUpEvent.CLOSE));
			}
		}
		
		private function mouseUpHandler(e:MouseEvent):void {
			var sel:String = e.target.name;
			if(sel=="rb1" || sel=="rb2" || sel=="rb3") {
				if(sel=="rb1") LanguageSettings.getInstance().languageID(2);
				if(sel=="rb2") LanguageSettings.getInstance().languageID(1);
				if(sel=="rb3") LanguageSettings.getInstance().languageID(0);
				refreshData();
			}
		}
		
		private function refreshData():void {
			var url:String = SERVER_PATH + "pcmain?lc=" + getLang(LanguageSettings.getInstance().getLangID());
			var request:URLRequest = new URLRequest(url);
			request.method = URLRequestMethod.GET;
			
			trace("LANGIAGE: " + url);
			
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, loaderComleteHandler);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler, false, 0, true);
			
			try {
				urlLoader.load(request);
			} catch(err:Error) {
				trace(err);
			}
		}
		
		private function loaderComleteHandler(e:Event):void {
			trace("loaderComleteHandler()");
			var res:Object = JSON.parse(e.target.data);
			UserManager.getInstance().setUserDetails(res);
			//this.dispatchEvent(new RightMenuEvent(RightMenuEvent.PRESSED, "refresh"));
			this.dispatchEvent(new PopUpEvent(PopUpEvent.REFRESH));
			this.dispatchEvent(new PopUpEvent(PopUpEvent.CLOSE));
		}
		
		private function ioErrorHandler( e:IOErrorEvent ):void {
			trace("Connection Error...");
			//this.dispatchEvent(new PopUpEvent(PopUpEvent.POPUP, "no_connection"));
		}
		
		private function getLang(n:int):String {
			var ret:String;
			switch(n) {
				case 0:
					ret = "ru";
					break;
				case 1:
					ret = "uz";
					break;
				case 2:
					ret = "uzl";
					break;
			}
			return ret;
		}
		
	}
}