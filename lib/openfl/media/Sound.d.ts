import EventDispatcher from "./../events/EventDispatcher";

declare namespace openfl.media {

export class Sound extends EventDispatcher {

	constructor(stream?:any, context?:any);
	bytesLoaded:any;
	bytesTotal:any;
	id3:any;
	isBuffering:any;
	length:any;
	url:any;
	__buffer:any;
	close():any;
	load(stream:any, context?:any):any;
	loadCompressedDataFromByteArray(bytes:any, bytesLength:any):any;
	loadPCMFromByteArray(bytes:any, samples:any, format?:any, stereo?:any, sampleRate?:any):any;
	play(startTime?:any, loops?:any, sndTransform?:any):any;
	get_id3():any;
	get_length():any;
	AudioBuffer_onURLLoad(buffer:any):any;
	static fromAudioBuffer(buffer:any):any;
	static fromFile(path:any):any;
	static loadFromFile(path:any):any;
	static loadFromFiles(paths:any):any;


}

}

export default openfl.media.Sound;