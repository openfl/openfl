import TextEvent from "./TextEvent";

declare namespace openfl.events {

export class DataEvent extends TextEvent {

	constructor(type:any, bubbles?:any, cancelable?:any, data?:any);
	data:any;
	clone():any;
	toString():any;
	static DATA:any;
	static UPLOAD_COMPLETE_DATA:any;


}

}

export default openfl.events.DataEvent;