package com.uzbilling.view {
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.geom.ColorTransform;
	
	
	public class BtnPopUp extends Sprite {
		
		private var ct:ColorTransform=new ColorTransform();
		
		public function BtnPopUp() {
			// constructor code
			this.mouseChildren = false;
			this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event):void {
			this.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			this.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			this.addEventListener(Event.REMOVED_FROM_STAGE, deinit);
		}
		
		private function deinit(e:Event):void {
			this.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			this.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			this.removeEventListener(Event.REMOVED_FROM_STAGE, deinit);
		}
		
		public function setLabel(s:String):void {
			txt.text = s;
		}
		
		private function mouseDownHandler(e:MouseEvent):void {
			tintClip(txt, 0x012046);
		}
		
		private function mouseUpHandler(e:MouseEvent):void {
			tintClip(txt, 0x01469A);
		}
		
		
		
		private function tintClip(obj:*, c:uint):void {
			
			var color:uint=c; //picker.selectedColor;
			var mul:Number=1; //slider.value/100;
			var ctMul:Number=(1-mul);
			var ctRedOff:Number=Math.round(mul*extractRed(color));
			var ctGreenOff:Number=Math.round(mul*extractGreen(color));
			var ctBlueOff:Number=Math.round(mul*extractBlue(color));
			ct=new ColorTransform(ctMul,ctMul,ctMul,1,ctRedOff,ctGreenOff,ctBlueOff,0);
			obj.transform.colorTransform=ct;
		}
		
		
		private function extractRed(c:uint):uint {
			return (( c >> 16 ) & 0xFF);
		}
		
		private function extractGreen(c:uint):uint {
			return ( (c >> 8) & 0xFF );
		}
		
		private function extractBlue(c:uint):uint {
			return ( c & 0xFF );
		}
		
	}
}