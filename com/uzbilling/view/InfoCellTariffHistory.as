package com.uzbilling.view {
	
	import flash.display.MovieClip;
	import com.uzbilling.controller.LanguageSettings;
	import flash.events.MouseEvent;
	import com.uzbilling.events.InfoCellEvent;
	import com.uzbilling.controller.ScrollManager;
	import com.uzbilling.model.TariffHistoryModel;
	
	public class InfoCellTariffHistory extends MovieClip {
		private var ls:LanguageSettings;
		private var model:TariffHistoryModel;
		private var PADDING:Number = 0;
		
		public function InfoCellTariffHistory() {
			// constructor code
			stop();
			ls = LanguageSettings.getInstance();
			ScrollManager.scrolled = false;
			arrow.addEventListener(MouseEvent.MOUSE_UP, onExpandCell);
		}
		
		
		public function setDataModel(model:TariffHistoryModel=null):void {
			this.model = model;
			
			title.text = ls.getData("tarifHistory.service_name");  
			if(model.service_name) {
				txt.text = model.service_name;
			} else {
				txt.text = "Неограничен";
			}
			
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
					setDataModel(this.model);
				}
				this.dispatchEvent(new InfoCellEvent(InfoCellEvent.EXPANDED));
			}
		}
		
		private function setExpandData():void {
			title1.text = ls.getData("tarifHistory.state_name");
			txt1.text = checkData(model.state_name);
			title1.y += PADDING;
			txt1.y += PADDING;
			
//			title2.text = ls.getData("state_name.inet_speed");
			//txt2.text = checkData(model.inet_speed) + " " + ls.getData("mbs");
//			title2.y += PADDING;
//			txt2.y += PADDING;
			
//			title3.text = ls.getData("state_name.t_ammount");
			//txt3.text = checkData(model.t_ammount) + " " + ls.getData("uzs");
//			title3.y += PADDING;
//			txt3.y += PADDING;
			
///			title4.text = ls.getData("state_name.tasx_speed");
			//txt4.text = checkData(model.tasx_speed) + " " + ls.getData("mbs");
//			title4.y += PADDING;
//			txt4.y += PADDING;
			
//			title5.text = ls.getData("state_name.idService");
			//txt5.text = checkData(model.t_id);
//			title5.y += PADDING;
//			txt5.y += PADDING;
			
			bg.height = txt1.y + txt1.textHeight + 60
			separator.gotoAndStop(2);
			separator.y = bg.height - 30;
		}
		
		
		private function checkData(s:String):String {
			trace("checkData: " + s);
			if(s==null || s=="null") {
				s = ls.getData("msg.noData");
			}
			return s;
		}
		
		
	}
}