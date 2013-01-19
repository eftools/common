package inobr.eft.common.ui 
{
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.display.Graphics;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import inobr.eft.common.ui.BlockFormat;
	import inobr.eft.common.ui.GScrollBarEvent;
	
	/**
	 * This class has content-property that specifize a DisplayObject to be masked
	 * and scrolled. You can work with this DisplayObject any way you like.
	 * 
	 * The TRUE width of content consists of:
	 * 1) the width of content (_content.width)
	 * 2) set margins (format.marginHorizontal) usually multiplied by 2
	 * 3) margin for vertical scrollbar (verticalScrollBar.width).
	 *    This margin changes _scrollMask.width
	 * The same situation with the TRUE height of content.
	 * This made in order to assign job of managing the margins on GScrollPane class.
	 * 
	 * ...
	 * @author Peter Gerasimenko, gpstmp@gmail.com
	 */
	public class GScrollPane extends Sprite 
	{
		private var format:BlockFormat;
		
		private var _scrollArea:Sprite = new Sprite();
		private var _scrollMask:Sprite = new Sprite();
		
		private var _content:Sprite;
		
		private var _deltaX:uint = 10;
		private var _deltaY:uint = 10;
		
		private var verticalScrollBar:GScrollBar;
		private var horizontalScrollBar:GScrollBar;
		private var verticalScrollIndex:Number;
		private var horizontalScrollIndex:Number;
		
		private var scrollMaskWidth:uint = 0;
		private var scrollMaskHeight:uint = 0;
		
		private var _previousContainerWidth:uint;
		
		public function GScrollPane(width:uint, height:uint, format:BlockFormat):void
		{
			this.format = format;
			
			installComponents(width, height);
			installListeners();
		}
		
		// add visual components
		/**
		 * ScrollArea is the skin of GScrollPane (with elements of design)
		 * ScrollMask is viewable area and nothing else
		 * 
		 * @param	width
		 * @param	height
		 */
		private function installComponents(width:uint, height:uint):void
		{
			addChild(_scrollArea);
			addChild(_scrollMask);
			
			// create scroll skin
			var scrollBody:Shape = new Shape();
			scrollBody.graphics.beginFill(format.blockFill);
			scrollBody.graphics.lineStyle(format.borderWidth, format.borderColor);
			scrollBody.graphics.drawRect(0, 0, width, height);
			scrollBody.graphics.endFill();
			
			_scrollArea.addChild(scrollBody);
			
			// create mask
			_scrollMask.x = format.borderWidth / 2 ;
			_scrollMask.y = _scrollMask.x;
			scrollMaskWidth = width - format.borderWidth;
			scrollMaskHeight = height - format.borderWidth;
			var mask:Shape = new Shape();
			mask.graphics.beginFill(0xAAAAAA);
			mask.graphics.drawRect(0, 0, scrollMaskWidth, scrollMaskHeight);
			mask.graphics.endFill();
			
			_scrollMask.addChild(mask);
			
			// adding scrollbars 
			addVerticalScrollBar();
			addHorizontalScrollBar();
		}
		
		// add behavior with listeners
		private function installListeners():void
		{
			addEventListener(MouseEvent.MOUSE_WHEEL, mouseWheelCapture);
			addEventListener(GScrollBarEvent.SCROLL_MOVED, scrollMovedCapture);
		}
		
		private function mouseWheelCapture(event:MouseEvent):void
		{
			// horizontal scrolling with SHIFT pressed
			if (event.shiftKey)
			{
				var difference:int = _scrollMask.width - _content.width - format.marginHorizontal;
				if (difference < format.marginHorizontal)
				{
					if (_content.x <= format.marginHorizontal && _content.x >= difference)
					{
						var newX:int = _content.x + event.delta * _deltaX;
						(newX >= format.marginHorizontal) ? newX = format.marginHorizontal : newX;
						(newX <= difference) ? newX = difference : newX;
						_content.x = newX;
						
						// if we change position of content we must change position 
						// of track in scrollbar
						horizontalScrollBar.sY = Math.floor(format.borderWidth / 2 - (_content.x - format.marginHorizontal) / 
												 horizontalScrollIndex);
					}
				}
			}
			// vertical scrolling
			else
			{
				difference = _scrollMask.height - _content.height - format.marginVertical;
				if (difference < format.marginVertical)
				{
					if (_content.y <= format.marginVertical && _content.y >= difference)
					{
						var newY:int = _content.y + event.delta * _deltaY;
						(newY >= format.marginVertical) ? newY = format.marginVertical : newY;
						(newY <= difference) ? newY = difference : newY;
						_content.y = newY;
						
						// if we change position of content we must change position 
						// of track in scrollbar
						verticalScrollBar.sY = Math.floor(format.borderWidth / 2 - (_content.y - format.marginVertical) / 
											   verticalScrollIndex);
					}
				}
			}
		}
		
		private function scrollToButtom():void
		{
			var difference:int = _scrollMask.height - _content.height - format.marginVertical;
			_content.y = difference;
			
			// if we change position of content we must change position 
			// of track in scrollbar
			verticalScrollBar.sY = Math.floor(format.borderWidth / 2 - (_content.y - format.marginVertical) / 
								   verticalScrollIndex);
		}
		
		/**
		 * Response to the change in position of the Track in GScrollBar 
		 * 
		 * @param	event says that Track in GScrollBar have been moved
		 */
		private function scrollMovedCapture(event:GScrollBarEvent):void
		{
			if (event.target == verticalScrollBar)
			{
				var newY:int = - event.position * verticalScrollIndex + format.marginVertical;
				_content.y = newY;
			}
			if (event.target == horizontalScrollBar)
			{
				var newX:int = - event.position * horizontalScrollIndex + format.marginHorizontal;
				_content.x = newX;
			}
		}
		
		private function addVerticalScrollBar():void
		{
			verticalScrollBar = new GScrollBar(this.height - 2*format.borderWidth);
			addChild(verticalScrollBar);
			
			verticalScrollBar.x = _scrollMask.width - verticalScrollBar.width + format.borderWidth/2;
			verticalScrollBar.y = format.borderWidth / 2;
			
			//verticalScrollBar.visible = false;
		}
		
		private function addHorizontalScrollBar():void
		{
			horizontalScrollBar = new GScrollBar(this.width - 2*format.borderWidth);
			addChild(horizontalScrollBar);
			
			horizontalScrollBar.rotation = -90;
			horizontalScrollBar.x = format.borderWidth / 2;
			horizontalScrollBar.y = _scrollMask.height;
			
			//verticalScrollBar.visible = false;
		}
		
		private function showVerticalScrollBar(show:Boolean = true):void
		{
			if (show)
			{
				_scrollMask.width = scrollMaskWidth - verticalScrollBar.width;
				
				var newHeight:uint = Math.floor(verticalScrollBar.sWidth * _scrollMask.height / 
									(_content.height + 2*format.marginVertical));
				verticalScrollBar.sTrackWidth = newHeight;
				
				verticalScrollIndex = (_content.height + 2 * format.marginVertical - _scrollMask.height) /
									  (verticalScrollBar.sWidth - verticalScrollBar.sTrackWidth);
				
				// change Y coordinate
				verticalScrollBar.sY = format.borderWidth / 2 - (_content.y - format.marginVertical) / verticalScrollIndex;
				
				verticalScrollBar.visible = true;
			}
			else
			{
				_scrollMask.width = scrollMaskWidth;
				verticalScrollBar.visible = false;
			}
		}
		
		private function showHorizontalScrollBar(show:Boolean = true):void
		{
			if (show)
			{
				// check collision with vertical scrollbar
				if (verticalScrollBar.visible == true)
				{
					horizontalScrollBar.sWidth = _scrollArea.width - 2 * format.borderWidth - verticalScrollBar.width;
					verticalScrollBar.sWidth = _scrollArea.height - 2 * format.borderWidth - horizontalScrollBar.height;
					_scrollMask.width = scrollMaskWidth - verticalScrollBar.width;
					_scrollMask.height = scrollMaskHeight - horizontalScrollBar.height;
					showVerticalScrollBar(true);
				}
				else
				{
					horizontalScrollBar.sWidth = _scrollArea.width - 2 * format.borderWidth;
					_scrollMask.width = scrollMaskWidth;
					_scrollMask.height = scrollMaskHeight - horizontalScrollBar.height;
				}
				
				var newWidth:uint = Math.floor(horizontalScrollBar.sWidth * _scrollMask.width / 
									(_content.width + 2 * format.marginHorizontal));
				horizontalScrollBar.sTrackWidth = newWidth;
				
				horizontalScrollIndex = (_content.width + 2 * format.marginHorizontal - _scrollMask.width) /
									    (horizontalScrollBar.sWidth - horizontalScrollBar.sTrackWidth);
				
				// change Y coordinate
				horizontalScrollBar.sY = format.borderWidth / 2 - (_content.x - format.marginHorizontal) / horizontalScrollIndex;
				
				horizontalScrollBar.visible = true;
			}
			else
			{
				_scrollMask.height = scrollMaskHeight;
				horizontalScrollBar.visible = false;
			}
		}
		
		private function changed(event:Event):void
		{
			// we must ensure that Y coordinate wouldn't be more than difference
			// between _scrollMask.height and _content.height. The same happens with X 
			// coordinate and _scrollMask.width and _content.width
			if (_scrollMask.height - _content.height - 2 * format.marginVertical >= _content.y && 
				_content.y < format.marginVertical)
				_content.y = -1 * Math.floor(_content.height - _scrollMask.height);
			if (_scrollMask.width - _content.width - 2 * format.marginHorizontal >= _content.x && 
				_content.x < format.marginHorizontal)
				_content.x = -1 * Math.floor(_content.width - _scrollMask.width);
				
			// if height of container becomes less than scrollMask area 
			// we hide scroll and put container on (0,0) coordinate
			if (_scrollMask.height >= _content.height + 2 * format.marginVertical)
			{
				_content.y = format.marginVertical;
				showVerticalScrollBar(false);
			}
			else
			{
				showVerticalScrollBar();
				scrollToButtom();
			}
			
			// if width of container becomes less than scrollMask area 
			// we hide scroll and put container on (0,0) coordinate
			if (_scrollMask.width >= _content.width +  2 * format.marginHorizontal)
			{
				_content.x = format.marginHorizontal;
				showHorizontalScrollBar(false);
			}
			else
			{
				// if user change something on the right end of container 
				// we shift it
				if (_previousContainerWidth < _content.width) 
				{
					_content.x -= _content.width - _previousContainerWidth;
				}
				
				showHorizontalScrollBar();
			}
			
			_previousContainerWidth = _content.width;
		}
		
		/**
		 * Forced update of scroll
		 * Use it if you want be sure that scroll will fit itself
		 */
		public function updateScroll():void
		{
			changed(null);
		}
		
		// getters and setters
		public function set content(setValue:Sprite):void
		{
			_content = setValue;
			_content.y = format.marginVertical;
			addChild(_content);
			_content.mask = _scrollMask;
			
			_content.addEventListener(Event.CHANGE, changed);
			
			// the width will be known after adding to the stage
			_content.addEventListener(Event.ADDED_TO_STAGE, callChanged);
			
			function callChanged(event:Event):void
			{
				_content.removeEventListener(Event.ADDED_TO_STAGE, callChanged);
				_previousContainerWidth = _content.width;
				changed(null);
			}
		}
		
		public function get content():Sprite
		{
			return _content;
		}
	}

}