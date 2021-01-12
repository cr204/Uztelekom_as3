package com.uzbilling.pages {
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.display.Sprite;	
	import com.uzbilling.model.UserDetails;
	import com.uzbilling.view.DetailsTextField;
	import com.uzbilling.controller.UserManager;
	import com.uzbilling.controller.NetworkManager;
	import com.uzbilling.events.SwitchPageEvent;
	import com.uzbilling.events.SliderInfoEvent;
	import com.greensock.TweenLite;
	import com.uzbilling.events.InfoCellEvent;
	import com.uzbilling.controller.ScrollManager;
	import com.uzbilling.view.InfoCellNoData;
	import com.uzbilling.view.InfoCellAdditionals;
	import com.uzbilling.events.PopUpEvent;
	import com.uzbilling.view.PopUp;
	import com.uzbilling.controller.PopUpManager;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import com.uzbilling.view.PopUpServiceConfirm;
	import com.uzbilling.events.RadioButtonEvent;
	import com.uzbilling.model.Period;
	import com.uzbilling.model.PhoneList;
	import com.uzbilling.controller.ScreenManager;
	
	public class PageAdditionals extends PageSliding {
		private var startMouseY:Number = 0;
		private var initHolderY:Number = 0;
		private var hMoved:Boolean = false;
		private var nTimer2:Timer;
		private var popUp:PopUp;
		private var selCell:InfoCellAdditionals;
		private var selServID:String;
		private var selServST:String;
		
		public function PageAdditionals() {
			// constructor code
			super.thisPageName = "additionals";
		}
		
		override protected function init(e:Event):void {
			super.init(e);
			initScreenAssets();
		}
		
		private function initScreenAssets():void {
			super.btnSlide0 = btnSlide;
			super.btnRMenu0 = btnRMenu;
			super.screenBg0 = screenBg;
			super.top0 = top;
			
			if(super.thisPageWidth<700 ||
			   super.thisPageWidth>800) {
				scaleContents();
			}
			
			initHolderY = cellHolder.y;
			tscroll.setHeight(super.thisPageHeight - 235, 500);
			tscroll.x = super.thisPageWidth - 15;
//			tscroll.y = top.height + 30;
			tscroll.alpha = 0;

			super.initAssets();
			
			cellHolder.addEventListener(InfoCellEvent.EXPANDED, rearrangeCell, true, 0, false);
			cellHolder.addEventListener(InfoCellEvent.DETAILED, openDetailedInfo, true, 0, false);
			cellHolder.addEventListener(InfoCellEvent.SERVICE_ACTION, onServiceAction, true, 0, false);

			top.setTitle(ls.getData("mn.tf6"));
			var usr:UserDetails = UserManager.getInstance().getUserDetails();
			userName.txt.text = usr.subscriber;
			preloader.visible = true;
			
			if(PhoneList.getInstance().getPhoneList().length<2) btnPhoneList.visible = false;
			btnPhoneList.addEventListener(MouseEvent.MOUSE_UP, showSelectPopUp);
			
			if(super.sliding) {
//				dtHolder.alpha = 0;
				startNetworkTracking();
			}
		}
		
		override protected function setData(dx:int):void {
			preloader.visible = false;
			var usrDataArr:Array = super.getDataArr();
			
			for(var i:int=1;i<usrDataArr.length;++i) {
				var arr:Array = usrDataArr[i].split(";");
				if(arr.length==5) {
					var infoCell:InfoCellAdditionals = new InfoCellAdditionals();
					infoCell.name = "cell" + i.toString();
					infoCell.cellID = i;
					infoCell.setDataArr(arr)
					infoCell.y = cellHolder.height;
					cellHolder.addChild(infoCell);
				}
			}
			
			if(cellHolder.numChildren==0) {
				var noData:InfoCellNoData = new InfoCellNoData();
				cellHolder.addChild(noData);
			}
			
			if(cellHolder.height>tmasker.height) {
				cellHolder.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownCell);
			} else {
				cellHolder.y = initHolderY;
				cellHolder.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownCell);
			}
			
			tscroll.setSliderHeight(Math.round(tscroll.height * tscroll.height/cellHolder.height));
			
			if(super.thisPageWidth<700 || super.thisPageWidth>800) rearrangeCell();
		}
		
		private function rearrangeCell(e:InfoCellEvent=null):void {
//			trace("rearrangeCell");
			var h:Number = 0;
			for(var i:int=0;i<cellHolder.numChildren;++i) {
				var infoCell:InfoCellAdditionals = cellHolder.getChildAt(i) as InfoCellAdditionals;
				infoCell.y = h;
				h += infoCell.height;
			}
			
			tscroll.setSliderHeight(Math.round(tscroll.height * tscroll.height/cellHolder.height));
			
			if(cellHolder.height>tmasker.height) {
				cellHolder.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownCell);
			} else {
				cellHolder.y = initHolderY;
				cellHolder.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownCell);
			}
			
