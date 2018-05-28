import ByteArray from "./../utils/ByteArray";
import BitmapData from "./BitmapData";
import ShaderInput from "./ShaderInput";
import ShaderParameter from "./ShaderParameter";


interface AnyProperties {
	[prop:string]:any
}


declare namespace openfl.display {
	
	
	export class ShaderData implements AnyProperties {
		
		public constructor (bytes?:ByteArray);
		
		public texture0:ShaderInput<BitmapData>;
		public alpha:ShaderParameter<number>;
		public colorMultipliers:ShaderParameter<number>;
		public colorOffsets:ShaderParameter<number>;
		
		[key:string]:any;
		
	}
	
}


export default openfl.display.ShaderData;