package com.uzbilling.view {
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	import flash.text.TextField;
	import flash.geom.ColorTransform;
	import com.greensock.TweenLite;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import com.uzbilling.events.RadioButtonEvent;
	import com.uzbilling.model.Period;
	
	
	public class RadioButton extends Sprite {
		private var ttf:TextFormat = new TextFormat();
		private var myTimer:Timer;
		private var timerIndex:int = 0;
		public var isSelected:Boolean = false;
		public var period:Period;
		
		public function RadioButton() {
			// constructor code
			this.mouseChildren = false;
			bg.alpha = 0;
		}
		
		public function init():void {
			//
		}
		
		public function deinit():void {
			myTimer.removeEventListener(TimerEvent.TIMER, timerHandler);
		}
		
		public function enableMouseEvent():void {
			myTimer = new Timer(10);
			myTimer.addEventListener(TimerEvent.TIMER, timerHandler);
		}
		
		public function setText(s:String):void {
			txt.text = s;
		}
		
		public function setPeriod(p:Period):void {
			period = p;
			txt.text = p.PER_NAME;
		}
		
		public function selected(b:Boolean):void {
			isSelected = b;
			if(b) {
				circ.gotoAndStop(2);
			} else {
				circ.gotoAndStop(1);
			}
		}

		public function buttonMouseDown():void {
			timerIndex = 0;
			myTimer.start();
			TweenLite.killTweensOf(bg);
			TweenLite.to(bg, 0, {alpha:.5, delay:.1, onComplete:disInTime });
		}
		
		public function buttonMouseMove():void {
			myTimer.stop();
			timerIndex = -1;
			TweenLite.killTweensOf(bg);
			bg.alpha = 0;
		}
				
		public function buttonMouseUp():void {
			myTimer.stop();
//			trace("timerIndex: " + timerIndex);
			TweenLite.killTweensOf(bg);
			if(timerIndex>2 && timerIndex<75) {
				selected(true);
				bg.alpha = .5;
				TweenLite.to(bg, .2, {alpha:0});
				this.dispatchEvent(new RadioButtonEvent(RadioButtonEvent.SELECTED, period));
			} else {
				bg.alpha = 0;
			}
			timerIndex = 0;
		}
		
		private function disInTime():void {
			TweenLite.to(bg, 0, {alpha:0, delay:1});
		}
		
		private function timerHandler(e:TimerEvent):void {
			++timerIndex;
		}
		
		private function tintClip(obj:*, c:uint):void {
			var color:uint=c; //picker.selectedColor;
			var mul:Number=1; //slider.value/100;
			var ctMul:Number=(1-mul);
			var ctRedOff:Number=Math.round(mul*extractRed(color));
			var ctGreenOff:Number=Math.round(mul*extractGreen(color));
			var ctBlueOff:Number=Math.round(mul*extractBlue(color));
			var ct=new ColorTransform(ctMul,ctMul,ctMul,1,ctRedOff,ctGreenOff,ctBlueOff,0);
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