//			var minP:Number = 0-(tscroll.y + tscroll.height)
//			if(cellHolder.y<minP) nextY=minP;
		}
		
		private function onServiceAction(e:InfoCellEvent):void {
			trace("onServiceAction.servID: " + e.serviceID);
			popUp = PopUpManager.getInstance().getPopUp("serviceConfirm");
			popUp.addEventListener(PopUpEvent.CLOSE, hideSelectPopUp);
			holderPopUp.addChild(popUp);
			
			selCell = cellHolder.getChildByName("cell" + e.cellID.toString()) as InfoCellAdditionals;
			selServID = e.serviceID.toString();
			selServST = e.serviceST.toString()
			//NetworkManager.getInstance().requestFor("serviceAction", e.serviceID.toString(), e.serviceST.toString());
			//startNetworkTracking2("serviceAction");
		}
		
		private function openDetailedInfo(e:InfoCellEvent):void {
			trace("openDetailedInfo.servID: " + e.serviceID);
			popUp = PopUpManager.getInstance().getPopUp("details");
			popUp.addEventListener(PopUpEvent.CLOSE, hideSelectPopUp);
			holderPopUp.addChild(popUp);
			
			NetworkManager.getInstance().requestFor("description", e.serviceID.toString());
			startNetworkTracking2("description");
		}
		
		private function hideSelectPopUp(e:PopUpEvent=null):void {
			
			var popUp:PopUp = holderPopUp.getChildAt(0) as PopUp;
			popUp.removeEventListener(PopUpEvent.CLOSE, hideSelectPopUp);
			if(popUp is PopUpServiceConfirm) {
				if(popUp.confirmed) {
					if(selServID && selServST) {
						selCell.cellInLoadMode(true);
						NetworkManager.getInstance().requestFor("serviceAction", selServID, selServST);
						startNetworkTracking2("serviceAction");
					}
				}
			}
			holderPopUp.removeChildAt(0);
		}
		
		private function mouseDownCell(e:MouseEvent):void {
			TweenLite.killTweensOf(tscroll);
			startMouseY = stage.mouseY;
			tscroll.alpha = 1;
			hMoved = false;
			ScrollManager.scrolled = false;
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUpScreen);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMoveText);
		}
		
		private function onMouseUpScreen(e:MouseEvent):void {
			stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUpScreen);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMoveText);
			
			TweenLite.to(tscroll, 1, {delay:.5, alpha:0});
		}
		
		private function onMoveText(e:MouseEvent):void {
			var nextY:Number = cellHolder.y;
			var movPoz:int = startMouseY - stage.mouseY;
			if(movPoz<0) {
				nextY += Math.abs(movPoz);
			} else if(movPoz>0){
				nextY -= Math.abs(movPoz);
			}
			startMouseY = stage.mouseY;
			
			if(nextY>initHolderY) nextY=initHolderY;
			var minP:Number = tmasker.y + tmasker.height - cellHolder.height;
			if(nextY<minP) nextY=minP;
			
			cellHolder.y = nextY;
			hMoved = true;
			ScrollManager.scrolled = true;
	
			var scrPrc:Number = Math.round(Math.abs(minP - cellHolder.y) / ((cellHolder.height - tmasker.height)/100));
			tscroll.slidePerc(scrPrc);
		}
		
		
		
		private function startNetworkTracking2(s:String):void {
			trace("startNetworkTracking2().s: " + s);
			nTimer2 = new Timer(100);
			if(s=="description") {
				nTimer2.addEventListener(TimerEvent.TIMER, networkTimerHandler2);
			} else {
				nTimer2.addEventListener(TimerEvent.TIMER, networkTimerHandler3);
				
			}
			nTimer2.start();
		}
		
		private function networkTimerHandler2(e:TimerEvent):void {
			trace("### networkTimerHandler2");
			var retData:String = NetworkManager.getInstance().getReturnedData();
			if(retData=="no_connection") {
				this.dispatchEvent(new PopUpEvent(PopUpEvent.POPUP, "no_connection"));
				nTimer2.stop();
			} else if(retData!="not_loaded") {
				if(popUp) popUp.setHTMLData(retData);
				nTimer2.stop();
			}
			//nTimer2.stop();
		}
		
		private function networkTimerHandler3(e:TimerEvent):void {
			var retData:String = NetworkManager.getInstance().getReturnedData();
			trace("networkTimerHandler3: " + retData);
			
			if(retData=="no_connection") {
				this.dispatchEvent(new PopUpEvent(PopUpEvent.POPUP, "no_connection"));
				nTimer2.stop()
			} else if(retData!="not_loaded") {
				
				super.loadedData = retData;
				updateCellData(retData);
				
/*				selCell.cellInLoadMode(false);
				
				if(res.res=='1') {
					trace("SUCCESSFUL!");
					selCell.actionSuccessful(true);
				} else {
					trace("UNSUCCESSFUL!");
					selCell.actionSuccessful(false);
				}  */
				
				nTimer2.stop()
			}
			
			//nTimer2.stop()
		}
		
		
		private function showSelectPopUp(e:MouseEvent):void {
			var popUp:PopUp = PopUpManager.getInstance().getPopUp("phoneList");
			popUp.addEventListener(RadioButtonEvent.SELECTED, onRBSelected, true, 0, false);
			popUp.addEventListener(PopUpEvent.CLOSE, hideSelectPopUp2);
			holderPopUp.addChild(popUp);
		}
		
		private function hideSelectPopUp2(e:PopUpEvent=null):void {
			var popUp:PopUp = holderPopUp.getChildAt(0) as PopUp;
			popUp.removeEventListener(RadioButtonEvent.SELECTED, onRBSelected);
			holderPopUp.removeChildAt(0);
		}
		
		private function onRBSelected(e:RadioButtonEvent):void {
			TweenLite.to(this, 0, {delay:.5, onComplete:hideSelectPopUp });
			
			// NOTE: Using Period as phone! 
			var tel:Period = e.selectPeriod;
			trace("SelectedTelData: " + tel.ID);
			PhoneList.getInstance().setSelectedPhoneNumber(tel.PER_NAME);
			
			resetData();
			NetworkManager.getInstance().requestFor('additionals');
			startNetworkTracking(true);
		}
		
		private function resetData():void {
			cellHolder.removeChildren();
			preloader.visible = true;
		}
		
		private function updateCellData(retData:String):void {
			
			//preloader.visible = false;
			selCell.cellInLoadMode(false);
			
			var usrDataArr:Array = retData.split("\n");
			setDataArr(usrDataArr);
			
			for(var i:int=1;i<usrDataArr.length;++i) {
				var arr:Array = usrDataArr[i].split(";");
				if(arr.length==5) {
					var infoCell:InfoCellAdditionals = cellHolder.getChildByName("cell" + i.toString()) as InfoCellAdditionals;
//					infoCell.name = "cell" + i.toString();
//					infoCell.cellID = i;
					infoCell.updateDataArr(arr)
//					infoCell.y = cellHolder.height;
//					cellHolder.addChild(infoCell);
				}
			}
			
			if(cellHolder.numChildren==0) {
				var noData:InfoCellNoData = new InfoCellNoData();
				cellHolder.addChild(noData);
			}
			
		}
		
		private function scaleContents():void {
			var ratio:Number = super.thisPageWidth / ScreenManager.aspectRation
			
			btnSlide.scaleX = btnSlide.scaleY = ratio;
			btnRMenu.scaleX = btnRMenu.scaleY = ratio;
			preloader.scaleX = preloader.scaleY = ratio;
			preloader.x = (super.thisPageWidth - preloader.width) * .5;
			preloader.y = (super.thisPageHeight - preloader.height) * .5;
			
			top.scaleX = top.scaleY = ratio;
			userName.scaleX = userName.scaleY = ratio;
			btnPhoneList.scaleX = btnPhoneList.scaleY = ratio;
			userName.y = btnPhoneList.y = top.height;
			
			btnPhoneList.x = super.thisPageWidth - btnPhoneList.width;

			//btnPhoneList.scaleX = btnPhoneList.scaleY = ratio;
			
			tscroll.y = userName.y + userName.height;
			//tscroll.x is sorted out at top in initScreenAssets()
			
			tmasker.scaleY  = ratio;
			tmasker.width = super.thisPageWidth;
			tmasker.y = userName.y + userName.height;
			
			cellHolder.scaleX = cellHolder.scaleY = ratio * .97;
			cellHolder.y = userName.y + userName.height;
		}
		
	}
}