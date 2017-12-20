
declare namespace openfl {

export class Memory {

	static gcRef:any;
	static len:any;
	static _setPositionTemporarily(position:any, action:any):any;
	static getByte(addr:any):any;
	static getDouble(addr:any):any;
	static getFloat(addr:any):any;
	static getI32(addr:any):any;
	static getUI16(addr:any):any;
	static select(inBytes:any):any;
	static setByte(addr:any, v:any):any;
	static setDouble(addr:any, v:any):any;
	static setFloat(addr:any, v:any):any;
	static setI16(addr:any, v:any):any;
	static setI32(addr:any, v:any):any;


}

}

export default openfl.Memory;