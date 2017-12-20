
declare namespace openfl.ui {

export class GameInputDevice {

	constructor(id:any, name:any);
	enabled:any;
	id:any;
	name:any;
	numControls:any;
	sampleInterval:any;
	__axis:any;
	__button:any;
	__controls:any;
	__gamepad:any;
	getCachedSamples(data:any, append?:any):any;
	getControlAt(i:any):any;
	startCachingSamples(numSamples:any, controls:any):any;
	stopCachingSamples():any;
	get_numControls():any;
	static MAX_BUFFER_SIZE:any;


}

}

export default openfl.ui.GameInputDevice;