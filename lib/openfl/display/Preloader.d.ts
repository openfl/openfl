

declare namespace openfl.display {

export class Preloader /*extends lime_app_Preloader*/ {

	constructor(display?:any);
	display:any;
	ready:any;
	start():any;
	update(loaded:any, total:any):any;
	display_onUnload(event:any):any;


}

}

export default openfl.display.Preloader;