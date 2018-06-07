import Vector from "./../Vector";
import Context3D from "./../display3D/Context3D";
import Context3DProfile from "./../display3D/Context3DProfile";
import Context3DRenderMode from "./../display3D/Context3DRenderMode";
import EventDispatcher from "./../events/EventDispatcher";


declare namespace openfl.display {
	
	
	export class Stage3D extends EventDispatcher {
	
	
		public readonly context3D:Context3D;
		public visible:boolean;
		
		public x:number;
		
		protected get_x ():number;
		protected set_x (value:number):number;
		
		public y:number;
		
		protected get_y ():number;
		protected set_y (value:number):number;
		
		
		public requestContext3D (context3DRenderMode?:Context3DRenderMode, profile?:Context3DProfile):void;
		public requestContext3DMatchingProfiles (profiles:Vector<string>):void;
		
		
	}
	
	
}


export default openfl.display.Stage3D;