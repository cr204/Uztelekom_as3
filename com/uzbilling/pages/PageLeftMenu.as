package com.uzbilling.pages {
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import com.uzbilling.events.SlidePageEvent;
	import com.uzbilling.controller.ScreenManager;
	
	public class PageLeftMenu extends Page {
		private var TEXT_SPACING:Number = 100;
		
		public function PageLeftMenu() {
			// constructor code
		}
		
		override protected function init(e:Event):void {
			super.init(e);
			this.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			initScreenAssets();
		}

		
		override protected function deinit(e:Event):void {
			super.deinit(e);
		}
		
		public function initScreenAssets():void {
			screenBg.width = super.thisPageWidth;
			screenBg.height = super.thisPageHeight;
			
			tf1.txt.text = ls.getData("mn1.tf1");
			tf2.txt.text = ls.getData("mn1.tf2");
			tf3.txt.text = ls.getData("mn1.tf3");
			tf4.txt.text = ls.getData("mn1.tf4");
			tf5.txt.text = ls.getData("mn.tf5");
			tf6.txt.text = ls.getData("mn.tf6");
			
			tf1.mouseChildren = false;
			tf2.mouseChildren = false;
			tf3.mouseChildren = false;
			tf4.mouseChildren = false;
			tf5.mouseChildren = false;
			tf6.mouseChildren = false;
			
			if(super.thisPageWidth<700 ||
			   super.thisPageWidth>800) {
				   
				var LEFT_PADDING:Number = 45;
				   
				if(super.thisPageWidth<700) {
					TEXT_SPACING = 10;
					LEFT_PADDING = 20;
				} else {
					TEXT_SPACING = 35;
				}
				
				var ratio:Number = super.thisPageWidth / ScreenManager.aspectRation
				
				if(super.thisPageWidth<700) tf5.y = 50 else tf5.y = 100;
				tf5.x = LEFT_PADDING;
				tf5.scaleX = tf5.scaleY = ratio;
				
				tf1.y = tf5.y + tf5.height + TEXT_SPACING;
				tf1.x = LEFT_PADDING;
				tf1.scaleX = tf1.scaleY = ratio;
				
				tf2.y = tf1.y + tf1.height + TEXT_SPACING;
				tf2.x = LEFT_PADDING;
				tf2.scaleX = tf2.scaleY = ratio;
				
				tf3.y = tf2.y + tf2.height + TEXT_SPACING;
				tf3.x = LEFT_PADDING;
				tf3.scaleX = tf3.scaleY = ratio;
				
				tf4.y = tf3.y + tf3.height + TEXT_SPACING;
				tf4.x = LEFT_PADDING;
				tf4.scaleX = tf4.scaleY = ratio;
				
				tf6.y = tf4.y + tf4.height + 2 * TEXT_SPACING;
				tf6.x = LEFT_PADDING;
				tf6.scaleX = tf6.scaleY = ratio;
			}
		}
		
		private function mouseDownHandler(e:MouseEvent):void {
			var sPage:String = "";
			switch(e.target.name) {
				case "tf1":
					sPage = "tarifs";
					break;
				case "tf2":
					sPage = "traffic";
					break;
				case "tf3":
					sPage = "internet_payments";
					break;
				case "tf4":
					sPage = "tariff_history";
					break;
				case "tf5":
					sPage = "subscriber";
					break;
				case "tf6":
					sPage = "additionals";
					break;
				default:
					sPage = "";
					break;
			}
			
			if(sPage.length>0) {
				dispatchEvent(new SlidePageEvent(SlidePageEvent.SLIDED_SWITCH, sPage));
			}
		}
		
		
	}
}