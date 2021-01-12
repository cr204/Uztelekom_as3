package com.uzbilling.pages {
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLLoader;
	import flash.events.IOErrorEvent;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import com.greensock.TweenLite;
	import com.uzbilling.controller.UserManager;
	import com.uzbilling.controller.NetworkManager;
	import flash.events.FocusEvent;

//	import com.uzbilling.events.PopUpEvent;
	import com.uzbilling.model.SelectList;
	import com.uzbilling.controller.ScreenManager;
	import com.uzbilling.controller.LanguageSettings;
	import flash.net.navigateToURL;
	import flash.net.URLVariables;
	import flash.net.URLRequestHeader;
	import flash.geom.ColorTransform;
	

	public class PageEnterCode extends Page {
		private var SERVER_PATH:String; // = "http://192.168.1.102:8080/pcconf";
		private const LOCAL_PATH:String = "http://localhost/uzbilling/pcconf.php";

		private var code:String = new String();
		private var ct:ColorTransform=new ColorTransform();
		
		public function PageEnterCode() {
			// constructor code
			SERVER_PATH = NetworkManager.getInstance().CODE_SEND
		}
		
		override protected function init(e:Event):void {
			super.init(e);
			super.screenBg0 = screenBg;
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
//			
			initScreenAssets();
//			stage.focus = cont.tfCode;
//			
//			cont.preloader.visible = false;
			cont.btnConfirm.addEventListener(MouseEvent.MOUSE_UP, onConfirmPressed);
		}
		
		override protected function deinit(e:Event):void {
			super.deinit(e);
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
			cont.btnConfirm.removeEventListener(MouseEvent.MOUSE_UP, onConfirmPressed);
		}
				
		private function initScreenAssets():void {
			super.initAssets()
			
			cont.txtIncorrect.visible = false;
			cont.tfCode.text = ls.getData("txt.EnterCode");
			cont.btnConfirm.setLabel(ls.getData("btn.Confirm"));
			cont.btnResend.text = ls.getData("btn.Confirm2");
//			cont.btnConfirm2.visible = false;
			cont.preloader.visible = false;
			
			if(super.thisPageWidth<700 ||
			   super.thisPageWidth>800) {
				cont.scaleX = cont.scaleY = super.thisPageWidth / ScreenManager.aspectRation;
				cont.y = super.thisPageHeight * .13;
			}
			cont.x = Math.round((super.thisPageWidth - cont.width) * .5);
			
//			bottomText.y = super.thisPageHeight - bottomText.height + 20;
			cont.tfCode.addEventListener(FocusEvent.FOCUS_IN, onTFFocusIn);
			cont.btnResend.addEventListener(MouseEvent.MOUSE_UP, onResend);
		}
		
		private function onResend(e:MouseEvent):void {
			var url:String = NetworkManager.getInstance().CODE_RESEND;
			trace("Resend Code.navToURL: " + url);
			
			var urlReq = new URLRequest(url);
			var reqVars:URLVariables = new URLVariables();
			reqVars.pcrconfirm = "";
			
			urlReq.data = reqVars;
			urlReq.method = URLRequestMethod.POST;
			
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, codeResendHandler);
			
			try {
				urlLoader.load(urlReq);
				cont.btnResend.visible = false;
			} catch(err:Error) {
				trace(err);
			}
			
			TweenLite.to(this, 0, {delay:.5, onComplete:function(){ resendMsg(); }});
		}
		
		private function resendMsg():void {
			cont.btnResend.text = LanguageSettings.getInstance().getData("msg.resend");
			tintClip(cont.btnResend, 0x00FF00);
			cont.btnResend.removeEventListener(MouseEvent.MOUSE_UP, onResend);
			cont.btnResend.visible = true;
			
			TweenLite.to(this, 0, {delay:8, onComplete:function(){ 
						 	cont.btnResend.text = LanguageSettings.getInstance().getData("btn.Confirm2");
							tintClip(cont.btnResend, 0xFFFFFF);
							cont.btnResend.addEventListener(MouseEvent.MOUSE_UP, onResend);
						 }});
		}
		
		private function codeResendHandler(e:Event):void {
			trace("codeResendHandler: " + e.target.data);
		}		
		
		private function onTFFocusIn(e:FocusEvent):void {
			if(cont.tfCode.text==ls.getData("txt.EnterCode")) cont.tfCode.text = "";
			cont.tfCode.addEventListener(FocusEvent.FOCUS_OUT, onTFFocusOut);
		}
		
		private function onTFFocusOut(e:FocusEvent):void {
			if(cont.tfCode.text=="" || cont.tfCode.text==" ") {
				cont.tfCode.text = ls.getData("txt.EnterCode");
			}
			cont.tfCode.removeEventListener(FocusEvent.FOCUS_OUT, onTFFocusOut);
		}
		
		private function keyDownHandler(e:KeyboardEvent):void {
			switch(e.keyCode) {
				case Keyboard.BACK:
					switchPage("login");
					e.preventDefault()
					e.stopImmediatePropagation();
					break;
				case Keyboard.ENTER:
					if(cont.tfCode.text != "") {
						cont.btnConfirm.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_UP));
						stage.focus = null;
					}
					break;
			}
		}

		
		private function onConfirmPressed(e:MouseEvent):void {
			code = cont.tfCode.text;
			cont.preloader.visible = true;
			
			userConfirm();
//			switchAfter(1);
		}
		
		
