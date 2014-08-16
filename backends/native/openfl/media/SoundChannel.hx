package openfl.media;


import openfl.events.Event;
import openfl.events.EventDispatcher;
import openfl.events.SampleDataEvent;
import openfl.media.Sound;
import openfl.Lib;

#if (!audio_thread_disabled && !emscripten)
#if neko
import neko.vm.Thread;
import neko.vm.Mutex;
#elseif java
import java.vm.Thread;
import java.vm.Mutex;
#else
import cpp.vm.Thread;
import cpp.vm.Mutex;
#end
#end


class SoundChannel extends EventDispatcher {
	
	
	public var leftPeak (get, null):Float;
	public var rightPeak (get, null):Float;
	public var position (get, set):Float;
	public var soundTransform (get, set):SoundTransform;
	
	@:noCompletion public static var __dynamicSoundCount = 0;
	@:noCompletion private static var __incompleteList = new Array<SoundChannel> ();
	
	@:noCompletion public var __dataProvider:EventDispatcher;
	@:noCompletion private var __handle:Dynamic;
	@:noCompletion public var __soundInstance:Sound;
	@:noCompletion private var __transform:SoundTransform;
	
	#if (!audio_thread_disabled && !emscripten)
		
		//These relate to the audio thread state
	@:noCompletion private static var __audioState:AudioThreadState;
	@:noCompletion private static var __audioThreadIsIdle:Bool = true;
	@:noCompletion private static var __audioThreadRunning:Bool = false;
		
		//This relates so this single channel
	@:noCompletion public var __thread_completed:Bool = false;
	@:noCompletion private var __addedToThread:Bool = false;
	
	#end	
	

	public function new (handle:Dynamic, startTime:Float, loops:Int, soundTransform:SoundTransform) {
		
		super ();

		if (soundTransform != null) {
			
			__transform = soundTransform.clone ();
			
		}
		
		if (handle != null) {
			
			__handle = lime_sound_channel_create (handle, startTime, loops, __transform);
			
		}
		
		if (__handle != null) {
			
			__incompleteList.push (this);
			
		}

	}
	
	
	public static function createDynamic (handle:Dynamic, soundTransform:SoundTransform, dataProvider:EventDispatcher):SoundChannel {
		
		var result = new SoundChannel (null, 0, 0, soundTransform);
		
		result.__dataProvider = dataProvider;
		result.__handle = handle;
		__incompleteList.push (result);
		
		__dynamicSoundCount ++;
		
		return result;
		
	}
	
	
	public function stop ():Void {
		
		#if (!audio_thread_disabled && !emscripten)
		
		if (__soundInstance != null && __soundInstance.__audioType == InternalAudioType.MUSIC) {
			
			if(__audioState != null) {
				__audioState.remove (this);
			}
			
		}
		
		#end
		
		lime_sound_channel_stop (__handle);
		__handle = null;
		__soundInstance = null;
		
	}	

	@:noCompletion private function __checkComplete ():Bool {
		
		if (__handle != null) {
			
			if (__dataProvider != null && lime_sound_channel_needs_data (__handle)) {
				
				var request = new SampleDataEvent (SampleDataEvent.SAMPLE_DATA);
				request.position = lime_sound_channel_get_data_position (__handle);
				__dataProvider.dispatchEvent (request);
				
				if (request.data.length > 0) {
					
					lime_sound_channel_add_data (__handle, request.data);
					
				}
				
			}
			
			#if (!audio_thread_disabled && !emscripten)
			
			if (__addedToThread || (__soundInstance != null && __soundInstance.__audioType == InternalAudioType.MUSIC)) {
				
				if (__audioState == null) {
					
					__audioState = new AudioThreadState ();
					
					__audioThreadRunning = true;
					__audioThreadIsIdle = false;
					
					__audioState.mainThread = Thread.current ();
					__audioState.audioThread = Thread.create (__checkCompleteBackgroundThread);

				}
				
				if (!__addedToThread) {
					
					__audioState.add (this);
					__addedToThread = true;

				}
				
				return __thread_completed;
				
			} else
			
			#end
			
			if (__runCheckComplete ()) {
				
				return true;
				
			}
			
			return false;
			
		} else {
			
			return true;
			
		}
		
	}
	
	
	#if (!audio_thread_disabled && !emscripten)
	
	private static function __checkCompleteBackgroundThread () {		
		
		while (__audioThreadRunning) {

			if (!__audioThreadIsIdle) {
				
				__audioState.updateComplete ();

				Sys.sleep (0.01);
				
			} else {
				
				Sys.sleep (0.2);
				
			}
			
		}
		
		__audioThreadRunning = false;
		__audioThreadIsIdle = true;
		
	}
	
