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
	import com.greensock.TweenLite;
	import com.uzbilling.events.InfoCellEvent;
	import com.uzbilling.controller.ScrollManager;
	import com.uzbilling.view.InfoCellPayments;
	import com.uzbilling.view.InfoCellNoData;
	import com.uzbilling.controller.ScreenManager;
	import com.uzbilling.model.TariffHistoryModel;
	import com.uzbilling.view.InfoCellTariffs;
	import flash.display.MovieClip;
	import com.uzbilling.view.InfoCellTariffHistory;
	
	public class PageTariffHistory extends PageSliding {
		private var startMouseY:Number = 0;
		private var initHolderY:Number = 0;
		private var hMoved:Boolean = false;
		private var dataIndex:int = 1;
		private var historyArr:Array = [];
		
		public function PageTariffHistory() {
			// constructor code
			super.thisPageName = "tariff_history";
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
	
			top.setTitle(ls.getData("mn1.tf4"));
			var usr:UserDetails = UserManager.getInstance().getUserDetails();
			userName.txt.text = usr.subscriber;
			preloader.visible = true;
			
			if(super.sliding) {
//				dtHolder.alpha = 0;
				startNetworkTracking();
			}
		}
		
		override protected function onDataLoaded():void {
			trace("PageTariffHistory.dataLoaded!");
			
			var res:Object = JSON.parse(super.loadedData);
			
			//trace(super.res);
				
			if (res.hasOwnProperty("state")) { 
				
				if(res.state=='1') {
					
//					trace("----------------")  // REMOVE LATER
//					trace(res.items[0].service_name);  // REMOVE LATER
					
					for each (var tm in res.items) {
						var tempTM:TariffHistoryModel = new TariffHistoryModel()
						tempTM.setObject(tm);
						historyArr.push(tempTM);
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
					trace("Error! Loading in PageTariffHistory.onDataLoaded()");
				}
			}
		}
		
		override protected function setData(dx:int):void {
			preloader.visible = false;
			
			trace("historyArr.count: " + historyArr.length);
			
			for(var i:int=0;i<historyArr.length;++i) {
				var tm:TariffHistoryModel = historyArr[i] as TariffHistoryModel;
				//tm.setObject(historyArr[]);
				
				var historyCell:InfoCellTariffHistory = new InfoCellTariffHistory();
				historyCell.setDataModel(tm);
				historyCell.y = cellHolder.height;
				cellHolder.addChild(historyCell);  
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