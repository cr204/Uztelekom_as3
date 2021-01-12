package com.uzbilling.pages {
	import flash.events.Event;
	import com.uzbilling.model.UserDetails;
	import com.uzbilling.controller.UserManager;
	import com.uzbilling.view.DetailsTextField;
	import com.greensock.TweenLite;
	import flash.events.MouseEvent;
	import com.uzbilling.events.SwitchPageEvent;
	import com.uzbilling.events.RightMenuEvent;
	import com.uzbilling.controller.ScreenManager;
	import com.uzbilling.model.Globals;
	
	public class PageUserInfo extends Page {
		private var startMouseY:Number = 0;
		private var initHolderY:Number = 0;
		
		public function PageUserInfo() {
			// constructor code
			super.thisPageName = "userInfo";
		}
		
		override protected function init(e:Event):void {
			super.init(e);
			initScreenAssets();
		}

		
		override protected function deinit(e:Event):void {
			super.deinit(e);
/*			dtHolder.alpha = 1;
			dtHolder.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownText);  */
			btnSlide.removeEventListener(MouseEvent.MOUSE_DOWN, onSlidePage);
		}
		
		override protected function onSlidePage(e:MouseEvent=null):void {
			//
			super.onSlidePage();
		}
		
		private function initScreenAssets():void {
			super.tHolder = dtHolder;
			super.btnSlide0 = btnSlide;
			super.btnRMenu0 = btnRMenu;
			super.top0 = top;
			super.screenBg0 = screenBg;
			
//			top.txtTitle.text = ls.getData("top.userInfo");
			top.setTitle(ls.getData("top.userInfo"));
/*			tmasker.y = top.height + 32;
			tmasker.width = super.thisPageWidth - 40;
			tmasker.height = super.thisPageHeight - 205;  */
			
			if(super.thisPageWidth<700 ||
			   super.thisPageWidth>800) {
				scaleContents();
			}
			
			super.initAssets();
			
			
			tscroll.setHeight(super.thisPageHeight - 235, 500);
			tscroll.x = super.thisPageWidth - 15;
//			tscroll.y = top.height + 30;
			tscroll.alpha = 0;
			
			initHolderY = dtHolder.y; // = top.height + 40;
			dtHolder.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownText);
			
/*			if(super.sliding) {
				dtHolder.alpha = 0;
				onDataLoaded();
			}*/
//			if(super.sliding) {
				startNetworkTracking(true);
//			}
		}
		
		override protected function onDataLoaded():void {
			//btnSlide.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_DOWN));
//			trace("UserInfo.onDataLoaded: " + super.loadedData);
			
			var res:Object = JSON.parse(super.loadedData);
				
			if (res.hasOwnProperty("state")) { 
				
				if(res.state=='1') {
					UserManager.getInstance().setUserDetails(res);
					//switchAfter(1);
					updateUserDetails();
				} else {
					trace("Error! Loading in PageUserInfo.onDataLoaded()");
					/*cont.txtIncorrect.htmlText = LanguageSettings.getInstance().getData("msg.wrongCode");
					cont.txtIncorrect.visible = true;
					cont.preloader.visible = false;
					TweenLite.to(this, 0, {delay:3, onComplete:function(){cont.txtIncorrect.visible = false;} });  */
				}
			}
			
			
			
			//updateUserDetails();
		}
		
		private function mouseDownText(e:MouseEvent):void {
			TweenLite.killTweensOf(tscroll);
			startMouseY = stage.mouseY;
			tscroll.alpha = 1;
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUpScreen);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMoveText);
		}
		
		private function onMouseUpScreen(e:MouseEvent):void {
			stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUpScreen);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMoveText);
			
			TweenLite.to(tscroll, 1, {delay:.5, alpha:0});
		}
		
		private function onMoveText(e:MouseEvent):void {
			var nextY:Number = dtHolder.y;
			var movPoz:int = startMouseY - stage.mouseY;
			if(movPoz<0) {
				nextY += Math.abs(movPoz);
			} else if(movPoz>0){
				nextY -= Math.abs(movPoz);
			}
			startMouseY = stage.mouseY;
			if(nextY>initHolderY) nextY=initHolderY;
			if(nextY<230) nextY=230;
			dtHolder.y = nextY;
	
			var scrPrc:Number = Math.round(Math.abs(230 - dtHolder.y));
//			trace("Scroll perc: " + scrPrc);
			tscroll.slidePerc(scrPrc);
		}

		private function updateUserDetails():void {
			var usr:UserDetails = UserManager.getInstance().getUserDetails();
//			top.setUserDetails(usr.subscriber);
			preloader.visible = false;
			
			// User full name
			var dt1:DetailsTextField = new DetailsTextField();
			dt1.x = 0;
			dt1.y = 0;
			dt1.setWidth(super.thisPageWidth - RIGHT_PADDING);
			dt1.setDetails(ls.getData("subscriber"), usr.subscriber, 1);
			dtHolder.addChild(dt1);
			
			var dt2:DetailsTextField = new DetailsTextField();
			dt2.setWidth(super.thisPageWidth - RIGHT_PADDING);
			dt2.y = dt1.y + dt1.height; //dtHolder.height;
			dt2.setDetails(ls.getData("address"), usr.from, 2);
			dtHolder.addChild(dt2);
			
			var dt3:DetailsTextField = new DetailsTextField();
			dt3.setWidth(super.thisPageWidth - RIGHT_PADDING);
			dt3.y = dt2.y + dt2.height; //dtHolder.height; // + TEXT_PADDING;
			dt3.setDetails(ls.getData("info.login"), usr.login, 9);
			dtHolder.addChild(dt3);
			
			var dt4:DetailsTextField = new DetailsTextField();
			dt4.setWidth(super.thisPageWidth - RIGHT_PADDING);
			dt4.y = dt3.y + dt3.height;
			dt4.setDetails(ls.getData("info.tarifName"), usr.tariff_name, 4);
			dtHolder.addChild(dt4);
			
			var dt5:DetailsTextField = new DetailsTextField();
			dt5.setWidth(super.thisPageWidth - RIGHT_PADDING);
			dt5.y = dt4.y + dt4.height;
			dt5.setDetails(ls.getData("info.trafficBalance"), usr.traffic_balance.toString(), 5);
			dtHolder.addChild(dt5);
			
			var dt6:DetailsTextField = new DetailsTextField();
			dt6.setWidth(super.thisPageWidth - RIGHT_PADDING);
			dt6.y = dt5.y + dt5.height;
			dt6.setDetails(ls.getData("info.mpayment"), usr.monthly_payment.toString(), 6);
			dtHolder.addChild(dt6);
			
			var dt7:DetailsTextField = new DetailsTextField();
			dt7.setWidth(super.thisPageWidth - RIGHT_PADDING);
			dt7.y = dt6.y + dt6.height;
			dt7.setDetails(ls.getData("info.curBalance"), usr.current_balance.toString(), 7);
			dtHolder.addChild(dt7);
			
			var dt8:DetailsTextField = new DetailsTextField();
			dt8.setWidth(super.thisPageWidth - RIGHT_PADDING);
			dt8.y = dt7.y + dt7.height;
			dt8.setDetails(ls.getData("info.limit"), usr.inet_tariff_capacity.toString(), 4);
			dtHolder.addChild(dt8);
			
			var dt9:DetailsTextField = new DetailsTextField();
			dt9.setWidth(super.thisPageWidth - RIGHT_PADDING);
			dt9.x = 0;
			dt9.y = dt8.y + dt8.height;
			dt9.setDetails(ls.getData("info.traficWorld"), usr.traffic_world.toString(), 8);
			dtHolder.addChild(dt9);
			
			var dt10:DetailsTextField = new DetailsTextField();
			dt10.setWidth(super.thisPageWidth - RIGHT_PADDING);
			dt10.y = dt9.y + dt9.height;
			dt10.setDetails(ls.getData("info.traficTasX"), usr.traffic_tasix.toString(), 1);
			dtHolder.addChild(dt10);
			
			Globals.getInstance().tariff_id = usr.tariff_id;
			Globals.getInstance().reservedTarifID = usr.reserved_tariff;
			
			dtHolder.mouseChildren = false;
		}
		
		
		private function scaleContents():void {
			var ratio:Number = super.thisPageWidth / ScreenManager.aspectRation
			
			btnSlide.scaleX = btnSlide.scaleY = ratio;
			btnRMenu.scaleX = btnRMenu.scaleY = ratio;
			
			top.scaleX = top.scaleY = ratio;
			userPhoto.scaleX = userPhoto.scaleY = ratio;
			userPhoto.y = top.height;
			
			tscroll.y = userPhoto.y + userPhoto.height;
			//tscroll.x is sorted out at top in initScreenAssets()
			
			tmasker.scaleX = tmasker.scaleY = ratio;
			tmasker.y = userPhoto.y + userPhoto.height;
			
			dtHolder.scaleX = dtHolder.scaleY = ratio * .95;
			dtHolder.y = userPhoto.y + userPhoto.height;
		}


		
	}
	
}