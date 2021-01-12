package com.uzbilling.view {
	
	import flash.display.Sprite;
	
	
	public class PageTop extends Sprite {
		
		
		public function InfoPageTop() {
			// constructor code
			this.mouseChildren = false;
		}
		
/*		public function setUserDetails(s:String):void {
			txtUserName.text = s;
		}
*/		
		public function setWidth(w:Number):void {
			bg.width = w;
//			right3Dots.x = w - 40;
		}
		
		public function setTitle(s:String):void {
			txtTitle.text = s;
			trace("s.length: " + s.length);
			if(txtTitle.numLines>1 && s.length>28) {
				trace("txtTitle.numLines: " + txtTitle.numLines);
				txtTitle.y = 20;
				txtTitle.height = 200; //txtTitle.textHeight;
			}
		}
		
	}
}