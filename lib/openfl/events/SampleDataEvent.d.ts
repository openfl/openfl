import Event from "./Event";

declare namespace openfl.events {

export class SampleDataEvent extends Event {

	constructor(type:any, bubbles?:any, cancelable?:any);
	data:any;
	position:any;
	clone():any;
	toString():any;
	static SAMPLE_DATA:any;


}

}

export default openfl.events.SampleDataEvent;