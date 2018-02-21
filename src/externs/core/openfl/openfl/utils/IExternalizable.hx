package openfl.utils; #if !flash


interface IExternalizable {
	
	function readExternal (input:IDataInput):Void;
	function writeExternal (output:IDataOutput):Void;
	
}


#else
typedef IExternalizable = flash.utils.IExternalizable;
#end