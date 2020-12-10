package flash.utils;

#if flash
interface IExternalizable
{
	function readExternal(input:IDataInput):Void;
	function writeExternal(output:IDataOutput):Void;
}
#else
typedef IExternalizable = openfl.utils.IExternalizable;
#end
