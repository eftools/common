package inobr.eft.common.lang 
{
	/**
	 * Toolkit for working with localization
	 * 
	 * @author Artem Andreev, andreev.artem@gmail.com
	 */
	public class Lang 
	{
		private static var langMap:Object;
		
		/**
		 * Initialize language
		 * 
		 * @param	lang Associative array of language strings - "string id": "language string".
		 * If lang not specified en will be used.
		 */
		public static function Init(lang:Object):void
		{
			langMap = lang
		}

		/**
		 * Return localized string by string id.
		 * 
		 * @param	id String identifier
		 * @return Localized string if identifier exists otherwise [[id]]
		 */
		public static function GetString(id:String):String
		{
			var res:String = langMap[id];
			
			if (!res)
				return '[[' + id +']]';
			
			return res;
		}
	}
}