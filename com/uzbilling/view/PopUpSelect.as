package com.uzbilling.view {
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.display.Stage;
	import com.greensock.TweenLite;
	import com.uzbilling.model.Period;
	import com.uzbilling.controller.ScreenManager;
	import com.uzbilling.events.PopUpEvent;
	
	public class PopUpSelect extends PopUp {
		private var dataArr:Array = [];
		private var mouseIsDown:Boolean = false;
		private var prevMousePosY:Number;
		private var speedY:Number = 0;
		private var selectedText:String;
		private var prevRB:RadioButton = new RadioButton();
		private var targetRB:RadioButton = new RadioButton();
		private var stg:Stage;
		
		public function PopUpSelect() {
			// constructor code
		}
		
		override public function setData(arr:Array):void {
			dataArr = arr;
		}
		
		override public function selectText(s:String):void {
			
		}
		
		override protected function init(e:Event):void {
			super.init(e);
			initScreenAssets();
		}

		override protected function deinit(e:Event):void {
			super.deinit(e);
		}
		
		private function initScreenAssets():void {
			stg = stage;
			fpoint.visible = false;
			screenBg.width = super.thisPageWidth;
			screenBg.height = super.thisPageHeight;
			whiteBG.width = super.thisPageWidth - 80;
			whiteBG.height = super.thisPageHeight - 80;
			masker.width = super.thisPageWidth - 140;
			masker.height = super.thisPageHeight - 140;
			
			if(dataArr.length>0) {
				createList();
				//listHolder.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
				this.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			}
			listHolder.x = (super.thisPageWidth - listHolder.width) * .5;
			listHolder.mask = masker;			
		}
		
		private function createList():void {
			for (var i:int=0; i<dataArr.length; i++) {
				var rb:RadioButton2 = new RadioButton2();
				rb.name = i.toString();
				var per:Period = dataArr[i];
				rb.setPeriod(per);
				rb.enableMouseEvent();
				rb.y = listHolder.height;
				if(super.thisPageWidth>800) rb.scaleX = rb.scaleY = super.thisPageWidth / 720;
				listHolder.addChild(rb);
				var ls:ListSeperator = new ListSeperator();
				ls.y = listHolder.height;
				if(super.thisPageWidth>800) ls.scaleX = ls.scaleY = super.thisPageWidth / 720;
				listHolder.addChild(ls);
			}
		}
		
		private function mouseDownHandler(e:MouseEvent):void {
			if(e.target.name=="screenBg") {
				this.dispatchEvent(new PopUpEvent(PopUpEvent.CLOSE));
				e.stopImmediatePropagation();
			} else {
				targetRB = e.target as RadioButton;
				if(targetRB) targetRB.buttonMouseDown();
				mouseIsDown = true;
				prevMousePosY = stg.mouseY;
				//listHolder.cacheAsBitmap = true;
				addEventListener(Event.ENTER_FRAME, handleEnterFrame);
				stg.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			}
		}
		
		private function mouseUpHandler(e:MouseEvent):void {
			targetRB = e.target as RadioButton;
			if(targetRB) targetRB.buttonMouseUp();
			mouseIsDown = false;
			//listHolder.cacheAsBitmap = false;
			fpoint.y = 0;
			if(targetRB && targetRB.isSelected && targetRB!=prevRB) {
				prevRB.selected(false);
				prevRB = targetRB;
			}
			stg.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			sptxt.text = speedY.toString();
		}
		
		private function handleEnterFrame(e:Event):void {
			var np:Number = 0 - (listHolder.height - masker.y - masker.height);
			
			if(mouseIsDown) {
				// fpoint.visible = true;
				speedY = stg.mouseY - prevMousePosY;
				if(speedY<0 || speedY>0) {
					if(targetRB) targetRB.buttonMouseMove();
				}
				if(speedY>100) speedY=100;
				if(speedY<-100) speedY=-100;
				
				fpoint.x = stg.mouseX;
				if(fpoint.y>0) listHolder.y += (stg.mouseY - fpoint.y);
				fpoint.y = stg.mouseY;
				if(listHolder.y>70) listHolder.y=70;
				if(listHolder.y<np) listHolder.y=np;
			} else {
				fpoint.visible = false;
				listHolder.y += speedY;
				if(listHolder.y>70) listHolder.y=70;
				if(listHolder.y<np) listHolder.y=np;
				
				speedY *= .85;
			}
			
			if(speedY > -0.1 && speedY < 0.1 && !mouseIsDown) {
				removeEventListener(Event.ENTER_FRAME, handleEnterFrame);
			}			
			prevMousePosY = stg.mouseY;
			
		}
		
		
		
		
	}
}