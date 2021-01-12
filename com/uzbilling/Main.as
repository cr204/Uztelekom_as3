package com.uzbilling {
	import flash.display.MovieClip;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.NetStatusEvent;
	import flash.net.NetworkInfo;
	import flash.net.SharedObject;
	import flash.net.SharedObjectFlushStatus;
	
	import com.greensock.TweenLite;
	import com.greensock.easing.Quart;

    import com.uzbilling.pages.Page;
	import com.uzbilling.controller.PageManager;
	import com.uzbilling.events.SwitchPageEvent;
	import com.uzbilling.controller.UserManager;
	import com.uzbilling.controller.ScreenManager;
	import com.uzbilling.pages.PageLeftMenu;
	import com.uzbilling.events.SlidePageEvent;
	import com.uzbilling.controller.NetworkManager;
	import com.uzbilling.events.NetworkDataEvent;
//	import com.uzbilling.view.PopUpNoConnection;
	import com.uzbilling.view.PopUp;
	import com.uzbilling.controller.PopUpManager;
	import com.uzbilling.events.PopUpEvent;
	import com.uzbilling.events.RightMenuEvent;
	import com.uzbilling.view.RightHandMenu;
	import com.uzbilling.controller.LanguageSettings;
	import com.uzbilling.events.RadioButtonEvent;
	import com.uzbilling.events.LanguageEvent;
	import com.uzbilling.pages.PageWelcome;
	import flash.events.TransformGestureEvent;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	
	public class Main extends MovieClip {
		private var pageLeftMenu:PageLeftMenu;
		private var rightHandMenu:RightHandMenu;
		private var appStarted:Boolean = false;
		private var refreshPg:Boolean = false;
		private var mySo:SharedObject;
		
		public function Main() {
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			Multitouch.inputMode = MultitouchInputMode.GESTURE;
			
			mySo = SharedObject.getLocal("uzbilling");
			var langID:int = mySo.data.savedValue;
			
			ScreenManager.getInstance().setDeviceType(0);
			
			if(!langID) {
				langID = 0;
				mySo.data.savedValue = langID;
				onFlushDisk();
			}
			
			//networkInterfaceInfo();
			LanguageSettings.getInstance().init();
			LanguageSettings.getInstance().languageID(langID);
			
			//stage.addEventListener(Event.RESIZE, appResizeHandler);
			appResizeHandler();
		}
		
		private function networkInterfaceInfo():void {
			var networkInterface:Object = NetworkInfo.networkInfo.findInterfaces();
			var networkInfo:Object = networkInterface[0];
			var strNet:String = networkInfo.hardwareAddress.toString();
			UserManager.getInstance().setMacAdress(strNet);
			trace("networkInterfaceInfo: " + strNet);
		}
		
		
		private function startApplication():void {
			if(!appStarted) {
				appStarted = true;
				
				trace("Show wecome page!")				
				showPage("welcome");
			}
		}
		
		private function showPage(pg:String, slide:Boolean=false):void {
			var page:Page = PageManager.getInstance().getPage(pg);

			if (page) {
				page.addEventListener(SwitchPageEvent.SWITCHED, onPageSwitched);
				page.addEventListener(SwitchPageEvent.SLIDED, onPageSlided);
				page.addEventListener(RightMenuEvent.OPENED, openRightMenu);
				page.addEventListener(PopUpEvent.POPUP, showPopUp);
				if (holder.numChildren > 0) {
					var prevPage:Page = holder.getChildAt(0) as Page;
					prevPage.removeEventListener(SwitchPageEvent.SWITCHED, onPageSwitched);
					prevPage.removeEventListener(SwitchPageEvent.SLIDED, onPageSlided);
					prevPage.removeEventListener(RightMenuEvent.OPENED, openRightMenu);
					prevPage.removeEventListener(PopUpEvent.POPUP, showPopUp);
					if(prevPage.pageName=="login") prevPage.removeEventListener(LanguageEvent.CHANGED, updateLanguageSO);
					holder.removeChild(prevPage);
					prevPage = null;
				}
				if(slide) page.slide(true);
								
				if(page.pageName=="userInfo") {
					if(!pageLeftMenu) {
						pageLeftMenu = new PageLeftMenu();
						pageLeftMenu.addEventListener(SlidePageEvent.SLIDED_SWITCH, slidedSwitchEventHandler);
						holder0.addChild(pageLeftMenu);
						
						NetworkManager.getInstance().requestFor("subscriber");
						
						holder.addEventListener(TransformGestureEvent.GESTURE_SWIPE, onSwipe);
					} else {
						// When User Info page pressed from Left Hand Menu
						if(!refreshPg) onPageSlided();
					}
				} else if(page.pageName=="login") {
					page.addEventListener(LanguageEvent.CHANGED, updateLanguageSO);
				}
				
				
				trace("refreshPg: " + refreshPg);
				
				if(refreshPg) {
					page.refreshPage();
					refreshPg = false;
				}
				holder.addChild(page);
			}
		}
		
		private function onSwipe(e:TransformGestureEvent):void {
			if(e.offsetX == 1) {
				trace("To Right!");
				if(holder.x<50) onPageSlided();
			}
			if(e.offsetX == -1) {
				trace("To Left!");
				if(holder.x>50) onPageSlided();
			}
		}
		
		private function showPopUp(e:PopUpEvent):void {
			showPopUpWindow(e.popUpID);
		}
		
		private function showPopUpWindow(pu:String):void {
			var popUp:PopUp = PopUpManager.getInstance().getPopUp(pu);
			
			if(popUp) {
				trace("showPopUpWindow: " + pu);
				popUp.addEventListener(PopUpEvent.REFRESH, langRefresh);
				popUp.addEventListener(PopUpEvent.CLOSE, hidePopUpWindow);
				pHolder.addChild(popUp);
			}
		}
		
		private function hidePopUpWindow(e:PopUpEvent=null):void {
			if(pHolder.numChildren>0) {
				var popUp:PopUp = pHolder.getChildAt(0) as PopUp;
				popUp.removeEventListener(PopUpEvent.REFRESH, langRefresh);
				popUp.removeEventListener(PopUpEvent.CLOSE, hidePopUpWindow);
				pHolder.removeChildAt(0);
			}
		}
		
		private function langRefresh(e:PopUpEvent):void {
			if(e.popUpID=="reload") {
				// Used when session out of time!
				if(holder.numChildren>0) {
					trace("RELAOD!");
					var currPage:Page = holder.getChildAt(0) as Page;
					NetworkManager.getInstance().requestFor(currPage.thisPageName);
					currPage.startNetworkTracking(true);
					hidePopUpWindow();
				}
			} else {
				updateLanguageSO();
				refreshPg = true;
				showPage("userInfo");
				pageLeftMenu.initScreenAssets();
			}
		}
		
		private function updateLanguageSO(e:LanguageEvent=null):void {
			mySo.data.savedValue = LanguageSettings.getInstance().getLangID();
			onFlushDisk();
		}
		
		private function slidedSwitchEventHandler(e:SlidePageEvent):void {
			NetworkManager.getInstance().requestFor(e.pageID);
			
			showPage(e.pageID, true);
		}
		
		private function onPageSwitched(e:SwitchPageEvent):void {
			showPage(e.pageID);
			if(e.pageID=="first_video" || e.pageID=="second_video") {
				// stageBg.visible = false;
			}
		}
		
		private function onPageSlided(e:SwitchPageEvent=null):void {
			if(holder.x>0) {
				TweenLite.to(holder, .8, {x:0, ease:Quart.easeInOut});
			} else {
			  	TweenLite.to(holder, .8, {x:stage.stageWidth-100 * (stage.stageWidth / 720), ease:Quart.easeInOut});
			}
		}
		
		
		private function appResizeHandler(e:Event=null):void{
			trace("stageWidth: " + stage.stageWidth);
			trace("stageHeight: " + stage.stageHeight);
			ScreenManager.getInstance().setScreenSize(stage.stageWidth, stage.stageHeight);
			
            updateDisplayList();
			
			startApplication();
        }
		
		private function updateDisplayList():void {
			if(!rightHandMenu) {
				rightHandMenu = new RightHandMenu();
				rightHandMenu.addEventListener(RightMenuEvent.PRESSED, rightMenuPressed);
			}
        }
		
		private function openRightMenu(e:RightMenuEvent):void {
			rightHandMenu.addEventListener(RightMenuEvent.CLOSED, closeRightMenu);
			pHolder.addChild(rightHandMenu);
		}
		
		private function closeRightMenu(e:RightMenuEvent):void {
			pHolder.removeChild(rightHandMenu);
		}
		
		
		private function rightMenuPressed(e:RightMenuEvent):void {
			trace("rightMenuPressed.e: " + e.menuID);
			switch(e.menuID) {
				case "refresh":
					refreshPg = true;
					showPage("subscriber");
					break;
				case "changePass":
					showPopUpWindow("changePass");
					break;
				case "language":
					showPopUpWindow("language");
					break;
				case "about":
					showPopUpWindow("about");
					break;
				case "help":
					showPopUpWindow("help");
					break;
				case "logout":
					holder.removeEventListener(TransformGestureEvent.GESTURE_SWIPE, onSwipe);
					showPage("login");
					break;
			}
		}
		
		
		private function onFlushDisk():void {
			var flushStatus:String = null;
			try {
				flushStatus = mySo.flush(10000);
			} catch (error:Error) {
				trace("Error... Could not write SharedObject to disk.")
			}
			if (flushStatus != null) {
				switch (flushStatus) {
					case SharedObjectFlushStatus.PENDING:
						trace("Requesting permission to save object...");
						mySo.addEventListener(NetStatusEvent.NET_STATUS, onFlushStatus);
						break;
					case SharedObjectFlushStatus.FLUSHED:
						trace("Value flushed to disk.");
						break;
				}
			}
		}
		
		private function onFlushStatus(event:NetStatusEvent):void {
			trace("User closed permission dialog...");
			switch (event.info.code) {
				case "SharedObject.Flush.Success":
					trace("User granted permission -- value saved.");
					break;
				case "SharedObject.Flush.Failed":
					trace("User denied permission -- value not saved.\n");
					break;
			}
		
			mySo.removeEventListener(NetStatusEvent.NET_STATUS, onFlushStatus);
		}

	
	}
}