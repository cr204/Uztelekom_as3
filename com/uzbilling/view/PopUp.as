package com.uzbilling.view {
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import com.uzbilling.controller.ScreenManager;
	import com.uzbilling.controller.LanguageSettings;
	import com.uzbilling.events.PopUpEvent;
	
	
	public class PopUp extends Sprite {
		protected var thisPageWidth:Number;
		protected var thisPageHeight:Number;
		protected var ls:LanguageSettings;
		public var confirmed:Boolean = false;
		
		public function PopUp() {
			// constructor code
			this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		protected function init(e:Event):void {
			thisPageWidth = ScreenManager.getInstance().getWidth();
			thisPageHeight = ScreenManager.getInstance().getHeight();
			this.addEventListener(Event.REMOVED_FROM_STAGE, deinit);
			ls = LanguageSettings.getInstance();
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
		}
		
		protected function deinit(e:Event):void {
			this.removeEventListener(Event.ADDED_TO_STAGE, init);
			this.removeEventListener(Event.REMOVED_FROM_STAGE, deinit);
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
		}
		
		public function updateTexts(s1:String, s2:String):void {
			// this function must be overriden
		}
		
		public function setData(arr:Array):void {
			// this function must be overriden
		}
		
		public function selectText(s:String):void {
			// this function must be overriden
		}
		
		public function setHTMLData(s:String):void {
			// this function must be overriden
		}
		
		private function keyDownHandler(e:KeyboardEvent):void {
			switch(e.keyCode) {
				case Keyboard.BACK:
					this.dispatchEvent(new PopUpEvent(PopUpEvent.CLOSE));
					e.preventDefault()
					e.stopImmediatePropagation();
					break;
			}
		}

		
	}
}