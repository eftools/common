package inobr.eft.common.ui
{
	import flash.events.*;
	
	/**
	 * The basic Event for all Tool Pannel.
	 * If any Button must create a new element it must dispatch 
	 * this Event with the name of Class given.
	 *
	 * ...
	 * @author gps
	 */
	public class GScrollBarEvent extends Event 
	{
		public static const SCROLL_MOVED:String = "scrollmoved";
		// the name of the Class that must be created after the Button pressed
		public var position:int;
		
		public function GScrollBarEvent(position:int, type:String = SCROLL_MOVED, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
			this.position = position;
		}
		
		public override function clone():Event
		{
			return new GScrollBarEvent(position, type, bubbles, cancelable);
		}
		
		public override function toString():String
		{
			return formatToString(position.toString(), SCROLL_MOVED, "bubbles", "cancelable", "eventPhase");
		}
	}
	
}