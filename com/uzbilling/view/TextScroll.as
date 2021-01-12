package com.uzbilling.view {
	import flash.display.Sprite;
	
	public class TextScroll extends Sprite {
		
		public function TextScroll() {
			// constructor code
		}
		
		public function slidePerc(n:Number):void {
			if(n>=0 && n<=100) {
				n = 100 - n;
				
				slider.y = Math.round(n * ((sliderBg.height-slider.height) /100));
			}
		}
		
		public function setHeight(h:Number, n:Number=345):void {
			slider.height = n;
			sliderBg.height = h;
		}
		
		public function setSliderHeight(n:Number):void {
			if(n<100) n=100;
			if(n>sliderBg.height) n=sliderBg.height - 10;
			slider.height = n;
		}
		
	}
}