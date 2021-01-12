package com.uzbilling.view {
	
	import flash.display.MovieClip;
	import com.uzbilling.controller.LanguageSettings;
	import flash.events.MouseEvent;
	import com.uzbilling.events.InfoCellEvent;
	import com.uzbilling.controller.ScrollManager;
	
	public class InfoCellAdditionals extends MovieClip {
		private var ls:LanguageSettings;
		private var cellData:Array;
		private var PADDING:Number = 0;
		public var cellID:int = -1;
		
		public function InfoCellAdditionals() {
			// constructor code
			stop();
			ls = LanguageSettings.getInstance();
			ScrollManager.scrolled = false;
			arrow.addEventListener(MouseEvent.MOUSE_UP, onExpandCell);
			
			// Temporary
			btnSt.visible = false;
		}
		
		public function setDataArr(arr:Array):void {
			cellData = arr;
			title.text = ls.getData("ser.name");
			txt.text = cellData[1];
			
			txt.wordWrap = true;
			txt.multiline = true;
			//txt.border = true;
			txt.height = txt.textHeight + 5;
			
			//pre.visible = false;
			//txt.y = tf.height + PADDING;
			icon.gotoAndStop(5);
			arrow.height = txt.y + txt.textHeight;
			bg.height = txt.y + txt.textHeight + 15
			separator.y = bg.height;
		}
		
		public function updateDataArr(arr:Array):void {
			cellData = arr;
			
			if(this.currentFrame==2) {
				txt2.text = checkData(cellData[0]);
				trace("## " + cellData[0] + ": InfoCellAdditionals.frame: " + cellData[4]);
				btnSt.gotoAndStop(cellData[4]=="off" ? 1 : 2 ) ;
			}
			
//			txt.wordWrap = true;
//			txt.multiline = true;
			//txt.border = true;
//			txt.height = txt.textHeight + 5;
			
			//pre.visible = false;
			//txt.y = tf.height + PADDING;
//			icon.gotoAndStop(5);
//			arrow.height = txt.y + txt.textHeight;
//			bg.height = txt.y + txt.textHeight + 15

			
//			separator.y = bg.height;
		}
		
		public function cellInLoadMode(b:Boolean):void {
			if(b) {
				btnSt.visible = false;
			} else {
				btnSt.visible = false; //true;
			}
		}
		
		public function actionSuccessful(b:Boolean):void {
			btnSt.gotoAndStop((btnSt.currentFrame==1 ? 2 : 1))
		}
		
		private function onExpandCell(e:MouseEvent):void {
			if(!ScrollManager.scrolled) {
				if(this.currentFrame==1) {
					gotoAndStop(2);
					arrow.gotoAndStop(2);
					PADDING = txt.height - txt1.height;
					btnDetailed.addEventListener(MouseEvent.MOUSE_DOWN, infoHandler);
					btnSt.addEventListener(MouseEvent.MOUSE_DOWN, changeStateHandler);
					setExpandData();
				} else {
					btnDetailed.removeEventListener(MouseEvent.MOUSE_DOWN, infoHandler);
					gotoAndStop(1);
					arrow.gotoAndStop(1);
					separator.gotoAndStop(1);
					setDataArr(cellData);
				}
				this.dispatchEvent(new InfoCellEvent(InfoCellEvent.EXPANDED));
			}
		}
		
		private function infoHandler(e:MouseEvent):void {
			this.dispatchEvent(new InfoCellEvent(InfoCellEvent.DETAILED, cellData[0]));
		}
		
		private function changeStateHandler(e:MouseEvent):void {
			var st:String = (btnSt.currentFrame==1 ? "on" : "off");
			this.dispatchEvent(new InfoCellEvent(InfoCellEvent.SERVICE_ACTION, cellData[0], st, cellID.toString()));
		}
		
		private function setExpandData():void {
			title1.text = ls.getData("add.amount");
			txt1.text = checkData(cellData[2]);
			title1.y += PADDING;
			txt1.y += PADDING;
			
			title2.text = ls.getData("add.idService");
			txt2.text = checkData(cellData[0]);
			title2.y += PADDING;
			txt2.y += PADDING;
			
			title3.text = ls.getData("add.state");
			btnSt.gotoAndStop(checkData(cellData[4])=="off" ? 1 : 2 );
			title3.y += PADDING;
			btnSt.y += PADDING;
			pre.y = btnSt.y;
			
			btnDetailed.text = ls.getData("btn.Detailed");
			btnDetailed.y = btnSt.y;
/*			title4.text = ls.getData("ser.quantity");
			txt4.text = checkData(cellData[3]);
			title4.y += PADDING;
			txt4.y += PADDING;

*/			
			bg.height = btnSt.y + btnSt.height + 60
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