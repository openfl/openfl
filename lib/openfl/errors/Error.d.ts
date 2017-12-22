declare namespace openfl.errors {
	
	
	export class Error /*#if openfl_dynamic implements Dynamic #end*/ {
		
		
		// #if flash
		// @:noCompletion @:dox(hide) public static var length:Int;
		// #end
		
		public readonly errorID:number;
		public message:string; //Dynamic
		public name:string; //Dynamic
		
		
		public constructor (message?:string, id?:number);
		
		// #if flash
		// @:noCompletion @:dox(hide) public static function getErrorMessage (index:Int):string;
		// #end
		
		public getStackTrace ():string;
		
		// #if flash
		// @:noCompletion @:dox(hide) public static function throwError (type:Class<Dynamic>, index:UInt, ?p1:Dynamic, ?p2:Dynamic, ?p3:Dynamic, ?p4:Dynamic, ?p5:Dynamic):Dynamic;
		// #end
		
		
	}
	
	
}


export default openfl.errors.Error;