package com.uzbilling.pages {

	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.URLLoader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequestMethod;
	import flash.net.URLRequestHeader;
	import flash.net.URLVariables;
	import flash.events.FocusEvent;
	import flash.text.TextFormat;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.net.navigateToURL;
	import flash.net.URLVariables;
	
	import com.greensock.TweenLite;
	import com.greensock.TweenLite;
	import com.uzbilling.controller.UserManager;
	import com.uzbilling.controller.NetworkManager;
	import com.uzbilling.events.PopUpEvent;
	import com.uzbilling.controller.LanguageSettings;
	import flash.text.TextField;
	import com.uzbilling.events.LanguageEvent;
	import com.uzbilling.controller.ScreenManager;
	import com.uzbilling.model.Globals
	

	
	public class PageLogin extends Page {
		private var SERVER_PATH:String; // = "http://192.168.1.102:8080/pclogin";
		private const LOCAL_PATH:String = "http://localhost/uzbilling/pclogin.php";

		private var usr:String = new String();
		private var psw:String = new String();
		private var tf:TextFormat = new TextFormat();
		
		public function PageLogin() {
			// constructor code
			super.thisPageName = "login";
			SERVER_PATH = NetworkManager.getInstance().USER_AUTH;
		}
		
		override protected function init(e:Event):void {
			super.init(e);
			super.screenBg0 = screenBg;
			cont.btnLogin.addEventListener(MouseEvent.MOUSE_UP, onLoginPressed);
			cont.btnReg.addEventListener(MouseEvent.MOUSE_UP, onRegister);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
			initScreenAssets();
		}
		
		override protected function deinit(e:Event):void {
			super.deinit(e);
			cont.btnLogin.removeEventListener(MouseEvent.MOUSE_UP, onLoginPressed);
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
			cont.tfUserName.removeEventListener(FocusEvent.FOCUS_IN, onUserNameFocusIn);
			cont.tfPassword.removeEventListener(FocusEvent.FOCUS_IN, onPasswordFocusIn);
			btnLang.removeEventListener(MouseEvent.MOUSE_DOWN, showLangPane);
		}
		
		private function initScreenAssets():void {
			super.initAssets();
			cont.preloader.visible = false;
			
			
			trace("ScreenManager.aspectRation: " + ScreenManager.aspectRation);

			if(super.thisPageWidth<700 ||
			   super.thisPageWidth>800) {
				scaleContents();
			}

			
			initTextContents();
			
			cont.x = Math.round((super.thisPageWidth - cont.width) * .5);
			cont.tfUserName.addEventListener(FocusEvent.FOCUS_IN, onUserNameFocusIn);
			cont.tfPassword.addEventListener(FocusEvent.FOCUS_IN, onPasswordFocusIn);
			btnLang.addEventListener(MouseEvent.MOUSE_DOWN, showLangPane);
			cont.txtIncorrect.visible = false;
			
			btnLang.txt.text = LanguageSettings.getInstance().getLangPrefix();
			paneLang.y = super.thisPageHeight;
		}
		
		private function initTextContents():void {
			cont.tfUserName.text = ls.getData("tf.UserName");
			cont.tfPassword.text = ls.getData("tf.Password");
			cont.btnLogin.setLabel(ls.getData("btn.Login"));
			cont.txtIncorrect.htmlText = ls.getData("msg.wrongLogin");
			cont.btnReg.htmlText = ls.getData("msg.SignUp");
		}
		
		private function onRegister(e:MouseEvent):void {
			var url:String = NetworkManager.getInstance().ZAYAVKA_URL;
			trace("navToURL: " + url);
			
			var urlReq = new URLRequest(url);
			try {
				navigateToURL(urlReq);
			} catch (e:Error) {
				trace("Error occured when connected!");
			}
		}
		
		private function showLangPane(e:MouseEvent):void {
			btnLang.visible = false;
			TweenLite.to(paneLang, .3, {y:(super.thisPageHeight - paneLang.height)});
			paneLang.addEventListener(MouseEvent.MOUSE_DOWN, selLanguage);
		}
		
		private function selLanguage(e:MouseEvent):void {
			var langID:int = 0;
			switch(e.target.name) {
				case "t1":
					langID = 1;
					btnLang.txt.text = "Уз";
					break;
				case "t2":
					langID = 2;
					btnLang.txt.text = "O'z";
					break;
				case "t3":
					langID = 0;
					btnLang.txt.text = "Ру";
					break;
			}
			btnLang.visible = true;
			TweenLite.to(paneLang, .3, {y:super.thisPageHeight});
			paneLang.removeEventListener(MouseEvent.MOUSE_DOWN, selLanguage);
			LanguageSettings.getInstance().languageID(langID);
			initTextContents();
			this.dispatchEvent(new LanguageEvent(LanguageEvent.CHANGED));
		}
		
		
		private function keyDownHandler(e:KeyboardEvent):void {
			switch(e.keyCode) {
				case Keyboard.ENTER:
					onLoginPressed();
					stage.focus = null;
					break;
			}
		}
		
		private function onUserNameFocusIn(e:FocusEvent):void {
			if(cont.tfUserName.text==ls.getData("tf.UserName")) cont.tfUserName.text = "";
//			tf.color = 0x000000;
//			cont.tfUserName.defaultTextFormat = tf;
			cont.tfUserName.addEventListener(FocusEvent.FOCUS_OUT, onUserNameFocusOut);
		}
		
		private function onPasswordFocusIn(e:FocusEvent):void {
			if(cont.tfPassword.text==ls.getData("tf.Password")) cont.tfPassword.text = "";
//			tf.color = 0x000000;
//			cont.tfPassword.defaultTextFormat = tf;
			cont.tfPassword.displayAsPassword = true;
			cont.tfPassword.addEventListener(FocusEvent.FOCUS_OUT, onPasswordFocusOut);
		}
		
		private function onUserNameFocusOut(e:FocusEvent):void {
			if(cont.tfUserName.text=="" || cont.tfUserName.text==" ") {
				cont.tfUserName.displayAsPassword = false;
//				tf.color = 0x999999;
//				cont.tfUserName.defaultTextFormat = tf;
				cont.tfUserName.text = ls.getData("tf.UserName");
			}
			cont.tfUserName.removeEventListener(FocusEvent.FOCUS_OUT, onUserNameFocusOut);
		}
		
		private function onPasswordFocusOut(e:FocusEvent):void {
			if(cont.tfPassword.text=="" || cont.tfPassword.text==" ") {
				cont.tfPassword.displayAsPassword = false;
//				tf.color = 0x999999;
//				cont.tfPassword.defaultTextFormat = tf;
				cont.tfPassword.text = ls.getData("tf.Password");
			}
			cont.tfPassword.removeEventListener(FocusEvent.FOCUS_OUT, onPasswordFocusOut);
		}

		private function onLoginPressed(e:MouseEvent=null):void {
			usr = cont.tfUserName.text;
			psw = cont.tfPassword.text;
			
			cont.preloader.visible =true;
			
			//switchAfter(1);
			userLogin();
		}
		
		private function userLogin():void {
			var hdr:URLRequestHeader = new URLRequestHeader("Content-type", "application/json");
			var request:URLRequest = new URLRequest(SERVER_PATH)
			
			var mesObject:Object =
			{
				"username":usr,
				"password":psw
			};
		
			
			var jsonString:String = JSON.stringify(mesObject);
			
			request.requestHeaders.push(hdr);
			request.method = URLRequestMethod.POST;
			request.data = jsonString; 
			
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
			//trace("UserLogin.response: " + e.target.data);
			var json_in = JSON.parse(e.target.data);
			
			if (json_in.hasOwnProperty("state")) {
				if(json_in.state == '1') {
					trace("User registered!");
					switchAfter(1);
				} else {
					trace("Incorrect login password!");
					cont.preloader.visible = false;
					cont.txtIncorrect.visible = true;
					TweenLite.to(this, 0, {delay:3, onComplete:function(){cont.txtIncorrect.visible = false;} });
				}
				
			}
			
			
			if (json_in.hasOwnProperty("token"))
			{
				Globals.getInstance().token = json_in.token;
			}
			
		}
		
		private function ioErrorHandler( e:IOErrorEvent ):void {
			trace("ONLoader:ioErrorHandler: " + e);
			cont.preloader.visible = false;
//			cont.incorrect.visible = false;
			this.dispatchEvent(new PopUpEvent(PopUpEvent.POPUP, "no_connection"));
		}

		
		private function switchAfter(n:int):void {
			TweenLite.to(this, 0, {delay:n, onComplete:function(){ switchPage("userInfo"); }});
		}
		
		private function scaleContents():void {
			var ratio:Number = super.thisPageWidth / ScreenManager.aspectRation;
			cont.scaleX = cont.scaleY = ratio;
			
			cont.y = super.thisPageHeight * .13;
			
			btnLang.x = super.thisPageWidth - btnLang.width * ratio;
			btnLang.y = super.thisPageHeight - btnLang.height * ratio;
			btnLang.scaleX = btnLang.scaleY = ratio;

			paneLang.scaleX = paneLang.scaleY = ratio;
			paneLang.x = (super.thisPageWidth - paneLang.width) * .5;
			paneLang.y = (super.thisPageHeight - paneLang.height) * .9;
		}
		

		
	}
}