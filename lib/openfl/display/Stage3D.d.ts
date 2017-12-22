import Context3D from "./../display3D/Context3D";
import Context3DProfile from "./../display3D/Context3DProfile";
import Context3DRenderMode from "./../display3D/Context3DRenderMode";
import EventDispatcher from "./../events/EventDispatcher";

type Vector<T> = any;


declare namespace openfl.display {
	
	
	export class Stage3D extends EventDispatcher {
	
	
		public readonly context3D:Context3D;
		public visible:boolean;
		public x:number;
		public y:number;
		
		
		public requestContext3D (context3DRenderMode?:Context3DRenderMode, profile?:Context3DProfile):void;
		public requestContext3DMatchingProfiles (profiles:Vector<string>):void;
		
		
	}
	
	
}


export default openfl.display.Stage3D;