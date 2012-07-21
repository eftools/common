package inobr.eft.common.ui
{
	import flash.display.Sprite;
	import flash.display.SimpleButton;
	import flash.display.Stage;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.filters.DropShadowFilter;
	import flash.filters.BevelFilter;
	import flash.text.TextField; 
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.events.*;
	
	/**
	 * Create Notification Window with user text
	 * ...
	 * @author Peter Gerasimenko, gpstmp@gmail.com
	 */
	public class NotificationWindow extends Sprite
	{
		private static var isRight:Boolean = false;
		private static var messageText:String = "";
		private static var titleText:String = "";
		/* window size */
		private static var windowWidth:uint  = 350;
		private static var windowHeight:uint = 30;
		
		/* colors and decorations */
        private static var bgGreenColor:uint      = 0x81C66D;
		private static var bgRedColor:uint        = 0xFF6D6D;
		private static var bgWhiteColor:uint      = 0xE1E1E1;
		private static var bgBlendColor:uint      = 0xCCCCCC;
        private static var cornerGreenRadius:uint = 30;
		private static var cornerWhiteRadius:uint = 30;
		private static var borderSize:Number	  = 0.1;
		private static var borderColor:uint	      = 0x555759;
		
		/* link to the window and its Close button */
		private static var closeButtonLink:SimpleButton;
		private static var windowLink:Sprite;
		private static var stageLink:Stage;
		private static var blender:Sprite;
		public static const NOTIFICATION_CLOSED:String = "notificationClosed";
		
		/**
		 * Create window with user text and specified width. Height of the window is determined 
		 * by the size of text. The window located in the middle of the Stage.
		 * 
		 * @param	stage		link to the stage
		 * @param	title		the title of the window
		 * @param	textToView	specified the text displayed in the window
		 * @param	right		specified the color of the window (TRUE - green, FALSE - red)
		 * @param	wWidth		specified the width of the window, it must be more than 100px. By default 
		 * 						the width is 350px.
		 * 
		 * @throws	Error		if specified width is less than 100px
		 */
		public static function show(stage:Stage, title:String, textToView:String, right:Boolean, wWidth:uint = 350):void
		{
			try 
			{
				windowLink.parent.removeChild(windowLink);
			}
			catch (error:Error) {/* nothing to do */}
			
			stageLink = stage;
			isRight = right;
			/* check the window width */
			var errorText:String = "Window width must be more than 100px! Now it is: " + wWidth.toString();
			
			if (wWidth >= 100)
				windowWidth = wWidth;
			else	
				throw new Error(errorText);
				
			titleText = title;
			messageText = textToView;
				
			windowLink = drawWindow();
			stage.addChild(windowLink);
		}
		/**
		 * This method draws a window from different Shapes.
		 * You can make your own window style if you want.
		 * If you already have a painted window in Flash IDE, you do not have to paint it programmatically.
		 * You can create an instance of this window and place it in a container called "window".
		 * Special attention should be paid to order of addition shapes to the container
		 * (look for the addChild method).
		 * Some properties in this method are "magic" because they must make the window beautiful.
		 */
		private static function drawWindow():Sprite
		{
			/* All of the window put in one container called "window" 
			 * use this container if you are going to make your own window style */
			var window:Sprite = new Sprite();
			
			/* the text of the header */
			var headerText:TextField = new TextField();
			headerText.width = windowWidth - 40;
			headerText.x = 10;
			headerText.y = 4;
			
			/* choose the text of the header */
			headerText.text = titleText; //T('SuccessWindowTitle'); T('ErrorWindowTitle');
			/* setting the format of the text */
			var format:TextFormat = new TextFormat();
            format.font = "Tahoma";
            format.color = 0x2A2A2A;
            format.size = 13;
			format.bold = true;
			
            headerText.setTextFormat(format);
			
			/* setting filters for text (two Shadows with different properties) */
			var myFilters:Array = new Array();
			myFilters.push(new DropShadowFilter(0.5, 90, 0xFFFFFF, 1, 0, 0, 1.3, 1, false));
			myFilters.push(new DropShadowFilter(0.5, 90, 0x000000, 1, 0, 0, 1, 1, true));
			
			headerText.filters = myFilters;
			
			/* the text of the window */
			var windowText:TextField = new TextField();
			windowText.width = windowWidth - 40;
			windowText.x = 10;
			windowText.y = 33;
			windowText.autoSize = TextFieldAutoSize.LEFT;
			windowText.wordWrap = true;
			windowText.text = messageText;
			/* use the format set above */
            windowText.setTextFormat(format);
			windowText.filters = myFilters;
			
			/* calculate the height of the window ("the height of the text" + "42px bottom padding") */
			windowHeight = windowText.height + 42;
			
			
			/* drawing the back of the window (gray) */
			var back:Shape = new Shape();
			back.graphics.beginFill(bgWhiteColor);
			back.graphics.lineStyle(borderSize, borderColor);
			back.graphics.drawRoundRect(0, 0, windowWidth, windowHeight, cornerGreenRadius);
			back.graphics.endFill();
			
			/* drawing the back of the window (red or green) */
			var header:Shape = new Shape();
			/* choose the color of the window */
			if(isRight)
				header.graphics.beginFill(bgGreenColor);
			else
				header.graphics.beginFill(bgRedColor);
				
			/* left-top coordinate (0.5, 0.5) shifts header to view the border of the back 
			 * */
            header.graphics.drawRoundRect(0.5, 0.5, windowWidth - 1, 50, cornerGreenRadius);
            header.graphics.endFill();
			
			/* mask for hiding a part of header */
			var mask:Shape = new Shape();
			mask.graphics.beginFill(bgWhiteColor);
			mask.graphics.drawRect(0.5, 30, windowWidth - 1, 22);
			mask.graphics.endFill();
			
			/* draw the line below the header */
			var line:Shape = new Shape();
			line.graphics.lineStyle(1, 0x333333, 0.5);
			line.graphics.moveTo(0.5, 30);
			line.graphics.lineTo(windowWidth - 1, 30);
			
			/* drawing the inner line of all the window */
			var innerLine:Shape = new Shape();
			innerLine.graphics.lineStyle(1.5, 0xFFFFFF, 0.4);
			innerLine.graphics.drawRoundRect(1.5, 1.5, windowWidth - 3, windowHeight - 3, cornerGreenRadius - 3);
			
			/* adding the CLOSE button (it is in the Library) to the window */
			var closeButton:SimpleButton = new CloseButton();
			closeButton.x = windowWidth - 30;
			closeButton.y = 7;
			
			/* adding all of the window in one container in specified order */
            window.addChild(back);
			window.addChild(header);
			window.addChild(mask);
			window.addChild(line);
			window.addChild(innerLine);
			window.addChild(headerText);
			window.addChild(windowText);
			window.addChild(closeButton);
			
			closeButtonLink = closeButton;
			/* waiting for the window to be on the Stage in order to set its position */
			window.addEventListener(Event.ADDED_TO_STAGE, stageHandler);
			
			return window;
		}
		
		/**
		 * After adding to the Stage we can use stage.width property and set (x,y) to the window.
		 * Add a listener to the event of click on the close button.
		 * Create blackout on the Stage (to block the user's actions during the window display).
		 * 
		 * @param	event	the window is added to the Stage
		 */
		private static function stageHandler(event:Event):void
		{
			/* The window located in the middle of the Stage. */
			windowLink.x = int((stageLink.stageWidth - windowLink.width) / 2) + 0.5;
			windowLink.y = int((stageLink.stageHeight - windowLink.height) / 2) + 0.5;
			
			/* Create blackout on the Stage */
			blender = new Sprite();
			var blenderBack:Shape = new Shape();
			blenderBack.graphics.beginFill(bgBlendColor, 0.5);
			blenderBack.graphics.drawRect(0, 0, stageLink.stageWidth, stageLink.stageHeight);
            blenderBack.graphics.endFill();
			blender.addChild(blenderBack);
			
			stageLink.addChild(blender);
			/* swap blackout and the window (window must be on top) */
			stageLink.swapChildrenAt(stageLink.getChildIndex(windowLink), stageLink.getChildIndex(blender));
			
			windowLink.removeEventListener(Event.ADDED_TO_STAGE, stageHandler);
			closeButtonLink.addEventListener(MouseEvent.MOUSE_DOWN, onCloseButtonClick);
			blender.addEventListener(MouseEvent.CLICK, clickOutsideHandler);
		}
		
		private static function clickOutsideHandler(event:MouseEvent):void 
		{
			event.stopPropagation();
		}
		
		/**
		 * Destroy the window and its listeners
		 * 
		 * @param	event	click event on the close button
		 */
		private static function onCloseButtonClick(event:MouseEvent):void
		{
			remove();
		}
		
		private static function remove():void
		{
			closeButtonLink.removeEventListener(MouseEvent.MOUSE_DOWN, onCloseButtonClick);
			windowLink.stage.dispatchEvent(new Event(NOTIFICATION_CLOSED, true));
			blender.removeEventListener(MouseEvent.CLICK, clickOutsideHandler);
			stageLink.removeChild(windowLink);
			stageLink.removeChild(blender);
		}
		
	}
	
}