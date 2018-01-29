import ByteArray from "./utils/ByteArray";


declare namespace openfl {
	
	
	export class Memory {
		
		
		static getByte (addr:number):number;
		static getDouble (addr:number):number;
		static getFloat (addr:number):number;
		static getI32 (addr:number):number;
		static getUI16 (addr:number):number;
		static select (inBytes:ByteArray):void;
		static setByte (addr:number, v:number):void;
		static setDouble (addr:number, v:number):void;
		static setFloat (addr:number, v:number):void;
		static setI16 (addr:number, v:number):void;
		static setI32 (addr:number, v:number):void;
		
		
	}
	
	
}


export default openfl.Memory;