package com.uzbilling.view {
	
	import com.uzbilling.events.PopUpEvent;
	import com.greensock.TweenLite;
	import com.greensock.easing.Quad;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import com.uzbilling.controller.NetworkManager;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import com.uzbilling.controller.LanguageSettings;
	import com.uzbilling.controller.ScreenManager;
	
	public class PopUpDetails extends PopUp {
		
		public function PopUpDetails() {
			// constructor code
		}
		
		override protected function init(e:Event):void {
			super.init(e);
			
			whiteBg.y = super.thisPageHeight;
			cont.alpha = 0;
			
			if(super.thisPageWidth<700 ||
			   super.thisPageWidth>800) {
				screenBg.width = super.thisPageWidth;
				screenBg.height = super.thisPageHeight;
				whiteBg.scaleY = super.thisPageWidth / ScreenManager.aspectRation;
				whiteBg.width = super.thisPageWidth - 40;
				cont.scaleX = cont.scaleY = super.thisPageWidth / ScreenManager.aspectRation;
			}
			
			slideBG();
			cont.title.text = LanguageSettings.getInstance().getData("tf.Detailed");
			cont.htmlTxt.htmlText = "HTML data <b>not</b> recieved yet!";
		}

		override protected function deinit(e:Event):void {
			super.deinit(e);
			this.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
		}
		
		override public function setHTMLData(s:String):void {
			trace("setHTMLData: " + s);
/*			if(ScreenManager.deviceType==1) {
				trace("convertHTMLtoText: " + convertHTMLtoText(s));
				cont.htmlTxt.text = convertHTMLtoText(s);
			} else {  */
				cont.htmlTxt.htmlText = s;
//			}
		}
		
		
		private function slideBG():void {
			TweenLite.to(whiteBg, .5, {y:40, ease:Quad.easeInOut});
			TweenLite.to(cont, .3, {alpha:1, delay:.5, onComplete: enableMouse});
		}
		
		private function enableMouse():void {
			stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			
		}
		
		private function mouseDownHandler(e:MouseEvent):void {
			if(e.target.name=="btnClose") hidePopUp();
//			if(e.target.name=="btnContact") navToURL();
		}
		
		private function hidePopUp():void {
			cont.alpha = 0;
			dispatchEvent(new PopUpEvent(PopUpEvent.CLOSE));
		}
		
		private function convertHTMLtoText(s:String):String {
			var pattern:RegExp = /<br\/>/g;
			var ret:String = s.replace(pattern, "\n");
			return ret;
		}
		
		
	}
}