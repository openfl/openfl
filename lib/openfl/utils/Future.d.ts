declare namespace openfl.utils {
	
	
	export class Future<T> {
		
		
		public readonly error:any;
		public readonly isComplete:boolean;
		public readonly isError:boolean;
		public readonly value:T;
		
		public onComplete (listener:(value:T)=>void):Future<T>;
		public onError (listener:(error:any)=>void):Future<T>;
		public onProgress (listener:(bytesLoaded:number, bytesTotal:number)=>void):Future<T>;
		public ready (waitTime?:number):Future<T>;
		public result (waitTime?:number):T | null;
		public then<U> (next:(value:T)=>Future<U>):Future<U>;
		public static withError (error:any):Future<any>;
		public static withValue<T> (value:T):Future<T>;
		
		
	}
	
	
}


export default openfl.utils.Future;