package com.uzbilling.view {
	
	import com.uzbilling.events.PopUpEvent;
	import com.greensock.TweenLite;
	import com.greensock.easing.Quad;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import com.uzbilling.controller.NetworkManager;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import com.uzbilling.controller.ScreenManager;
	
	public class PopUpAbout extends PopUp {
		
		
		public function PopUpAbout() {
			// constructor code
		}
		
		override protected function init(e:Event):void {
			super.init(e);
			whiteBg.y = super.thisPageHeight;
			cont.alpha = 0;
			
			if(super.thisPageWidth<700 ||
			   super.thisPageWidth>800) {
				bg.width = super.thisPageWidth;
				bg.height = super.thisPageHeight;
				whiteBg.scaleX = whiteBg.scaleY = super.thisPageWidth /ScreenManager.aspectRation;
				cont.scaleX = cont.scaleY = super.thisPageWidth / ScreenManager.aspectRation;
			}
			
			slideBG();
		}

		override protected function deinit(e:Event):void {
			super.deinit(e);
			this.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
		}
		
		private function navToURL():void {
			var url:String = NetworkManager.getInstance().ZAYAVKA_URL;
			trace("navToURL: " + url);
			
			var urlReq = new URLRequest(url);
			try {
				navigateToURL(urlReq);
			} catch (e:Error) {
				trace("Error occured when connected!");
			}
		}
		
		
		private function slideBG():void {
			TweenLite.to(whiteBg, .5, {y:40, ease:Quad.easeInOut});
			TweenLite.to(cont, .3, {alpha:1, delay:.5, onComplete: enableMouse});
		}
		
		private function enableMouse():void {
			stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
		}
		
		private function mouseDownHandler(e:MouseEvent):void {
			trace("About.MouseDown: " + e.target.name);
			if(e.target.name=="btnClose") hidePopUp();
			if(e.target.name=="btnContact") navToURL();
		}
		
		private function hidePopUp():void {
			cont.alpha = 0;
			dispatchEvent(new PopUpEvent(PopUpEvent.CLOSE));
		}
	}
}