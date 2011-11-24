package inobr.eft.common.lang 
{
	/**
	 * Return localized string by string id.
	 * 
	 * @param	id String identifier
	 * @return Localized string if identifier exists otherwise [[<id>]]
	 */
	public function T(id:String):String
	{
		return Lang.GetString(id);
	}
	
}