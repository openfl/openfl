import Context3DTextureFilter from "./../display3D/Context3DTextureFilter";
import Context3DMipFilter from "./../display3D/Context3DMipFilter";
import Context3DWrapMode from "./../display3D/Context3DWrapMode";


declare namespace openfl.display {
	
	
	/*@:final*/ export class ShaderInput<T> /*implements Dynamic*/ {
		
		
		readonly channels:number;
		filter:Context3DTextureFilter;
		height:number;
		readonly index:number;
		input:T;
		mipFilter:Context3DMipFilter;
		width:number;
		wrap:Context3DWrapMode;
		
		constructor ();
		
		
	}
	
	
}


export default openfl.display.ShaderInput;