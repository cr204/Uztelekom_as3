package com.uzbilling.view {
	
	import flash.display.MovieClip;
	import com.uzbilling.controller.LanguageSettings;
	import flash.events.MouseEvent;
	import com.uzbilling.events.InfoCellEvent;
	import com.uzbilling.controller.ScrollManager;
	import com.uzbilling.model.TariffModel;
	
	public class InfoCellTariffs extends MovieClip {
		private var ls:LanguageSettings;
		private var model:TariffModel;
		private var PADDING:Number = 0;
		public var cellID:String = "";
		
		public function InfoCellTariffs() {
			// constructor code
			stop();
			ls = LanguageSettings.getInstance();
			ScrollManager.scrolled = false;
			arrow.addEventListener(MouseEvent.MOUSE_UP, onExpandCell);
		}
		
		
		public function setDataModel(model:TariffModel=null):void {
			this.model = model;
			
			title.text = model.t_name;
			if(model.inet_traffic) {
				txt.text = model.inet_traffic + " " + ls.getData("mb");
			} else {
				txt.text = "Неограничен";
			}
			tfamount.htmlText = "<i>" + model.t_ammount + " " + ls.getData("uzs") + "</i>";
			
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
		
		public function cellInLoadMode(b:Boolean):void {
			if(b) {
				btnChange.txt.text = ls.getData("msg.wait");
			} else {
				btnChange.txt.text = ls.getData("tarif.change_tariff");
			}
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
		
		private function onChangePressed(e:MouseEvent):void {
			//trace("New Tariff ID: " + model.t_id);
			var st:String = "on"; //(btnSt.currentFrame==1 ? "on" : "off");
			this.dispatchEvent(new InfoCellEvent(InfoCellEvent.SERVICE_ACTION, int(model.t_id), st, cellID));
		}
		
		
		
		private function setExpandData():void {
			title1.text = ls.getData("tarif.inet_traffic");
			txt1.text = checkData(model.inet_traffic) + " " + ls.getData("mb");
			title1.y += PADDING;
			txt1.y += PADDING;
			
			title2.text = ls.getData("tarif.inet_speed");
			txt2.text = checkData(model.inet_speed) + " " + ls.getData("mbs");
			title2.y += PADDING;
			txt2.y += PADDING;
			
			title3.text = ls.getData("tarif.t_ammount");
			txt3.text = checkData(model.t_ammount) + " " + ls.getData("uzs");
			title3.y += PADDING;
			txt3.y += PADDING;
			
			title4.text = ls.getData("tarif.tasx_speed");
			txt4.text = checkData(model.tasx_speed) + " " + ls.getData("mbs");
			title4.y += PADDING;
			txt4.y += PADDING;
			
			title5.text = ls.getData("ser.idService");
			txt5.text = checkData(model.t_id);
			title5.y += PADDING;
			txt5.y += PADDING;
			
			bg.height = txt5.y + txt5.textHeight + 60
			separator.gotoAndStop(2);
			separator.y = bg.height - 30;
			
			if(model.reserved) {
				btnChange.txt.text = ls.getData("tarif.reserved");
			} else {
				btnChange.txt.text = ls.getData("tarif.change_tariff");
				btnChange.addEventListener(MouseEvent.MOUSE_UP, onChangePressed);
			}
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