

declare namespace openfl.profiler {

export class Telemetry {

	static connected:any;
	static spanMarker:any;
	static registerCommandHandler(commandName:any, handler:any):any;
	static sendMetric(metric:any, value:any):any;
	static sendSpanMetric(metric:any, startSpanMarker:any, value?:any):any;
	static unregisterCommandHandler(commandName:any):any;
	static __advanceFrame():any;
	static __endTiming(name:any):any;
	static __initialize():any;
	static __rewindStack(stack:any):any;
	static __startTiming(name:any):any;
	static __unwindStack():any;
	static get_connected():any;


}

}

export default openfl.profiler.Telemetry;