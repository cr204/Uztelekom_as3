package com.uzbilling.view {
	
	import flash.display.MovieClip;
	import com.uzbilling.controller.LanguageSettings;
	import flash.events.MouseEvent;
	import com.uzbilling.events.InfoCellEvent;
	import com.uzbilling.controller.ScrollManager;
	
	public class InfoCellServicePayments extends MovieClip {
		private var ls:LanguageSettings;
		private var cellData:Array;
		private var PADDING:Number = 0;
		
		public function InfoCellServicePayments() {
			// constructor code
			stop();
			ls = LanguageSettings.getInstance();
			ScrollManager.scrolled = false;
			arrow.addEventListener(MouseEvent.MOUSE_UP, onExpandCell);
		}
		
		public function setDataArr(arr:Array):void {
			cellData = arr;
			title.text = ls.getData("spay.name");
			txt.text = cellData[3];
			icon.gotoAndStop(2);
			
			txt.wordWrap = true;
			txt.multiline = true;
			//txt.border = true;
			txt.height = txt.textHeight + 5;
			arrow.height = txt.y + txt.textHeight;
			bg.height = txt.y + txt.textHeight + 15
			separator.y = bg.height;
		}
		
		private function onExpandCell(e:MouseEvent):void {
			if(!ScrollManager.scrolled) {
				if(this.currentFrame==1) {
					gotoAndStop(2);
					arrow.gotoAndStop(2);
					PADDING = txt.height - txt1.height;
					setExpandData();
				} else {
					gotoAndStop(1);
					arrow.gotoAndStop(1);
					separator.gotoAndStop(1);
					setDataArr(cellData);
				}
				this.dispatchEvent(new InfoCellEvent(InfoCellEvent.EXPANDED));
			}
		}
		
		private function setExpandData():void {
			title1.text = ls.getData("spay.period");
			txt1.text = checkData(cellData[0]);
			title1.y += PADDING;
			txt1.y += PADDING;
			
			title2.text = ls.getData("spay.idService");
			txt2.text = checkData(cellData[1]);
			title2.y += PADDING;
			txt2.y += PADDING;
			
			title3.text = ls.getData("spay.amount");
			txt3.text = checkData(cellData[4]);
			title3.y += PADDING;
			txt3.y += PADDING;
			
			bg.height = txt3.y + txt3.textHeight + 60
			separator.gotoAndStop(2);
			separator.y = bg.height - 30;
		}
		
		
		private function checkData(s:String):String {
			if(s==null) {
				s = ls.getData("msg.noData");
			}
			return s;
		}
		
	}
	
}