	#end
	
	
	@:noCompletion public static function __completePending ():Bool {
		
		return __incompleteList.length > 0;
		
	}
	
	
	@:noCompletion public static function __pollComplete ():Void {
		
		var i = __incompleteList.length;
		
		while (--i >= 0) {
			
			if (__incompleteList[i].__checkComplete ()) {
				
				__incompleteList.splice (i, 1);
				
			}
			
		}
		
	}
	
	
	@:noCompletion public function __runCheckComplete ():Bool {
		
		if (lime_sound_channel_is_complete (__handle)) {
			
			__soundInstance = null;
			__handle = null;
			
			if (__dataProvider != null) {
				
				__dynamicSoundCount--;
				
			}

			var completeEvent = new Event (Event.SOUND_COMPLETE);
				dispatchEvent (completeEvent);
			
			return true;
			
		}
		
		return false;
		
	}
	
	
	
	
	// Getters & Setters
	
	
	
	
	private function get_leftPeak ():Float { return lime_sound_channel_get_left (__handle); }
	private function get_rightPeak ():Float { return lime_sound_channel_get_right (__handle); }
	private function get_position ():Float { return lime_sound_channel_get_position (__handle); }
	private function set_position (value:Float):Float { return lime_sound_channel_set_position (__handle, position); }
	
	
	private function get_soundTransform ():SoundTransform {
		
		if (__transform == null) {
			
			__transform = new SoundTransform ();
			
		}
		
		return __transform.clone ();
		
	}
	
	
	private function set_soundTransform (value:SoundTransform):SoundTransform {
		
		__transform = value.clone ();
		lime_sound_channel_set_transform (__handle, __transform);
		
		return value;
		
	}
	
	
	
	
	// Native Methods
	
	
	
	
	private static function __init__ () {
		
		lime_sound_channel_is_complete = Lib.load ("lime", "lime_sound_channel_is_complete", 1);
		lime_sound_channel_get_left = Lib.load ("lime", "lime_sound_channel_get_left", 1);
		lime_sound_channel_get_right = Lib.load ("lime", "lime_sound_channel_get_right", 1);
		lime_sound_channel_get_position = Lib.load ("lime", "lime_sound_channel_get_position", 1);
		lime_sound_channel_set_position = Lib.load ("lime", "lime_sound_channel_set_position", 2);
		lime_sound_channel_get_data_position = Lib.load ("lime", "lime_sound_channel_get_data_position", 1);
		lime_sound_channel_stop = Lib.load ("lime", "lime_sound_channel_stop", 1);
		lime_sound_channel_create = Lib.load ("lime", "lime_sound_channel_create", 4);
		lime_sound_channel_set_transform = Lib.load ("lime", "lime_sound_channel_set_transform", 2);
		lime_sound_channel_needs_data = Lib.load ("lime", "lime_sound_channel_needs_data", 1);
		lime_sound_channel_add_data = Lib.load ("lime", "lime_sound_channel_add_data", 2);
		
	}
	
	
	private static var lime_sound_channel_is_complete;
	private static var lime_sound_channel_get_left;
	private static var lime_sound_channel_get_right;
	private static var lime_sound_channel_get_position;
	private static var lime_sound_channel_set_position;
	private static var lime_sound_channel_get_data_position;
	private static var lime_sound_channel_stop;
	private static var lime_sound_channel_create;
	private static var lime_sound_channel_set_transform;
	private static var lime_sound_channel_needs_data;
	private static var lime_sound_channel_add_data;
	
	
}


#if (!audio_thread_disabled && !emscripten)

@:access(openfl.media.SoundChannel) class AudioThreadState {
	
	
	public var audioThread:Thread;
	public var channelList:Array<SoundChannel>;
	public var mainThread:Thread;
	public var mutex:Mutex;
	
	
	public function new () {
		 
		mutex = new Mutex ();
		channelList = [];
		
	}
	
	
	public function add (channel:SoundChannel):Void {
		
		if (!Lambda.has( channelList, channel ) ) {
			
			channelList.push( channel );
			SoundChannel.__audioThreadIsIdle = false;
			
		}
		
	}
	
	
	public function remove (channel:SoundChannel):Void {
		
		mutex.acquire ();
		
		if ( Lambda.has(channelList,channel) ) {			

				//flag as removed because we are no longer tracking
			channel.__addedToThread = false;
				//and whenever we remove from this we are considering it
				//completed so we set the flag here too
			channel.__thread_completed = true;
				
				//remove it from the list	
			channelList.remove (channel);

				//if there are no more, idle for CPU
			if (channelList.length == 0) {
				
				SoundChannel.__audioThreadIsIdle = true;
				
			}
			
		}
			
		mutex.release ();
		
	}
	
	
	public function updateComplete () {
		
		mutex.acquire();

		for (channel in channelList) {
			
			if(channel != null) {

				if(channel.__runCheckComplete()){
					remove(channel);
				}

			} else {

				channelList.remove (channel);

			}
			
		}

		mutex.release();
		
	}
	
	
}

#end
