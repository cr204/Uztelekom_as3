package com.uzbilling.view {
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.FocusEvent;
	import flash.text.TextFormat;
	import flash.text.TextField;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLLoader;
	import flash.events.IOErrorEvent;
	import flash.net.URLVariables;
	import com.greensock.TweenLite;
	import com.uzbilling.events.PopUpEvent;
	import com.uzbilling.controller.NetworkManager;
	
	public class PopUpChangePassword extends PopUp {
		private var SERVER_PATH:String;
		private var tf:TextFormat = new TextFormat();
		
		public function PopUpChangePassword() {
			// constructor code
		}
		
		override protected function init(e:Event):void {
			super.init(e);
			SERVER_PATH = NetworkManager.getInstance().SERVER;
			initScreenAssets();
		}

		
		override protected function deinit(e:Event):void {
			super.deinit(e);
		}
		
		override public function updateTexts(s1:String, s2:String):void {
			cont.tf1.text = s1;
		}
		
		private function initScreenAssets():void {
			screenBg.width = super.thisPageWidth;
			screenBg.height = super.thisPageHeight;
			
			cont.tf1.text = ls.getData("mn.pas");
			cont.tfPass1.text = ls.getData("pop.currPass");
			cont.tfPass2.text = ls.getData("pop.newPass");
			cont.tfPass3.text = ls.getData("pop.confPass");
			cont.btnOk.setLabel(ls.getData("btn.OK"));
			cont.tfWarn.visible = false;
			
			if(super.thisPageWidth<700 ||
			   super.thisPageWidth>800) {
				cont.scaleX = cont.scaleY = super.thisPageWidth / 720;
			}
			
			cont.x = Math.round((super.thisPageWidth - cont.width) * .5);
			cont.tfPass1.addEventListener(FocusEvent.FOCUS_IN, onTextFieldFocusIn);
			cont.tfPass2.addEventListener(FocusEvent.FOCUS_IN, onTextFieldFocusIn);
			cont.tfPass3.addEventListener(FocusEvent.FOCUS_IN, onTextFieldFocusIn);
			cont.btnOk.addEventListener(MouseEvent.MOUSE_UP, onOKPressed);
			screenBg.addEventListener(MouseEvent.MOUSE_DOWN, onClosePopUp);
		}
				
		private function onTextFieldFocusIn(e:FocusEvent):void {
			var targetTF:TextField = e.target as TextField;
			switch(targetTF.name) {
				case "tfPass1":
					if(targetTF.text==ls.getData("pop.currPass")) targetTF.text = "";
					break;
				case "tfPass2":
					if(targetTF.text==ls.getData("pop.newPass")) targetTF.text = "";
					break;
				case "tfPass3":
					if(targetTF.text==ls.getData("pop.confPass")) targetTF.text = "";
					break;
			}
			
			tf.color = 0x000000;
			targetTF.defaultTextFormat = tf;
			targetTF.displayAsPassword = true;
			targetTF.addEventListener(FocusEvent.FOCUS_OUT, onTextFieldFocusOut);
		}
		
		private function onTextFieldFocusOut(e:FocusEvent):void {
			var targetTF:TextField = e.target as TextField;
			
			if(trimWhitespace(targetTF.text)=="" || targetTF.text==" ") {
				targetTF.displayAsPassword = false;
				tf.color = 0x999999;
				targetTF.defaultTextFormat = tf;
				switch(targetTF.name) {
					case "tfPass1":
						targetTF.text = ls.getData("pop.currPass");
						break;
					case "tfPass2":
						targetTF.text = ls.getData("pop.newPass");
						break;
					case "tfPass3":
						targetTF.text = ls.getData("pop.confPass");
						break;
				}
			}
			targetTF.removeEventListener(FocusEvent.FOCUS_OUT, onTextFieldFocusOut);
		}
		
		private function onOKPressed(e:MouseEvent):void {
			if(cont.tfPass1.text!=ls.getData("pop.currPass") &&
			   cont.tfPass2.text!=ls.getData("pop.newPass") &&
			   cont.tfPass3.text!=ls.getData("pop.confPass")) {
				   
					if(cont.tfPass2.text == cont.tfPass3.text) {
						sendNewPassword();
					} else {
						showWarning("Confirmation password doesn't match!");
					}
			}
		}
		
		
		private function sendNewPassword():void {
			// var url:String = SERVER_PATH + "pcchPass?p0=" +  cont.tfPass1.text + "&p1=" + cont.tfPass2.text;
			var url:String = SERVER_PATH + "pcchPass";
			trace("URL: " + url);
			var request:URLRequest = new URLRequest(url);
			var reqVars:URLVariables = new URLVariables();
			reqVars.p0 = cont.tfPass1.text;
			reqVars.p1 = cont.tfPass2.text;
			
			request.data = reqVars;
			request.method = URLRequestMethod.POST;
			
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, loaderComleteHandler);
//			urlLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler, false, 0, true);
			
			try {
				urlLoader.load(request);
			} catch(err:Error) {
				trace(err);
			}
		}
		
		private function loaderComleteHandler(e:Event):void {
			trace("UserLogin.response: " + e.target.data);
			
			var res:Object = JSON.parse(e.target.data);
			if(res.res=='0') {
				showWarning("Current password is not correct!");
			} else {
				onClosePopUp();
			}
		}
		
		private function ioErrorHandler( e:IOErrorEvent ):void {
			showWarning("Can not connect to server!");
		}
		
		private function onClosePopUp(e:MouseEvent=null):void {
			this.dispatchEvent(new PopUpEvent(PopUpEvent.CLOSE));
		}
		
		private function showWarning(s:String):void {
			cont.tfWarn.text = s;
			cont.tfWarn.visible = true;
			cont.btnOk.visible = false;
			TweenLite.to(this, 0, {delay:3, onComplete:function(){cont.tfWarn.visible=false; cont.btnOk.visible=true;} });
		}
		
		private function trimWhitespace(str:String):String {
			if(str == null) {
				return "";
			}
			return str.replace(/^\s+|\s+$/g, "");
		}
		
		
	}
}