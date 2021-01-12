package com.uzbilling.pages {
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.display.Sprite;	
	import com.uzbilling.model.UserDetails;
	import com.uzbilling.view.DetailsTextField;
	import com.uzbilling.controller.UserManager;
	import com.uzbilling.controller.NetworkManager;
	import com.uzbilling.events.SwitchPageEvent;
	import com.uzbilling.events.SliderInfoEvent;
	import com.uzbilling.events.PopUpEvent;
	import com.uzbilling.view.PopUp;
	import com.uzbilling.events.InfoCellEvent;
	import com.uzbilling.controller.PopUpManager;
	import com.uzbilling.controller.ScrollManager;
	import com.uzbilling.view.InfoCellPayments;
	import com.uzbilling.view.InfoCellNoData;
	import com.uzbilling.controller.ScreenManager;
	import com.uzbilling.model.TariffGroupModel;
	import com.uzbilling.model.TariffModel;
	import com.uzbilling.view.InfoCellTariffs;
	import com.greensock.TweenLite;
	import flash.display.MovieClip;
	import com.uzbilling.view.PopUpServiceConfirm;
	import com.uzbilling.model.Globals;
	
	public class PageTarifs extends PageSliding {
		private var startMouseY:Number = 0;
		private var initHolderY:Number = 0;
		private var hMoved:Boolean = false;
		private var dataIndex:int = 1;
		private var tarifGroupArr:Array = [];
		private var popUp:PopUp;
		private var selCell:InfoCellTariffs;
		private var selServID:String;
		private var selServST:String;
		
		public function PageTarifs() {
			// constructor code
			super.thisPageName = "tariffs";
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
			cellHolder.addEventListener(InfoCellEvent.SERVICE_ACTION, onServiceAction, true, 0, false);
	
			top.setTitle(ls.getData("mn1.tf1"));
			var usr:UserDetails = UserManager.getInstance().getUserDetails();
			userName.txt.text = usr.subscriber;
			preloader.visible = true;
			
			if(super.sliding) {
//				dtHolder.alpha = 0;
				startNetworkTracking();
			}
		}
		
		override protected function onDataLoaded():void {
			trace("PageTarifs.dataLoaded!");
			
			var res:Object = JSON.parse(super.loadedData);
				
			if (res.hasOwnProperty("state")) { 
				
				if(res.state=='1') {
					
//					trace("----------------")  // REMOVE LATER
//					trace(res.tarrif_group[0].items[0].t_ammount);  // REMOVE LATER
					
					if(res.tarrif_group) {
						trace("res.tarrif_group: " + res.tarrif_group.length);
					
						for each (var tg in res.tarrif_group) {
							var tempTG:TariffGroupModel = new TariffGroupModel()
							tempTG.setObject(tg);
							tarifGroupArr.push(tempTG);
						}
					} else {
						if(selCell) {
							trace("YOUR TARIFF UPDATED");
							selCell.btnChange.txt.text = ls.getData("tarif.reserved");
							Globals.getInstance().reservedTarifID = selServID;
							
						}
					}
//					trace("GROUP: " + tarifGroupArr[0].t_name);  // REMOVE LATER
//					var tm:TariffModel = tarifGroupArr[0].tariffArray[0] as TariffModel;  // REMOVE LATER
//					trace("ITEM: " + tm.t_name);  // REMOVE LATER
					
					if(tHolder.numChildren==0) {
						setData(dataIndex);
					} else {
						trace("Page sliding -> updateData");
//						updData = true;
						dataIndex = 1;
						updateData(dataIndex);
					}
					
				} else {
					trace("Error! Loading in PageSliding.onDataLoaded()");
				}
			}
		}
		
		override protected function setData(dx:int):void {
			preloader.visible = false;
			
			for(var j:int=0;j<tarifGroupArr.length;++j) {
				var ttg:TariffGroupModel = tarifGroupArr[j] as TariffGroupModel;
				
				var grTitle:InfoGroupTitle = new InfoGroupTitle();
				grTitle.title.text = ttg.t_name;
				grTitle.y = cellHolder.height;
				cellHolder.addChild(grTitle);
				
				for(var i:int=0;i<ttg.tariffArray.length;++i) {
					var tm:TariffModel = ttg.tariffArray[i] as TariffModel;
					//tm.setObject(tm);
					
					var tariffCell:InfoCellTariffs = new InfoCellTariffs();
					tariffCell.name = "cell" + j.toString() + i.toString();
					tariffCell.cellID = j.toString() + i.toString();
					if(tm.t_id == Globals.getInstance().reservedTarifID) {
						tm.reserved = true;
					}
					tariffCell.setDataModel(tm);					
					tariffCell.y = cellHolder.height;
					cellHolder.addChild(tariffCell);
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
			trace("rearrangeCell: " + cellHolder.numChildren);
			var h:Number = 0;
			if(cellHolder.numChildren>0) {
				for(var i:int=0;i<cellHolder.numChildren;++i) {
					var infoCell = cellHolder.getChildAt(i) as MovieClip;
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
			}
		}
		
		private function onServiceAction(e:InfoCellEvent):void {
			trace("onServiceAction.servID: " + e.serviceID);
			popUp = PopUpManager.getInstance().getPopUp("serviceConfirm");
			popUp.addEventListener(PopUpEvent.CLOSE, hideSelectPopUp);
			holderPopUp.addChild(popUp);
			
			selCell = cellHolder.getChildByName("cell" + e.cellID.toString()) as InfoCellTariffs;
			selServID = e.serviceID.toString();
			selServST = e.serviceST.toString()
		}
		
		private function hideSelectPopUp(e:PopUpEvent=null):void {
			var popUp:PopUp = holderPopUp.getChildAt(0) as PopUp;
			popUp.removeEventListener(PopUpEvent.CLOSE, hideSelectPopUp);
			if(popUp is PopUpServiceConfirm) {
				if(popUp.confirmed) {
					if(selServID && selServST) {
						trace("hideSelectPopUp()");
						selCell.cellInLoadMode(true);
						NetworkManager.getInstance().requestFor("changeTariff", selServID, selServST);
						startNetworkTracking(true);
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
		
		
		private function scaleContents():void {
			var ratio:Number = super.thisPageWidth / ScreenManager.aspectRation
			
			btnSlide.scaleX = btnSlide.scaleY = ratio;
			btnRMenu.scaleX = btnRMenu.scaleY = ratio;
			preloader.scaleX = preloader.scaleY = ratio;
			preloader.x = (super.thisPageWidth - preloader.width) * .5;
			preloader.y = (super.thisPageHeight - preloader.height) * .5;
			
			top.scaleX = top.scaleY = ratio;
			userName.scaleX = userName.scaleY = ratio;
			userName.y = top.height;
			
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