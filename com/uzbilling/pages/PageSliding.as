package com.uzbilling.pages {
	import flash.display.Sprite;
	import com.uzbilling.events.SliderInfoEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import com.greensock.TweenLite;
	import com.uzbilling.view.Holder;
	
	public class PageSliding extends Page {
		private const SLIDING_SPEED:Number = .5;
		private var parsedData:Array = [];
		private var dataIndex:int = 1;
		private var destHolder0:Number;
		private var destHolder:Number;
		protected var arrowLeft0:Sprite = new Sprite();
		protected var arrowRight0:Sprite = new Sprite();

		public function PageSliding() {
			// constructor code
		}
		
		
		override protected function initAssets():void {
			super.initAssets();
			arrowLeft0.alpha = 0;
			arrowLeft0.visible = false;
			arrowRight0.alpha = 0;
			arrowRight0.visible = false;
			
			destHolder = tHolder.x;
			destHolder0 = tHolder0.x;
			if(super.thisPageWidth>800) {
				arrowLeft0.scaleX = arrowLeft0.scaleY = super.thisPageWidth / 720;
				arrowRight0.scaleX = arrowRight0.scaleY = super.thisPageWidth / 720;
				
				arrowLeft0.y = (this.thisPageHeight - arrowLeft0.height) * .5;
				arrowRight0.y = (this.thisPageHeight - arrowRight0.height) * .5;
			}
			
			arrowLeft0.x = 40;
			arrowRight0.x = super.thisPageWidth - arrowRight0.width - 40;
		}
		
		override protected function deinit(e:Event):void {
			super.deinit(e);
//			slider0.removeEventListener(SliderInfoEvent.SLIDED, onSlideInfo);
			this.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDownScreen);
		}
		
		override protected function onDataLoaded():void {
			trace("PageSliding.loadedData: ");
		}
		
		private function onMouseDownScreen(e:MouseEvent):void {
/*			var mX:Number = this.mouseX;
			var mY:Number = this.mouseY;
			if(mY > top0.height + 30 && mY < super.thisPageHeight - 100 && tHolder.alpha!=0) {
				if(mX > 0 && mX < super.thisPageWidth) {
					if(mX<100) {
						slideRight();
					} else if(mX>super.thisPageWidth-100) {
						slideLeft();
					} else {
						arrowLeft0.alpha = 1;
						arrowRight0.alpha = 1;
						TweenLite.to(arrowLeft0, 1, {alpha:0});
						TweenLite.to(arrowRight0, 1, {alpha:0});
					}
				}
			}  */
			checkSlideBack();
		}
		
/*		private function onSlideInfo(e:SliderInfoEvent):void {
			if(e.pageID<dataIndex) {
				dataIndex = e.pageID + 1;
				slideRight(true);
			} else if(e.pageID>dataIndex) {
				dataIndex = e.pageID - 1;
				slideLeft(true);
			}
		}*/
		
		private function getReserveHolder():Holder {
			var ret:Holder;
			if(tHolder.x<0 || tHolder.x>super.thisPageWidth) ret = tHolder as Holder;
			if(tHolder0.x<0 || tHolder0.x>super.thisPageWidth) ret = tHolder0 as Holder;
			return ret;
		}
		
		protected function setData(dx:int):void {
			// must be overwritten
		}
		
		protected function updateData(dx:int):void {
			// must be overwritten
		}
		
		protected function getDataByIndex(n):Array {
			  return parsedData[n].split(";");
		}
		
		protected function getDataArr():Array {
			return parsedData;
		}
		
		protected function setDataArr(arr:Array):void {
			parsedData = arr;
		}

	}
}