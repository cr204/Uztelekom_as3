package com.uzbilling.view {
	
	import flash.display.MovieClip;
	import com.uzbilling.controller.LanguageSettings;
	import flash.events.MouseEvent;
	import com.uzbilling.events.InfoCellEvent;
	import com.uzbilling.controller.ScrollManager;
	import com.uzbilling.model.TrafficModel;
	
	public class InfoCellTraffic extends MovieClip {
		private var ls:LanguageSettings;
		private var model:TrafficModel;
		private var PADDING:Number = 0;
		
		public function InfoCellTraffic() {
			// constructor code
			stop();
			ls = LanguageSettings.getInstance();
			ScrollManager.scrolled = false;
			arrow.addEventListener(MouseEvent.MOUSE_UP, onExpandCell);
		}
		
		
		public function setDataModel(model:TrafficModel=null):void {
			this.model = model;
			
			title.text = ls.getData("traff.day_date");
			txt.text = model.day_date;
			tfinterval.htmlText = "<i>" + model.interval_time + "</i>";
			
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
			title1.text = ls.getData("traff.vol_used_inet");
			txt1.text = checkData(model.vol_used_inet) + " " + ls.getData("mb");
			title1.y += PADDING;
			txt1.y += PADDING;
			
			title2.text = ls.getData("traff.vol_cost_inet");
			txt2.text = checkData(model.vol_cost_inet) + " " + ls.getData("uzs");
			title2.y += PADDING;
			txt2.y += PADDING;
			
			title3.text = ls.getData("traff.vol_used_tasx");
			txt3.text = checkData(model.vol_used_tasx) + " " + ls.getData("mb");
			title3.y += PADDING;
			txt3.y += PADDING;
			
			title4.text = ls.getData("traff.service_name");
			txt4.text = checkData(model.service_name);
			title4.y += PADDING;
			txt4.y += PADDING;
			
			title5.text = ls.getData("traff.mac_address");
			txt5.text = checkData(model.mac_address);
			title5.y += PADDING;
			txt5.y += PADDING;
			
			bg.height = txt5.y + txt5.textHeight + 60
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