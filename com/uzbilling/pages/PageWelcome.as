package com.uzbilling.pages {
	
	import flash.display.Sprite;
	import flash.events.Event;
	import com.greensock.TweenLite;
	import com.uzbilling.controller.ScreenManager;
	
	public class PageWelcome extends Page {
		
		public function PageWelcome() {
			// constructor code
		}
		
		override protected function init(e:Event):void {
			super.init(e);
			super.screenBg0 = screenBg;
			
			initScreenAssets();
			switchAfter(1);
		}
		
		override protected function deinit(e:Event):void {
			super.deinit(e);
		}
		
		override public function updateDisplayList():void {
			initScreenAssets();
		}
		
		private function initScreenAssets():void {
			screenBg.width = stage.stageWidth;
			screenBg.height = stage.stageHeight;
			
			if(super.thisPageWidth<700 ||
			   stage.stageWidth > 800) {
				if(ScreenManager.deviceType==1) {
					pre.scaleX = pre.scaleY = stage.stageWidth / 720;
					pre.x = (stage.stageWidth - pre.width) * .5;
					pre.y = (stage.stageHeight - pre.height) * .5;
				} else {
					TweenLite.to(this, 0, {delay:.5, onComplete:function(){ initScreenAssets2(); }});
				}
			}
		}
		
		private function initScreenAssets2():void {
			screenBg.width = stage.stageWidth;
			screenBg.height = stage.stageHeight;
			pre.scaleX = pre.scaleY = stage.stageWidth / 750;
			pre.x = (stage.stageWidth - pre.width) * .5;
			pre.y = (stage.stageHeight - pre.height) * .5;
		}
		
		
		private function switchAfter(n:int):void {
			TweenLite.to(this, 0, {delay:n, onComplete:function(){ switchPage("login"); }});
		}
		
		
	}
	
}
