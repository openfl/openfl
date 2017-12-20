import EventDispatcher from "./../events/EventDispatcher";

declare namespace openfl.ui {

export class GameInput extends EventDispatcher {

	constructor();
	addEventListener(type:any, listener:any, useCapture?:any, priority?:any, useWeakReference?:any):any;
	static isSupported:any;
	static numDevices:any;
	static __deviceList:any;
	static __devices:any;
	static __instances:any;
	static getDeviceAt(index:any):any;
	static __getDevice(gamepad:any):any;
	static __onGamepadAxisMove(gamepad:any, axis:any, value:any):any;
	static __onGamepadButtonDown(gamepad:any, button:any):any;
	static __onGamepadButtonUp(gamepad:any, button:any):any;
	static __onGamepadConnect(gamepad:any):any;
	static __onGamepadDisconnect(gamepad:any):any;


}

}

export default openfl.ui.GameInput;