package com.uzbilling.view {
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import com.uzbilling.events.PopUpEvent;	
	import com.uzbilling.controller.ScreenManager;
	
	public class PopUpServiceConfirm extends PopUp {
		
		public function PopUpServiceConfirm() {
			// constructor code
		}
		
		override protected function init(e:Event):void {
			super.init(e);
			initScreenAssets();
		}

		override protected function deinit(e:Event):void {
			super.deinit(e);
			cont.btnYes.removeEventListener(MouseEvent.MOUSE_UP, onClosePopUp);
			cont.btnNo.removeEventListener(MouseEvent.MOUSE_UP, onClosePopUp);
		}
		
		override public function updateTexts(s1:String, s2:String):void {
			cont.tf1.text = s1;
			cont.tf2.text = s2;
		}
		
		private function initScreenAssets():void {
			screenBg.width = super.thisPageWidth;
			screenBg.height = super.thisPageHeight;
			
			cont.tf1.text = ls.getData("pop.addTitle");
			cont.tf2.text = ls.getData("pop.addText");
			cont.btnYes.text = ls.getData("btn.YES");
			cont.btnNo.text = ls.getData("btn.NO");
			
			if(super.thisPageWidth<700 ||
			   super.thisPageWidth>800) {
				cont.scaleX = cont.scaleY = super.thisPageWidth / ScreenManager.aspectRation;
				cont.y = (super.thisPageHeight - cont.height) * .5;
			}
			
			cont.x = Math.round((super.thisPageWidth - cont.width) * .5);
			cont.btnYes.addEventListener(MouseEvent.MOUSE_UP, onClosePopUp);
			cont.btnNo.addEventListener(MouseEvent.MOUSE_UP, onClosePopUp);
		}
		
		private function onClosePopUp(e:MouseEvent):void {
			if(e.target.name=="btnYes") super.confirmed=true;
			this.dispatchEvent(new PopUpEvent(PopUpEvent.CLOSE));
		}
		
	}
}