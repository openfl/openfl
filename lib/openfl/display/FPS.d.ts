import TextField from "./../text/TextField";

declare namespace openfl.display {

export class FPS extends TextField {

	constructor(x?:any, y?:any, color?:any);
	currentFPS:any;
	cacheCount:any;
	times:any;
	this_onEnterFrame(event:any):any;


}

}

export default openfl.display.FPS;