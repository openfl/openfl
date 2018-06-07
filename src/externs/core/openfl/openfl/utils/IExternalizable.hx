package openfl.utils;


#if flash
@:native("flash.utils.IExternalizable")
#end

interface IExternalizable {
	
	function readExternal (input:IDataInput):Void;
	function writeExternal (output:IDataOutput):Void;
	
}