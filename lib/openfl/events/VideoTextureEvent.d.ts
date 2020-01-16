import Event from "./Event";


declare namespace openfl.events {


	export class VideoTextureEvent extends Event {


		static RENDER_STATE;

		readonly colorSpace:string;
		readonly status:string;


		constructor (type:string, bubbles?:boolean, cancelable?:boolean, status?:string, colorSpace?:string);


	}


}


export default openfl.events.VideoTextureEvent;