package com.uzbilling.view {
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.display.MovieClip;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import com.uzbilling.model.Period;
	import com.uzbilling.model.SelectList;
	import com.uzbilling.events.TopSliderEvent;
	
	public class TopFilterSlider extends Sprite {
		public var selText:String = "";
		public var sel1_PeriodID:Period;
		public var sel2_PeriodID:Period;
		public var phoneA:String = "";
		public var phoneB:String = "";
		private var selName:String = "";
		private var selectOpened:Boolean = false;
		
		public function TopFilterSlider() {
			// constructor code
			sel1_PeriodID = SelectList.getInstance().getPenultPeriod();
			sel2_PeriodID = SelectList.getInstance().getLastPeriod();
			//init();
		}
		
		public function init():void {
			//sel1.txt.text = sel1_PeriodID.PER_NAME;
			//sel2.txt.text = sel2_PeriodID.PER_NAME;
			this.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
		}
		
		public function deinit():void {
			this.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
		}
		
		public function setDefaultPeriods(p1:Period, p2:Period):void {
			var ddList:MovieClip = this.getChildByName("sel1") as MovieClip;
			if(ddList.txt.text=="") ddList.txt.text = p1.PER_NAME;
			
			ddList = this.getChildByName("sel2") as MovieClip;
			if(ddList.txt.text=="") ddList.txt.text = p2.PER_NAME;
			
			trace("Filter.setDefaultPeriods: " + p1.PER_NAME, p2.PER_NAME);
		}
		
		public function setSelectPeriod(p:Period):void {
			if(p.PER_NAME!="") {
				(selName=="sel1") ? sel1_PeriodID = p : sel2_PeriodID = p;
				var ddList:MovieClip = this.getChildByName(selName) as MovieClip;
				ddList.txt.text = p.PER_NAME;
				selectOpened = false;
			}
		}
		
		private function keyDownHandler(e:KeyboardEvent):void {
			if(!selectOpened) {
				switch(e.keyCode) {
					case Keyboard.BACK:
						this.dispatchEvent(new TopSliderEvent(TopSliderEvent.CLOSED, ""));
						e.preventDefault()
						e.stopImmediatePropagation();
						break;
				}
			}
		}
		
		private function mouseDownHandler(e:MouseEvent):void {
			phoneA = txt1.text;
			phoneB = txt2.text;
			switch(e.target.name) {
				case "sel1":
					selName = e.target.name;
					selText = e.target.txt.text;
					selectOpened = true;
					this.dispatchEvent(new TopSliderEvent(TopSliderEvent.SELECTED, "sel1"));
					break;
				case "sel2":
					selName = e.target.name;
					selText = e.target.txt.text;
					selectOpened = true;
					this.dispatchEvent(new TopSliderEvent(TopSliderEvent.SELECTED, "sel2"));
					break;
				case "btnShow":
					this.dispatchEvent(new TopSliderEvent(TopSliderEvent.SHOWED, ""));
					break;
				case "topSliderFilter":
					this.dispatchEvent(new TopSliderEvent(TopSliderEvent.CLOSED, ""));
					break;
				default:
					trace("e.target.name: " + e.target.name);
					break;
			}
		}
		
	}
}