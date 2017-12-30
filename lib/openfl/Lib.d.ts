// import Application from "./display/Application";
import MovieClip from "./display/MovieClip";
import URLRequest from "./net/URLRequest";


declare namespace openfl {
	
	
	export class Lib {
		
		
		// public static application:Application;
		public static current:MovieClip;
		
		public static as (v:any, c:any):any;
		public static attach (name:string):MovieClip;
		public static getTimer ():number;
		public static getURL (request:URLRequest, target?:string);
		// public static function notImplemented (?posInfo:Dynamic):Dynamic;
		// public static function preventDefaultTouchMove ():Dynamic;
		public static trace (arg:any):void;
		
		
	}
	
	
}


export default openfl.Lib;