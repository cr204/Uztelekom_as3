package com.uzbilling.view {
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLLoader;
	import flash.net.URLRequestHeader;
	import flash.events.IOErrorEvent;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import com.uzbilling.events.RightMenuEvent;
	import com.uzbilling.controller.ScreenManager;
	import com.uzbilling.controller.NetworkManager;
	import com.uzbilling.controller.UserManager;
	import com.uzbilling.events.PopUpEvent;
	import com.uzbilling.controller.LanguageSettings;
	import com.uzbilling.model.Globals;
	
	
	public class RightHandMenu extends Sprite {
		private var SERVER_PATH:String;
		private var thisWidth:Number;
		private var thisHeight:Number;
		private var ls:LanguageSettings;
		
		public function RightHandMenu() {
			// constructor code
			SERVER_PATH = NetworkManager.getInstance().SUBSCRIBER_PATH;
			ls = LanguageSettings.getInstance();
			this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event):void {
			//bg.alpha = 0;
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
			this.addEventListener(Event.REMOVED_FROM_STAGE, deinit);
			thisWidth = ScreenManager.getInstance().getWidth();
			thisHeight = ScreenManager.getInstance().getHeight();
			this.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			initAssets();
		}
		
		private function deinit(e:Event):void {
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
			this.removeEventListener(Event.REMOVED_FROM_STAGE, deinit);
		}
		
		private function keyDownHandler(e:KeyboardEvent):void {
			switch(e.keyCode) {
				case Keyboard.BACK:
					this.dispatchEvent(new RightMenuEvent(RightMenuEvent.CLOSED));
					e.preventDefault()
					e.stopImmediatePropagation();
					break;
			}
		}
		
		private function initAssets():void {
			bg.width = thisWidth;
			bg.height = thisHeight;
			
			menu.tf1.text = ls.getData("mn.ref");
			menu.tf2.text = ls.getData("mn.pas");
			menu.tf3.text = ls.getData("mn.lan");
			menu.tf4.text = ls.getData("mn.abt");
			menu.tf5.text = ls.getData("mn.ext");
			
			if(thisWidth<700 || thisWidth>800) {
				menu.scaleX = menu.scaleY = thisWidth / ScreenManager.aspectRation;
			}
			
			//menu.x = thisWidth - menu.width - 15;
			//menu.y = 105 * (thisHeight / 1280);
		}
		
		private function mouseDownHandler(e:MouseEvent):void {
			switch(e.target.name) {
				case "tf1":
					trace("Refresh data");
					refreshData();
					break;
				case "tf2":
					this.dispatchEvent(new RightMenuEvent(RightMenuEvent.PRESSED, "changePass"));
					break;
				case "tf3":
					this.dispatchEvent(new RightMenuEvent(RightMenuEvent.PRESSED, "language"));
					break;
				case "tf4":
					this.dispatchEvent(new RightMenuEvent(RightMenuEvent.PRESSED, "about"));
					break;
				case "tf5":
					trace("Log out");
					this.dispatchEvent(new RightMenuEvent(RightMenuEvent.PRESSED, "logout"));
					break;
				default:
					//
					break;
			}
			e.preventDefault()
			e.stopImmediatePropagation();
			this.dispatchEvent(new RightMenuEvent(RightMenuEvent.CLOSED));
		}
		
		private function refreshData():void {
			var hdr0:URLRequestHeader = new URLRequestHeader("Content-type", "application/json");
			var hdr1:URLRequestHeader = new URLRequestHeader("X-Access-token", Globals.getInstance().token);
			 
			var req:URLRequest = new URLRequest(SERVER_PATH);
			req.requestHeaders.push(hdr0);
			req.requestHeaders.push(hdr1);
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler, false, 0, true);
			urlLoader.addEventListener(Event.COMPLETE, loaderComleteHandler);
			 
			 
			req.method = URLRequestMethod.POST;
			urlLoader.load(req);
			
			
			
/*			var url:String = SERVER_PATH; // + "pcmain";
			var request:URLRequest = new URLRequest(url);
			request.method = URLRequestMethod.POST;
			
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, loaderComleteHandler);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler, false, 0, true);
			
			try {
				urlLoader.load(request);
			} catch(err:Error) {
				trace(err);
			}  */
		}
		
		private function loaderComleteHandler(e:Event):void {
			var res:Object = JSON.parse(e.target.data);
			UserManager.getInstance().setUserDetails(res);
			this.dispatchEvent(new RightMenuEvent(RightMenuEvent.PRESSED, "refresh"));
		}
		
		private function ioErrorHandler( e:IOErrorEvent ):void {
			trace("Connection Error...");
			this.dispatchEvent(new PopUpEvent(PopUpEvent.POPUP, "no_connection"));
		}
		
		
		
		
		
	}
}