/*		private function userLogin():void {
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
		}  */

		private function userConfirm():void {
			cont.preloader.visible = true;
//			var url:String = SERVER_PATH + "?pconf=" +  code;
//			trace("EnterCode.URL: " + url);
			var hdr:URLRequestHeader = new URLRequestHeader("Content-type", "application/json");
			var request:URLRequest = new URLRequest(SERVER_PATH)
			
			var mesObject:Object =
			{
				"tell":code
			};
			
//			var request:URLRequest = new URLRequest(SERVER_PATH);
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
			trace("UserCode.response: " + e.target.data);
//			cont.btnConfirm2.visible = true;
			
			var res:Object = JSON.parse(e.target.data);
			if(res.rez=='0') {
				trace("Incorrect CODE!");
				cont.txtIncorrect.htmlText = LanguageSettings.getInstance().getData("msg.wrongCode");
				cont.txtIncorrect.visible = true;
				cont.preloader.visible = false;
				TweenLite.to(this, 0, {delay:3, onComplete:function(){cont.txtIncorrect.visible = false;} });
			} else {
				UserManager.getInstance().setUserDetails(res);
				SelectList.getInstance().init();
				switchAfter(1);
			}
			
		}
		
		private function ioErrorHandler( e:IOErrorEvent ):void {
//			cont.btnConfirm2.visible = true;
			cont.tfCode.text = "";
			cont.preloader.visible = false;
//			this.dispatchEvent(new PopUpEvent(PopUpEvent.POPUP, "no_connection"));
		}
		
		
		private function switchAfter(n:int):void {
			TweenLite.to(this, 0, {delay:n, onComplete:function(){ switchPage("userInfo"); }});
		}
		
		
		private function tintClip(obj:*, c:uint):void {
			
			var color:uint=c; //picker.selectedColor;
			var mul:Number=1; //slider.value/100;
			var ctMul:Number=(1-mul);
			var ctRedOff:Number=Math.round(mul*extractRed(color));
			var ctGreenOff:Number=Math.round(mul*extractGreen(color));
			var ctBlueOff:Number=Math.round(mul*extractBlue(color));
			ct=new ColorTransform(ctMul,ctMul,ctMul,1,ctRedOff,ctGreenOff,ctBlueOff,0);
			obj.transform.colorTransform=ct;
		}
		
		
		private function extractRed(c:uint):uint {
			return (( c >> 16 ) & 0xFF);
		}
		
		private function extractGreen(c:uint):uint {
			return ( (c >> 8) & 0xFF );
		}
		
		private function extractBlue(c:uint):uint {
			return ( c & 0xFF );
		}
		
	}
	
}