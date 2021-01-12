package com.uzbilling.view {
	
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	
	public class DetailsTextField extends Sprite {
		private var wi:Number = 660;
		private var PADDING:Number = 10;
		private var txtHeight:Number = 0;
		
		public function DetailsTextField() {
			// constructor code
			this.mouseChildren = false;
			txtHeight = txt.height - 2;
		}
		
		public function setWidth(w:Number):void {
			wi = w;
/*			if(wi>720) {
				var ttf:TextFormat = new TextFormat();
				ttf.size = 50;
				tf.defaultTextFormat = ttf;
				tf.height = tf.textHeight + 10;
				
				var ttf2:TextFormat = new TextFormat();
				ttf2.size = 44;
				txt.defaultTextFormat = ttf2;
				
				PADDING = 20;
			}*/
		}
		
		public function setDetails(_tf:String, _txt:String, iconID:int=1, _border:Boolean=false):void {
//			tf.width = wi;
//			txt.width = wi;
			
			tf.border = _border;
			
			if(_tf) tf.text = _tf;
			if(_txt && _txt!="null") txt.text = _txt;

//			if(txt.width < txt.textWidth) {
//				trace("Text Field longer that expected!");
				txt.wordWrap = true;
				txt.multiline = true;
				txt.border = _border;
/*				if(txt.numLines>1) {
					//txt.height = txt.textHeight * txt.numLines - 50;
					txt.height = txtHeight * txt.numLines;
				}*/
				txt.height = txt.textHeight + 5;
				txt.y = tf.height + PADDING;

//				trace("getLineOffset: " + txt.numLines);
				//txt.height *= txt.getLineOffset();
//			}

			icon.gotoAndStop(iconID);
			bg.height = txt.y + txt.textHeight + 10
			sline.y = bg.height;
		}
		
	}
	
}
