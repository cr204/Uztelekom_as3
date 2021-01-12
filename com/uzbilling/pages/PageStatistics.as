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
	import com.greensock.easing.*;
	import com.uzbilling.events.PopUpEvent;
	import fl.motion.easing.Elastic;
	import fl.motion.easing.Quadratic;
	import com.uzbilling.events.TopSliderEvent;
	import com.uzbilling.view.PopUp;
	import com.uzbilling.controller.PopUpManager;
	import com.uzbilling.events.RadioButtonEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import com.uzbilling.model.SelectList;
	import com.uzbilling.events.InfoCellEvent;
	import com.uzbilling.view.InfoCellStatistics;
	import com.uzbilling.controller.ScrollManager;
	import com.uzbilling.view.InfoCellNoData;
	import com.uzbilling.controller.ScreenManager;
	
	public class PageStatistics extends PageSliding {
		private var startMouseY:Number = 0;
		private var initHolderY:Number = 0;
		private var hMoved:Boolean = false;
		
		public function PageStatistics() {
			// constructor code
			super.thisPageName = "statistics";
		}
		
		override protected function init(e:Event):void {
			super.init(e);
			initScreenAssets();
		}

		private function initScreenAssets():void {
			super.btnSlide0 = btnSlide;
			super.btnRMenu0 = btnRMenu;
			super.top0 = top;
			super.screenBg0 = screenBg;
			super.tHolder = cellHolder;
			
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
			
			top.setTitle(ls.getData("mn.tf4"));
			
			topSliderFilter.y = 0;
			topSliderFilter.visible = false;
			topSliderFilter.init();
			
/*			if(super.thisPageWidth>750) {
				btnFilter.y = 60 * super.thisPageWidth / ScreenManager.aspectRation;
				btnFilter.scaleX = btnFilter.scaleY = super.thisPageWidth / ScreenManager.aspectRation;
				topSliderFilter.scaleX = topSliderFilter.scaleY = super.thisPageWidth / ScreenManager.aspectRation;
			}  */

			
			//btnFilter.x = super.thisPageWidth - btnFilter.width - 45;
			btnFilter.addEventListener(MouseEvent.MOUSE_DOWN, openFilter);
			var usr:UserDetails = UserManager.getInstance().getUserDetails();
			userName.txt.text = usr.subscriber;
			preloader.visible = true;

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
				if(arr.length==10) {
					var infoCell:InfoCellStatistics = new InfoCellStatistics();
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
			trace("rearrangeCell");
			var h:Number = 0;
			for(var i:int=0;i<cellHolder.numChildren;++i) {
				var infoCell:InfoCellStatistics = cellHolder.getChildAt(i) as InfoCellStatistics;
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
		private function openFilter(w:MouseEvent):void {
//			TweenLite.to(btnFilter, .3, {y:20 * super.thisPageWidth / 720  })
			topSliderFilter.visible = true;
			topSliderFilter.addEventListener(TopSliderEvent.SELECTED, showSelectPopUp);
			topSliderFilter.addEventListener(TopSliderEvent.SHOWED, sendRequestHandler);
			topSliderFilter.addEventListener(TopSliderEvent.CLOSED, hideFilter);
			TweenLite.to(topSliderFilter, .4, {y:386 * super.thisPageWidth / ScreenManager.aspectRation, ease:Quad.easeInOut})
			topSliderFilter.setDefaultPeriods(SelectList.getInstance().getPenultPeriod(), SelectList.getInstance().getLastPeriod());
		}
		
		private function hideFilter(e:TopSliderEvent=null):void {
//			TweenLite.to(btnFilter, .5, {y:60 * super.thisPageWidth / 720, delay:.3})
			topSliderFilter.removeEventListener(TopSliderEvent.SELECTED, showSelectPopUp);
			topSliderFilter.removeEventListener(TopSliderEvent.SHOWED, sendRequestHandler);
			topSliderFilter.removeEventListener(TopSliderEvent.CLOSED, hideFilter);
			TweenLite.to(topSliderFilter, .5, {y:0, ease:Quad.easeInOut, onComplete: function(){topSliderFilter.visible = false;} });
		}

		
		private function showSelectPopUp(e:TopSliderEvent):void {
			var popUp:PopUp = PopUpManager.getInstance().getPopUp("select");
			popUp.addEventListener(RadioButtonEvent.SELECTED, onRBSelected, true, 0, false);
			popUp.addEventListener(PopUpEvent.CLOSE, hideSelectPopUp);
			holderPopUp.addChild(popUp);
		}
		
		private function hideSelectPopUp(e:PopUpEvent=null):void {
			var popUp:PopUp = holderPopUp.getChildAt(0) as PopUp;
			popUp.removeEventListener(RadioButtonEvent.SELECTED, onRBSelected);
			holderPopUp.removeChildAt(0);
		}
		
		private function onRBSelected(e:RadioButtonEvent):void {
			TweenLite.to(this, 0, {delay:.5, onComplete:hideSelectPopUp });
			topSliderFilter.setSelectPeriod(e.selectPeriod);
		}
		

		
		private function sendRequestHandler(e:TopSliderEvent):void {
			trace("Filter Request Send!");
			trace(topSliderFilter.sel1_PeriodID.ID);
			trace(topSliderFilter.sel2_PeriodID.ID);
			
			
			var link:String = NetworkManager.getInstance().SERVER + 'pcdata?pcd=subscr_mty_tell&_search=true&rows=100&page=1&sord=asc&filters={"p_start_in2":"' 
																  + topSliderFilter.sel1_PeriodID.ID + '","p_end_in2":"' 
																  + topSliderFilter.sel2_PeriodID.ID + '","p_phone_a_in":"'
																  + topSliderFilter.phoneA + '","p_phone_b_in":"' 
																  + topSliderFilter.phoneB + '"}';
			trace("LINK: " + link);
			var req:URLRequest = new URLRequest(link);
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, onURLLoaded);
			urlLoader.load(req);
			
			hideFilter();
		}
		
		private function onURLLoaded(e:Event):void {
			super.loadedData = e.target.data;
//			dtHolder.x = 22;
//			dtHolder0.x = super.thisPageWidth + 22;
			super.onDataLoaded();
//			dtHolder.alpha = 0;
//			TweenLite.to(dtHolder, .5, {alpha:1, delay:.2});
		}
		
		override protected function updateData(dx:int):void {
			
			cellHolder.removeChildren();
			
			trace("updateData().cellHolder: " + cellHolder.numChildren);
			
			var usr:UserDetails = UserManager.getInstance().getUserDetails();
			userName.txt.text = usr.subscriber;
			
			var usrDataArr:Array = super.getDataArr();
			
			for(var i:int=1;i<usrDataArr.length;++i) {
				var arr:Array = usrDataArr[i].split(";");
				if(arr.length==10) {
					var infoCell:InfoCellStatistics = new InfoCellStatistics();
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
			btnFilter.scaleX = btnFilter.scaleY = ratio;
			userName.y = btnFilter.y = top.height;
			
			btnFilter.x = super.thisPageWidth - btnFilter.width;

			topSliderFilter.scaleX = topSliderFilter.scaleY = ratio;
			
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