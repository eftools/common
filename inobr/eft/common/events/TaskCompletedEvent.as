package inobr.eft.common.events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Peter Gerasimenko, gpstmp@gmail.com
	 */
	public class TaskCompletedEvent extends Event 
	{
		/**
		 * All modules should dispatch this event after comleting.
		 * You can provied this event with any data you want.
		 * data param MUST have "score" field.
		 */
		public var data:Object;
		public static const TASK_COMPLETED:String = "taskCompleted";
		
		public function TaskCompletedEvent(data:Object, type:String = "taskCompleted", bubbles:Boolean = true, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
			if (!data.score)
			{
				throw new Error("ERROR! There is no 'score' field in data object of TaskCompletedEvent.");
			}
			this.data = data;
		}
		
		public override function clone():Event
		{
			return new TaskCompletedEvent(data, type, bubbles, cancelable);
		}
		
		public override function toString():String
		{
			return formatToString("taskCompleted", data, "bubbles", "cancelable", "eventPhase");
		}
		
	}

}