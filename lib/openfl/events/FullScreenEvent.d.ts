import ActivityEvent from "./ActivityEvent";

declare namespace openfl.events {

export class FullScreenEvent extends ActivityEvent {

	constructor(type:any, bubbles?:any, cancelable?:any, fullScreen?:any, interactive?:any);
	fullScreen:any;
	interactive:any;
	clone():any;
	toString():any;
	static FULL_SCREEN:any;
	static FULL_SCREEN_INTERACTIVE_ACCEPTED:any;


}

}

export default openfl.events.FullScreenEvent;