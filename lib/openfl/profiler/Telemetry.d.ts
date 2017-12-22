declare namespace openfl.profiler {
	
	
	/*@:final*/ export class Telemetry {
		
		
		public static readonly connected:boolean;
		public static readonly spanMarker:number;
		
		public static registerCommandHandler (commandName:string, handler:any):boolean;
		public static sendMetric (metric:string, value:any):void;
		public static sendSpanMetric (metric:string, startSpanMarker:number, value:any):void;
		public static unregisterCommandHandler (commandName:string):boolean;
		
		
	}
	
	
}


export default openfl.profiler.Telemetry;