import EventDispatcher from "./../events/EventDispatcher";

declare namespace openfl.sensors {

export class Accelerometer extends EventDispatcher {

	constructor();
	muted:any;
	_interval:any;
	timer:any;
	addEventListener(type:any, listener:any, useCapture?:any, priority?:any, useWeakReference?:any):any;
	setRequestedUpdateInterval(interval:any):any;
	update():any;
	set_muted(value:any):any;
	static currentX:any;
	static currentY:any;
	static currentZ:any;
	static defaultInterval:any;
	static initialized:any;
	static supported:any;
	static isSupported:any;
	static initialize():any;
	static accelerometer_onUpdate(x:any, y:any, z:any):any;
	static get_isSupported():any;


}

}

export default openfl.sensors.Accelerometer;