package com.uzbilling.view {
	
	import flash.display.Sprite;
	import com.uzbilling.controller.LanguageSettings;
	
	public class InfoCellNoData extends Sprite {
		
		public function InfoCellNoData() {
			// constructor code
			var ls:LanguageSettings = LanguageSettings.getInstance();
			txt.text = ls.getData("msg.noData");
		}
	}
	
}
