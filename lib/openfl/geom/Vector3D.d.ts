declare namespace openfl.geom {
	
	
	export class Vector3D {
	
	
		public static readonly X_AXIS:Vector3D;
		
		protected static get_X_AXIS ():Vector3D;
		
		public static readonly Y_AXIS:Vector3D;
		
		protected static get_Y_AXIS ():Vector3D;
		
		public static readonly Z_AXIS:Vector3D;
		
		protected static get_Z_AXIS ():Vector3D;
		
		
		public readonly length:number;
		
		protected get_length ():number;
		
		public readonly lengthSquared:number;
		
		protected get_lengthSquared ():number;
		
		
		public w:number;
		public x:number;
		public y:number;
		public z:number;
		
		
		public constructor (x?:number, y?:number, z?:number, w?:number);
		
		
		//public inline add (a:Vector3D):Vector3D;
		public add (a:Vector3D):Vector3D;
		
		
		//public inline static angleBetween (a:Vector3D, b:Vector3D):number;
		public static angleBetween (a:Vector3D, b:Vector3D):number;
		
		
		//public inline clone ():Vector3D;
		public clone ():Vector3D;
		
		
		public copyFrom (sourceVector3D:Vector3D):void;
		
		
		//public inline crossProduct (a:Vector3D):Vector3D;
		public crossProduct (a:Vector3D):Vector3D;
		
		
		//public inline decrementBy (a:Vector3D):void;
		public decrementBy (a:Vector3D):void;
		
		
		//public inline static distance (pt1:Vector3D, pt2:Vector3D):number;
		public static distance (pt1:Vector3D, pt2:Vector3D):number;
		
		
		//public inline dotProduct (a:Vector3D):number;
		public dotProduct (a:Vector3D):number;
		
		
		//public inline equals (toCompare:Vector3D, allFour:boolean = false):boolean;
		public equals (toCompare:Vector3D, allFour?:boolean):boolean;
		
		
		//public inline incrementBy (a:Vector3D):void;
		public incrementBy (a:Vector3D):void;
		
		
		//public inline nearEquals (toCompare:Vector3D, tolerance:number, ?allFour:boolean = false):boolean;
		public nearEquals (toCompare:Vector3D, tolerance:number, allFour?:boolean):boolean;
		
		
		//public inline negate ():void;
		public negate ():void;
		
		
		//public inline normalize ():number;
		public normalize ():number;
		
		
		//public inline project ():void;
		public project ():void;
		
		
		//public inline scaleBy (s:number):void;
		public scaleBy (s:number):void;
		
		
		public setTo (xa:number, ya:number, za:number):void;
		
		
		//public inline subtract (a:Vector3D):Vector3D;
		public subtract (a:Vector3D):Vector3D;
		
		
		//public inline toString ():string;
		public toString ():string;
		
		
	}
	
	
}


export default openfl.geom.Vector3D;