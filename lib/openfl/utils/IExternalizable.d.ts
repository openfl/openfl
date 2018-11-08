import IDataInput from "./IDataInput";
import IDataOutput from "./IDataOutput";


declare namespace openfl.utils {
	
	
	export class IExternalizable {
		
		
		public readExternal (input:IDataInput):void;
		public writeExternal (output:IDataOutput):void;
		
		
	}
	
	
}


export default openfl.utils.IExternalizable;