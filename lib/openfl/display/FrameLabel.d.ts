import EventDispatcher from "./../events/EventDispatcher";

declare namespace openfl.display {

export class FrameLabel extends EventDispatcher {

	constructor(name:any, frame:any);
	frame:any;
	name:any;
	__frame:any;
	__name:any;
	get_frame():any;
	get_name():any;


}

}

export default openfl.display.FrameLabel;