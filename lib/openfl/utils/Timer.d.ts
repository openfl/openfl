import EventDispatcher from "./../events/EventDispatcher";

declare namespace openfl.utils {

export class Timer extends EventDispatcher {

	constructor(delay:any, repeatCount?:any);
	currentCount:any;
	delay:any;
	repeatCount:any;
	running:any;
	__delay:any;
	__repeatCount:any;
	
	__timerID:any;
	reset():any;
	start():any;
	stop():any;
	get_delay():any;
	set_delay(value:any):any;
	get_repeatCount():any;
	set_repeatCount(v:any):any;
	timer_onTimer():any;


}

}

export default openfl.utils.Timer;