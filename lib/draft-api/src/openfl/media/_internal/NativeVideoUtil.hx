package openfl.media._internal;
import haxe.Constraints.Function;
import lime.media.openal.AL;
import lime.media.openal.ALBuffer;
import lime.media.openal.ALSource;
import lime.system.BackgroundWorker;
import sys.thread.Deque;

/**
 * ...
 * @author Christopher Speciale
 */
class NativeVideoUtil
{

	static var worker = new BackgroundWorker();
	/**
	 * Delays a callback function for the specified time in seconds.
	 * Accurate to ~2ms assuming timeBeginPeriod(1) is active.
	 */
	public static function delay(callback:Void->Void, seconds:Float, eventQueue:Deque<Void->Void>):Void
	{
		var workerObj:WorkerObject = {
			delay_worker: worker,
			delay_callback: callback,
			delay_seconds: seconds,
			delay_event_queue: eventQueue
		};

		worker.doWork.add(__backgroundWork);
		worker.run(workerObj);
	}

	private static function __backgroundWork(obj:WorkerObject):Void
	{
		usleep(obj.delay_seconds);
		obj.delay_event_queue.add(obj.delay_callback);
		worker.doWork.remove(__backgroundWork);
	}

	/**
	 * Sleeps for the specified time in seconds.
	 * Accurate to ~2ms assuming timeBeginPeriod(1) is active.
	 */
	public static function usleep(seconds:Float):Void
	{
		/*if (seconds <= 0) return;

		var target = Sys.time() + seconds;

		if (seconds >= 0.002)
		{
			//trace('longsleep');
			Sys.sleep(0);
		}*/

		@:inline spinlock(seconds);
	}

	public static function spinlock(seconds:Float):Void
	{
		var pTime = timestamp();

		while (timestamp() - pTime < seconds)
		{
			//Sys.sleep(0);
		}
	}

	public static inline function timestamp():Float
	{
		//we need to pass this from cffi for hl and neko
		#if cpp
		return untyped __global__.__time_stamp();
		#end
		//we need to pass this from cffi for hl and neko
		#if hl
		//TODO: hashlink cffi
		#end
		#if neko
		//TODO: Neko cffi
		#end
		//return 0.0;
	}
	
		@:noCompletion public static function setupAL(bufferCount:Int):ALObject
	{
		var buffers:Array<ALBuffer> = AL.genBuffers(bufferCount);
		var source:ALSource = AL.createSource();
		
		var ret:ALObject = {
			buffers:buffers,
			source:source
		}
		
		return ret;
	}
}

@:noCompletion private typedef ALObject = {
	buffers:Array<ALBuffer>,
	source:ALSource
}
	

@:noCompletion private typedef WorkerObject =
{
	delay_worker:BackgroundWorker,
	delay_callback:Void->Void,
	delay_seconds:Float,
	delay_event_queue:Deque<Void->Void>
}