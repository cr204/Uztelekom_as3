package com.uzbilling.view {
	
	import com.uzbilling.events.PopUpEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.URLLoader;
	import flash.net.navigateToURL;
	
	
	public class PopUpOnlinePayment extends PopUp {
		
		
		public function PopUpOnlinePayment() {
			// constructor code
		}
		
		override protected function init(e:Event):void {
			super.init(e);
			initScreenAssets();
		}

		
		override protected function deinit(e:Event):void {
			super.deinit(e);
		}
		
		private function initScreenAssets():void {
			screenBg.width = super.thisPageWidth;
			screenBg.height = super.thisPageHeight;
			
			cont.title.text = ls.getData("pop.onlinePay");
			
			if(super.thisPageWidth<700 ||
			   super.thisPageWidth>800) {
				cont.scaleX = cont.scaleY = super.thisPageWidth / 720;
			}
			
			cont.x = Math.round((super.thisPageWidth - cont.width) * .5);
			this.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
		}
		
		private function mouseDownHandler(e:MouseEvent):void {
			var target:String = e.target.name;
			var url:String = "";
			
			trace("PopUpOnlinePayment: " + target);
			switch(target) {
				case "pay1":
					url = "http://www.uzcard.uz";
					break;
				case "pay2":
					url = "http://www.click.uz";
					break;
				case "pay3":
					url = "http://www.payme.uz";
					break;
				case "pay4":
					url = "http://www.mbank.uz";
					break;
				case "pay5":
					url = "http://www.upay.uz";
					break;
				case "screenBg":
					this.dispatchEvent(new PopUpEvent(PopUpEvent.CLOSE));
					break;
				default:
					//
					break;
			}
			
			if(url!="") {
				var urlReq = new URLRequest(url);
				try {
					navigateToURL(urlReq);
				} catch (e:Error) {
					trace("Error occured when connected!");
				}
				this.dispatchEvent(new PopUpEvent(PopUpEvent.CLOSE));
			}
		}
		
		
		
	}
}