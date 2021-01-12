package com.uzbilling.view {
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import com.uzbilling.controller.LanguageSettings;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLLoader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.FocusEvent;
	import com.uzbilling.controller.NetworkManager;
	import flash.text.TextFormat;
	import com.greensock.TweenLite;
	import com.uzbilling.events.PopUpEvent;
	
	
	public class PopUpLogin extends PopUp {
		private var SERVER_PATH:String;
		
		private var usr:String = new String();
		private var psw:String = new String();
		private var tf:TextFormat = new TextFormat();
		
		public function PopUpLogin() {
			// constructor code
		}
		
		override protected function init(e:Event):void {
			super.init(e);
			SERVER_PATH = NetworkManager.getInstance().SERVER + "pclogin";
			initScreenAssets();
		}

		
		override protected function deinit(e:Event):void {
			super.deinit(e);
		}
		
		private function initScreenAssets():void {
			
			cont.tfUserName.text = ls.getData("tf.UserName");
			cont.tfPassword.text = ls.getData("tf.Password");
			cont.btnLogin.setLabel(ls.getData("btn.Login"));
			cont.btnLogin.addEventListener(MouseEvent.MOUSE_UP, onLoginPressed);
			cont.tfUserName.addEventListener(FocusEvent.FOCUS_IN, onUserNameFocusIn);
			cont.tfPassword.addEventListener(FocusEvent.FOCUS_IN, onPasswordFocusIn);
			
			if(super.thisPageWidth<700 ||
				super.thisPageWidth>800) {
				cont.scaleX = cont.scaleY = super.thisPageWidth / 720;
			}
			
			cont.tfWarn.visible = false;
			cont.tfWarn.htmlText = ls.getData("msg.wrongLogin");
			
		}
		
		
		
		
		private function onLoginPressed(e:MouseEvent):void {
			trace("onLoginPressed!");

			usr = cont.tfUserName.text;
			psw = cont.tfPassword.text;
			cont.btnLogin.visible = false;
			
			userLogin();
		}
		
		private function userLogin():void {
			var url:String = SERVER_PATH + "?l=" +  usr + "&lp=" + psw + "&lc=" + LanguageSettings.getInstance().getLangPfx();
			trace("URL: " + url);
			var request:URLRequest = new URLRequest(url);
			request.method = URLRequestMethod.GET;
			
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, loaderComleteHandler);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler, false, 0, true);
			
			try {
				urlLoader.load(request);
			} catch(err:Error) {
				trace(err);
			}
		}
		
		private function loaderComleteHandler(e:Event):void {
			trace("PopUpLogin.response: " + e.target.data);
			
			var res:Object = JSON.parse(e.target.data);
			if(res.rez=='1') {
				trace("User registered!");
				switchEnterCode();
			} else {
				trace("Incorrect login password!");
				cont.tfWarn.visible = true;
				TweenLite.to(this, 0, {delay:3, onComplete: function(){ cont.btnLogin.visible=true; cont.tfWarn.visible=false; }})
			}
		}
		
		private function ioErrorHandler( e:IOErrorEvent ):void {
			trace("ONLoader:ioErrorHandler: " + e);
			cont.tfWarn.text = ls.getData("pop.noConn");
			cont.tfWarn.visible = true;
		}
		
		private function switchEnterCode():void {
			trace("switchEnterCode");
			cont.btnLogin.removeEventListener(MouseEvent.MOUSE_UP, onLoginPressed);
			cont.tfUserName.removeEventListener(FocusEvent.FOCUS_IN, onUserNameFocusIn);
			cont.tfPassword.removeEventListener(FocusEvent.FOCUS_IN, onPasswordFocusIn);
			
			cont.gotoAndStop(2);
			cont.tf1.text = ls.getData("txt.EnterCode");
			cont.tfCode.text = ls.getData("txt.EnterCode");
			cont.tfCode.addEventListener(FocusEvent.FOCUS_IN, onCodeFocusIn);
			cont.btnSubmit.setLabel(ls.getData("btn.Confirm"));
			cont.btnSubmit.addEventListener(MouseEvent.MOUSE_UP, onSubmitPressed);
		}
		
		private function onSubmitPressed(e:MouseEvent):void {
			var url:String = NetworkManager.getInstance().SERVER + "pcconf?pconf=" +  cont.tfCode.text;
			trace("URL: " + url);
			var request:URLRequest = new URLRequest(url);
			request.method = URLRequestMethod.GET;
			
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, loaderComleteHandler2);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler, false, 0, true);
			
			try {
				urlLoader.load(request);
			} catch(err:Error) {
				trace(err);
			}
		}
		
		private function loaderComleteHandler2(e:Event):void {
			var mainData:String = e.target.data;
			
			trace("loaderComleteHandler2: " + mainData);
			
			if(mainData.length==11 && mainData.search("0")>0) {
				cont.btnSubmit.visible = false;
				cont.tfWarn.text = ls.getData("pop.incCode");
				cont.tfWarn.visible = true;
				
				TweenLite.to(this, 0, {delay:3, onComplete:function(){cont.tfWarn.visible = false; cont.btnSubmit.visible=true;}})
			} else {
				trace("ACCESS granted!");
				NetworkManager.getInstance().requestFor("services");
				dispatchEvent(new PopUpEvent(PopUpEvent.REFRESH, "reload"));
			}

		}
		
		
		
		
		
		
		
		
		
		private function onUserNameFocusIn(e:FocusEvent):void {
			tf.color = 0x000000;
			cont.tfUserName.defaultTextFormat = tf;
			if(cont.tfUserName.text==ls.getData("tf.UserName")) cont.tfUserName.text = "";
			cont.tfUserName.addEventListener(FocusEvent.FOCUS_OUT, onUserNameFocusOut);
		}
		
		private function onPasswordFocusIn(e:FocusEvent):void {
			tf.color = 0x000000;
			cont.tfPassword.defaultTextFormat = tf;
			if(cont.tfPassword.text==ls.getData("tf.Password")) cont.tfPassword.text = "";
			cont.tfPassword.displayAsPassword = true;
			cont.tfPassword.addEventListener(FocusEvent.FOCUS_OUT, onPasswordFocusOut);
		}
		
		private function onCodeFocusIn(e:FocusEvent):void {
			tf.color = 0x000000;
			cont.tfCode.defaultTextFormat = tf;
			if(cont.tfCode.text==ls.getData("txt.EnterCode")) cont.tfCode.text = "";
			cont.tfCode.addEventListener(FocusEvent.FOCUS_OUT, onCodeFocusOut);
		}
		
		private function onUserNameFocusOut(e:FocusEvent):void {
			if(cont.tfUserName.text=="" || cont.tfUserName.text==" ") {
				tf.color = 0x999999;
				cont.tfUserName.defaultTextFormat = tf;
				cont.tfUserName.text = ls.getData("tf.UserName");
			}
			cont.tfUserName.removeEventListener(FocusEvent.FOCUS_OUT, onUserNameFocusOut);
		}
		
		private function onPasswordFocusOut(e:FocusEvent):void {
			if(cont.tfPassword.text=="" || cont.tfPassword.text==" ") {
				tf.color = 0x999999;
				cont.tfPassword.defaultTextFormat = tf;
				cont.tfPassword.displayAsPassword = false;
				cont.tfPassword.text = ls.getData("tf.Password");
			}
			cont.tfPassword.removeEventListener(FocusEvent.FOCUS_OUT, onPasswordFocusOut);
		}
		
		private function onCodeFocusOut(e:FocusEvent):void {
			if(cont.tfCode.text=="" || cont.tfCode.text==" ") {
				tf.color = 0x999999;
				cont.tfCode.defaultTextFormat = tf;
				cont.tfCode.text = ls.getData("tf.Password");
			}
			cont.tfCode.removeEventListener(FocusEvent.FOCUS_OUT, onCodeFocusOut);
		}
		
	}
}