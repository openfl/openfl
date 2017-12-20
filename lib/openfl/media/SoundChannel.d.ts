import EventDispatcher from "./../events/EventDispatcher";

declare namespace openfl.media {

export class SoundChannel extends EventDispatcher {

	constructor(source?:any, soundTransform?:any);
	leftPeak:any;
	position:any;
	rightPeak:any;
	soundTransform:any;
	__isValid:any;
	__soundTransform:any;
	__source:any;
	stop():any;
	__dispose():any;
	__updateTransform():any;
	get_position():any;
	set_position(value:any):any;
	get_soundTransform():any;
	set_soundTransform(value:any):any;
	source_onComplete():any;


}

}

export default openfl.media.SoundChannel;