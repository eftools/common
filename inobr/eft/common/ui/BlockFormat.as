package inobr.eft.common.ui 
{
	/**
	 * ...
	 * @author Peter Gerasimenko, gpstmp@gmail.com
	 */
	public class BlockFormat extends Object
	{
		private var _blockFill:uint;
		private var _borderColor:uint;
		private var _borderWidth:uint;
		//private var _margin:uint = 0;
		private var _marginHorizontal:uint;
		private var _marginVertical:uint;
		
		/**
		 * Format for rectangle
		 * @param	options set any option like an object field: {blockFill: 0xFF0000, borderWidth: 1}
		 */
		public function BlockFormat(options:Object = null):void
		{
			if (!options) options = { };
			_blockFill = options.blockFill || 0xFFFFFF;
			_borderColor = options.borderColor || 0x000000;
			_borderWidth = options.borderWidth || 2;
			_marginHorizontal = options.marginHorizontal || 10;
			_marginVertical = options.marginVertical || 10;
		}
		
		public function set blockFill(setValue:uint):void
		{
			_blockFill = setValue;
		}
		
		public function get blockFill():uint
		{
			return _blockFill;
		}
		
		public function set borderColor(setValue:uint):void
		{
			_borderColor = setValue;
		}
		
		public function get borderColor():uint
		{
			return _borderColor;
		}
		
		public function set borderWidth(setValue:uint):void
		{
			_borderWidth = setValue;
		}
		
		public function get borderWidth():uint
		{
			return _borderWidth;
		}
		
		/*public function set margin(setValue:uint):void
		{
			_margin = setValue;
		}
		
		public function get margin():uint
		{
			return _margin;
		}*/
		
		public function set marginHorizontal(setValue:uint):void
		{
			_marginHorizontal = setValue;
		}
		
		public function get marginHorizontal():uint
		{
			return _marginHorizontal;
		}
		
		public function set marginVertical(setValue:uint):void
		{
			_marginVertical = setValue;
		}
		
		public function get marginVertical():uint
		{
			return _marginVertical;
		}
	}

}