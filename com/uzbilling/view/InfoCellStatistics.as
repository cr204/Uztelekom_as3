package com.uzbilling.view {
	
	import flash.display.MovieClip;
	import com.uzbilling.controller.LanguageSettings;
	import flash.events.MouseEvent;
	import com.uzbilling.events.InfoCellEvent;
	import com.uzbilling.controller.ScrollManager;
	
	public class InfoCellStatistics extends MovieClip {
		private var ls:LanguageSettings;
		private var cellData:Array;
		private var PADDING:Number = 0;
		
		public function InfoCellStatistics() {
			// constructor code
			stop();
			ls = LanguageSettings.getInstance();
			ScrollManager.scrolled = false;
			arrow.addEventListener(MouseEvent.MOUSE_UP, onExpandCell);
		}
		
		public function setDataArr(arr:Array):void {
			cellData = arr;
			title.text = ls.getData("outgoing");
			txt.text = cellData[1];
			tfdate.htmlText = "<i>" + checkData(cellData[4]) + "</i>";
			tfmin.htmlText = "<i>" + checkData(cellData[6]) + " " + ls.getData("minute") + "</i>";
			
			txt.wordWrap = true;
			txt.multiline = true;
			//txt.border = true;
			txt.height = txt.textHeight + 5;
			//txt.y = tf.height + PADDING;
			icon.gotoAndStop(4);
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
			title1.text = ls.getData("stat.dateCall");
			txt1.text = checkData(cellData[4]);
			title1.y += PADDING;
			txt1.y += PADDING;
			
			title2.text = ls.getData("stat.timeCall");
			txt2.text = checkData(cellData[5]);
			title2.y += PADDING;
			txt2.y += PADDING;
			
			title3.text = ls.getData("stat.dlit");
			txt3.text = checkData(cellData[6]);
			title3.y += PADDING;
			txt3.y += PADDING;
			
			title4.text = ls.getData("stat.amountCalc");
			txt4.text = checkData(cellData[7]);
			title4.y += PADDING;
			txt4.y += PADDING;
			
			title5.text = ls.getData("stat.dateFromDot");
			txt5.text = checkData(cellData[8]);
			title5.y += PADDING;
			txt5.y += PADDING;
			
			title6.text = ls.getData("stat.privil");
			txt6.text = checkData(cellData[9]);
			title6.y += PADDING;
			txt6.y += PADDING;
			
			bg.height = txt6.y + txt6.textHeight + 60
			separator.gotoAndStop(2);
			separator.y = bg.height - 30;
		}
		
		
		private function checkData(s:String):String {
			if(s==null || s=="null") {
				s = ls.getData("msg.noData");
			}
			return s;
		}
		
	}
}