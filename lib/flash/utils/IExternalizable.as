package flash.utils {
	
	
	/**
	 * @externs
	 */
	public interface IExternalizable {
		
		function readExternal (input:IDataInput):void;
		function writeExternal (output:IDataOutput):void;
		
	}
	
	
}