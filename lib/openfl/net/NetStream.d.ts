import EventDispatcher from "./../events/EventDispatcher";

declare namespace openfl.net {

export class NetStream extends EventDispatcher {

	constructor(connection:any, peerID?:any);
	audioCodec:any;
	bufferLength:any;
	bufferTime:any;
	bytesLoaded:any;
	bytesTotal:any;
	checkPolicyFile:any;
	
	currentFPS:any;
	decodedFrames:any;
	liveDelay:any;
	objectEncoding:any;
	soundTransform:any;
	speed:any;
	time:any;
	videoCode:any;
	__connection:any;
	__timer:any;
	__video:any;
	close():any;
	pause():any;
	play(url:any, _?:any, _?:any, _?:any, _?:any, _?:any):any;
	requestVideoStatus():any;
	resume():any;
	seek(time:any):any;
	togglePause():any;
	__playStatus(code:any):any;
	video_onCanPlay(event:any):any;
	video_onCanPlayThrough(event:any):any;
	video_onDurationChanged(event:any):any;
	video_onEnd(event:any):any;
	video_onError(event:any):any;
	video_onLoadMetaData(event:any):any;
	video_onLoadStart(event:any):any;
	video_onPause(event:any):any;
	video_onPlaying(event:any):any;
	video_onSeeking(event:any):any;
	video_onStalled(event:any):any;
	video_onTimeUpdate(event:any):any;
	video_onWaiting(event:any):any;
	get_speed():any;
	set_speed(value:any):any;


}

}

export default openfl.net.NetStream;