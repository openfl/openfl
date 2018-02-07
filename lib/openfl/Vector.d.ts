declare namespace openfl {
	
	
	export class Vector<T> {
		
		
		public fixed:boolean;
		public length:number;
		
		public constructor (length?:number, fixed?:boolean);
		
		public concat (a?:Vector<T>):Vector<T>;
		public copy ():Vector<T>;
		public get (index:number):T;
		public indexOf (x:T, from?:number):number;
		public insertAt (index:number, element:T):void;
		public join (sep:string):string;
		public lastIndexOf (x:T, from?:number):number;
		public pop ():null | T;
		public push (x:T):number;
		public removeAt (index:number):T;
		public reverse ():Vector<T>;
		public set (index:number, value:T):T;
		public shift ():null | T;
		public slice (pos?:number, end?:number):Vector<T>;
		public sort (f:(a:T, b:T)=>number):void;
		public splice (pos:number, len:number):Vector<T>;
		public unshift (x:T):void;
		public static ofArray<T> (a:Array<T>):Vector<T>;
		
		//public iterator ():Iterator<T>;
		public next:T;
		[index:number]:T;
		
		
	}
	
	
}


export default openfl.Vector;