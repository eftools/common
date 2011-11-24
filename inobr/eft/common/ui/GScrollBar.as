package inobr.eft.common.ui 
{
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.display.Graphics;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import inobr.eft.common.ui.GScrollBarEvent;
	
	/**
	 * ...
	 * @author gps
	 */
	public class GScrollBar extends Sprite 
	{
		private var _sWidth:uint;
		private var _sY:int = 0;
		private var _sTrackWidth:uint;
		private var _sIndex:Number = 0;
		
		private var _scroller:Sprite = new Sprite();
		private var _scrollerBox:Sprite = new Sprite();
		private var verticalBounds:Rectangle;
		private var scrolling:Boolean = false;
		
		private var _scrollBoxColor:uint       = 0xEFEFEF;
		private var _scrollerColor:uint        = 0xD1D1D4;
		private var _scrollerBorderColor:uint  = 0x979797;
		private var _scrollBoxBorderColor:uint = 0x979797;
		
		public function GScrollBar(width:uint) 
		{
			_sWidth = width;
			
			// add all items 
			installComponents();
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// add behaviour after adding to stage
			installListeners();
		}
		
		// add visual components
		private function installComponents():void
		{
			// draw scrollerBox
			_scroller = drawScroller();
			_scrollerBox = drawScrollerBox();
			
			_scrollerBox.x = 0;
			_scrollerBox.y = 0;
			addChild(_scrollerBox);
			
			// draw scroller
			_scroller.x = 0;
			_scroller.y = 0;
			addChild(_scroller);
			
			verticalBounds = new Rectangle(_scroller.x, _scroller.y, 0, 
										   _sWidth - _scroller.height);
		}
		
		private function drawScroller(height:uint = 60):Sprite
		{
			if (_scroller.numChildren == 1)
				_scroller.removeChildAt(0);
			var scroller:Shape = new Shape();
			scroller.graphics.beginFill(_scrollerColor);
			scroller.graphics.lineStyle(1, _scrollerBorderColor);
			scroller.graphics.drawRect(0, 0, 10, height);
			scroller.graphics.endFill();
			
			_scroller.addChildAt(scroller, 0);
			
			verticalBounds = new Rectangle(0, 0, 0, _sWidth - _scroller.height);
			
			return _scroller;
		}
		
		private function drawScrollerBox():Sprite
		{
			if (_scrollerBox.numChildren == 1)
				_scrollerBox.removeChildAt(0);
			var scrollerBox:Shape = new Shape();
			scrollerBox.graphics.beginFill(_scrollBoxColor);
			scrollerBox.graphics.lineStyle(1, _scrollBoxBorderColor);
			scrollerBox.graphics.drawRect(0, 0, 10, _sWidth - 1);
			scrollerBox.graphics.endFill();
			
			_scrollerBox.addChildAt(scrollerBox, 0);
			
			return _scrollerBox;
		}
		
		// add behavior with listeners
		private function installListeners():void
		{
			_scroller.addEventListener (MouseEvent.MOUSE_DOWN, startScroll);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, scrollProcess);
			stage.addEventListener (MouseEvent.MOUSE_UP, stopScroll);
		}
		
		private function startScroll (event:Event):void
		{
			scrolling = true;
			_scroller.startDrag (false, verticalBounds);
		}
			 
		private function stopScroll (event:Event):void
		{
			scrolling = false;
			_scroller.stopDrag ();
		}
			
		private function scrollProcess (event:Event):void 
		{
			if (scrolling)
			{
				dispatchEvent(new GScrollBarEvent(_scroller.y, GScrollBarEvent.SCROLL_MOVED, true));
			}
		}
		
		// getters and setters
		public function set sWidth(setValue:uint):void
		{
			_sWidth = setValue;
			drawScrollerBox();
		}
		
		public function get sWidth():uint
		{
			return _sWidth;
		}
		
		public function set sY(setValue:int):void
		{
			_sY = setValue;
			if (_sY > _sWidth - _scroller.height)
				_sY = _sWidth - _scroller.height;
			_scroller.y = _sY;
		}
		
		public function get sY():int
		{
			return _sY;
		}
		
		public function set sTrackWidth(setValue:uint):void
		{
			_sTrackWidth = setValue;
			drawScroller(_sTrackWidth);
		}
		
		public function get sTrackWidth():uint
		{
			return _sTrackWidth;
		}
		
	}

}