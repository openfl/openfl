package openfl.utils;

#if !flash
interface IExternalizable
{
	public function readExternal(input:IDataInput):Void;
	public function writeExternal(output:IDataOutput):Void;
}
#else
typedef IExternalizable = flash.utils.IExternalizable;
#end
