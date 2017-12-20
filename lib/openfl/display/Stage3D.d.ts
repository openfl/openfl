import EventDispatcher from "./../events/EventDispatcher";

declare namespace openfl.display {

export class Stage3D extends EventDispatcher {

	constructor();
	context3D:any;
	visible:any;
	x:any;
	y:any;
	__contextRequested:any;
	__stage:any;
	__x:any;
	__y:any;
	__canvas:any;
	
	__style:any;
	__webgl:any;
	requestContext3D(context3DRenderMode?:any, profile?:any):any;
	requestContext3DMatchingProfiles(profiles:any):any;
	__createContext(stage:any, renderSession:any):any;
	__dispatchError():any;
	__dispatchCreate():any;
	__renderCairo(stage:any, renderSession:any):any;
	__renderCanvas(stage:any, renderSession:any):any;
	__renderDOM(stage:any, renderSession:any):any;
	__renderGL(stage:any, renderSession:any):any;
	__resize(width:any, height:any):any;
	__resetContext3DStates():any;
	get_x():any;
	set_x(value:any):any;
	get_y():any;
	set_y(value:any):any;
	static __active:any;


}

}

export default openfl.display.Stage3D;