import EventDispatcher from "./../events/EventDispatcher";

declare namespace openfl.ui {

export class GameInputControl extends EventDispatcher {

	constructor(device:any, id:any, minValue:any, maxValue:any, value?:any);
	device:any;
	id:any;
	maxValue:any;
	minValue:any;
	value:any;


}

}

export default openfl.ui.GameInputControl;