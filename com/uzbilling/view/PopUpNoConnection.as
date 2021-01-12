package com.uzbilling.view {
	import flash.events.Event;
	import flash.events.MouseEvent;
	import com.uzbilling.events.PopUpEvent;	
	
	public class PopUpNoConnection extends PopUp {
		
		
		public function PopUpNoConnection() {
			// constructor code
		}
		
		override protected function init(e:Event):void {
			super.init(e);
			initScreenAssets();
		}

		override protected function deinit(e:Event):void {
			super.deinit(e);
		}
		
		override public function updateTexts(s1:String, s2:String):void {
			cont.tf1.text = s1;
			cont.tf2.text = s2;
		}
		
		private function initScreenAssets():void {
			screenBg.width = super.thisPageWidth;
			screenBg.height = super.thisPageHeight;
			
			if(super.thisPageWidth<700 ||
			   super.thisPageWidth>800) {
				cont.scaleX = cont.scaleY = super.thisPageWidth / 720;
			}
			
			cont.x = Math.round((super.thisPageWidth - cont.width) * .5);
			cont.btnOk.addEventListener(MouseEvent.MOUSE_UP, onClosePopUp);
		}
		
		private function onClosePopUp(e:MouseEvent):void {
			this.dispatchEvent(new PopUpEvent(PopUpEvent.CLOSE));
		}
		
	}
}