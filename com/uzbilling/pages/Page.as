package com.uzbilling.pages {
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.display.MovieClip;
	
	import com.greensock.TweenLite;
	import com.uzbilling.events.*;
	import com.uzbilling.controller.ScreenManager;
	import com.uzbilling.controller.NetworkManager;
	import com.uzbilling.controller.LanguageSettings;
	import com.uzbilling.view.PageTop;
	
	public class Page extends Sprite {
		protected const RIGHT_PADDING:Number = 50;
		protected var TEXT_PADDING:Number = 10;
		protected var screenBg0:*;
		protected var thisPageWidth:Number;
		protected var thisPageHeight:Number;
		public var thisPageName:String = new String();
		protected var sliding:Boolean = false;
		protected var tHolder:Sprite = new Sprite();
		protected var tHolder0:Sprite = new Sprite();
		protected var loadedData:String;
		protected var btnSlide0:Sprite;
		protected var btnRMenu0:MovieClip;
		protected var top0:PageTop;
		protected var ls:LanguageSettings;
		private var nTimer:Timer;
		private var nextPageName:String;
		private var refreshPg:Boolean = false;

		
		public function Page() {
			this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		public function nextPage(s:String):void {
			nextPageName = s;
		}
		
		protected function init(e:Event):void {
			thisPageWidth = ScreenManager.getInstance().getWidth();
			thisPageHeight = ScreenManager.getInstance().getHeight();
			this.addEventListener(Event.REMOVED_FROM_STAGE, deinit);
			ls = LanguageSettings.getInstance();
		}
		
		
		protected function deinit(e:Event):void {
			if(btnSlide0) btnSlide0.removeEventListener(MouseEvent.MOUSE_DOWN, onSlidePage);
			if(btnRMenu0) btnRMenu0.removeEventListener(MouseEvent.MOUSE_DOWN, openRightHandMenu);
			this.removeEventListener(Event.ADDED_TO_STAGE, init);
			this.removeEventListener(Event.REMOVED_FROM_STAGE, deinit);
		}
		
		protected function initAssets():void {
			screenBg0.width = thisPageWidth;
			screenBg0.height = thisPageHeight;

			if(btnRMenu0) {
				btnRMenu0.x = thisPageWidth - btnRMenu0.width;
				btnRMenu0.addEventListener(MouseEvent.MOUSE_DOWN, openRightHandMenu);
			}
			
			if(btnSlide0) btnSlide0.addEventListener(MouseEvent.MOUSE_DOWN, onSlidePage);
			
			if(refreshPg) {
				tHolder.alpha = 0;
				TweenLite.to(tHolder, .5, {alpha:1});
				refreshPg = false;
			}
			
		}
		
		protected function switchPage(page:String="default"):void {
			if(page=="default" && nextPageName) page = nextPageName;
			trace("Page.switchPage: " + page);
			dispatchEvent(new SwitchPageEvent('switched', page));
		}
		
		public function slide(b:Boolean):void {
			sliding = b;
		}
		
		public function updateDisplayList():void {
			//trace("Page.updateDisplayList()");
		}
		
		public function get pageName():String {
			return thisPageName;
		}
		
		public function refreshPage():void {
			refreshPg = true;
		}
		
		
		protected function onSlidePage(e:MouseEvent=null):void {
			this.dispatchEvent(new SwitchPageEvent(SwitchPageEvent.SLIDED, '')); 
		}
		
		protected function checkSlideBack():void {
			if(tHolder.alpha==0 && tHolder0.alpha==0) {
				onSlidePage();
			}
		}
		
		public function startNetworkTracking(refr:Boolean=false):void {
			nTimer = new Timer(100);
			nTimer.addEventListener(TimerEvent.TIMER, networkTimerHandler);
			nTimer.start();
			
			// Newly added
			trace("refr: " + refr);
			if(!refr) btnSlide0.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_DOWN));
		}
		
		private function openRightHandMenu(e:MouseEvent):void {
			this.dispatchEvent(new RightMenuEvent(RightMenuEvent.OPENED));
		}

		
		private function networkTimerHandler(e:TimerEvent):void {
			if(NetworkManager.getInstance().getReturnedData()=="no_connection") {
				this.dispatchEvent(new PopUpEvent(PopUpEvent.POPUP, "no_connection"));
				nTimer.stop()
			} else if(NetworkManager.getInstance().getReturnedData()=="login_required") {
				this.dispatchEvent(new PopUpEvent(PopUpEvent.POPUP, "login_required"));
				nTimer.stop()
			} else if(NetworkManager.getInstance().getReturnedData()!="not_loaded") {
				loadedData = NetworkManager.getInstance().getReturnedData();
				onDataLoaded();
				nTimer.stop()
			}

		}
		
		protected function onDataLoaded():void {
			// must be overridden
		}
		
		protected function splitDouble(source:String, s1:String, s2:String):Array {
			var records:Array = source.split(s1);
			var result:Array = [];
			for (var i:int = 0; i<records.length; i++) {
				var tmparr:Array = records[i].split(s2);
				result.push(tmparr[0]);
				if(tmparr.length>1) {
					result.push(tmparr[1]);
				}
			}
			return result;
		}
		

		
	}
	
}
