package openfl._internal.backend.lime_standalone;

#if openfl_html5
import openfl.geom.Vector3D;

class AudioSource
{
	public var onComplete = new LimeEvent<Void->Void>();
	public var buffer:AudioBuffer;
	public var currentTime(get, set):Int;
	public var gain(get, set):Float;
	public var length(get, set):Int;
	public var loops(get, set):Int;
	public var offset:Int;
	public var position(get, set):Vector3D;

	@:noCompletion private var __backend:AudioSourceBackend;

	public function new(buffer:AudioBuffer = null, offset:Int = 0, length:Null<Int> = null, loops:Int = 0)
	{
		this.buffer = buffer;
		this.offset = offset;

		__backend = new AudioSourceBackend(this);

		if (length != null && length != 0)
		{
			this.length = length;
		}

		this.loops = loops;

		if (buffer != null)
		{
			init();
		}
	}

	public function dispose():Void
	{
		__backend.dispose();
	}

	@:noCompletion private function init():Void
	{
		__backend.init();
	}

	public function play():Void
	{
		__backend.play();
	}

	public function pause():Void
	{
		__backend.pause();
	}

	public function stop():Void
	{
		__backend.stop();
	}

	// Get & Set Methods
	@:noCompletion private function get_currentTime():Int
	{
		return __backend.getCurrentTime();
	}

	@:noCompletion private function set_currentTime(value:Int):Int
	{
		return __backend.setCurrentTime(value);
	}

	@:noCompletion private function get_gain():Float
	{
		return __backend.getGain();
	}

	@:noCompletion private function set_gain(value:Float):Float
	{
		return __backend.setGain(value);
	}

	@:noCompletion private function get_length():Int
	{
		return __backend.getLength();
	}

	@:noCompletion private function set_length(value:Int):Int
	{
		return __backend.setLength(value);
	}

	@:noCompletion private function get_loops():Int
	{
		return __backend.getLoops();
	}

	@:noCompletion private function set_loops(value:Int):Int
	{
		return __backend.setLoops(value);
	}

	@:noCompletion private function get_position():Vector3D
	{
		return __backend.getPosition();
	}

	@:noCompletion private function set_position(value:Vector3D):Vector3D
	{
		return __backend.setPosition(value);
	}
}

@:noCompletion private typedef AudioSourceBackend = HTML5AudioSource;

@:access(openfl._internal.backend.lime_standalone.AudioBuffer)
class HTML5AudioSource
{
	private var completed:Bool;
	private var gain:Float;
	private var id:Int;
	private var length:Int;
	private var loops:Int;
	private var parent:AudioSource;
	private var playing:Bool;
	private var position:Vector3D;

	public function new(parent:AudioSource)
	{
		this.parent = parent;

		id = -1;
		gain = 1;
		position = new Vector3D();
	}

	public function dispose():Void {}

	public function init():Void {}

	public function play():Void
	{
		if (playing || parent.buffer == null || parent.buffer.__srcHowl == null)
		{
			return;
		}

		playing = true;

		var time = getCurrentTime();

		completed = false;

		var cacheVolume = untyped parent.buffer.__srcHowl._volume;
		untyped parent.buffer.__srcHowl._volume = parent.gain;

		id = parent.buffer.__srcHowl.play();

		untyped parent.buffer.__srcHowl._volume = cacheVolume;
		// setGain (parent.gain);

		setPosition(parent.position);

		parent.buffer.__srcHowl.on("end", howl_onEnd, id);

		setCurrentTime(time);
	}

	public function pause():Void
	{
		playing = false;

		if (parent.buffer != null && parent.buffer.__srcHowl != null)
		{
			parent.buffer.__srcHowl.pause(id);
		}
	}

	public function stop():Void
	{
		playing = false;

		if (parent.buffer != null && parent.buffer.__srcHowl != null)
		{
			parent.buffer.__srcHowl.stop(id);
			parent.buffer.__srcHowl.off("end", howl_onEnd, id);
		}
	}

	// Event Handlers
	private function howl_onEnd()
	{
		playing = false;

		if (loops > 0)
		{
			loops--;
			stop();
			// currentTime = 0;
			play();
			return;
		}
		else if (parent.buffer != null && parent.buffer.__srcHowl != null)
		{
			parent.buffer.__srcHowl.stop(id);
			parent.buffer.__srcHowl.off("end", howl_onEnd, id);
		}

		completed = true;
		parent.onComplete.dispatch();
	}

	// Get & Set Methods
	public function getCurrentTime():Int
	{
		if (id == -1)
		{
			return 0;
		}

		if (completed)
		{
			return getLength();
		}
		else if (parent.buffer != null && parent.buffer.__srcHowl != null)
		{
			var time = Std.int(parent.buffer.__srcHowl.seek(id) * 1000) - parent.offset;
			if (time < 0) return 0;
			return time;
		}

		return 0;
	}

	public function setCurrentTime(value:Int):Int
	{
		if (parent.buffer != null && parent.buffer.__srcHowl != null)
		{
			// if (playing) buffer.__srcHowl.play (id);
			var pos = (value + parent.offset) / 1000;
			if (pos < 0) pos = 0;
			parent.buffer.__srcHowl.seek(pos, id);
		}

		return value;
	}

	public function getGain():Float
	{
		return gain;
	}

	public function setGain(value:Float):Float
	{
		// set howler volume only if we have an active id.
		// Passing -1 might create issues in future play()'s.

		if (parent.buffer != null && parent.buffer.__srcHowl != null && id != -1)
		{
			parent.buffer.__srcHowl.volume(value, id);
		}

		return gain = value;
	}

	public function getLength():Int
	{
		if (length != 0)
		{
			return length;
		}

		if (parent.buffer != null && parent.buffer.__srcHowl != null)
		{
			return Std.int(parent.buffer.__srcHowl.duration() * 1000);
		}

		return 0;
	}

	public function setLength(value:Int):Int
	{
		return length = value;
	}

	public function getLoops():Int
	{
		return loops;
	}

	public function setLoops(value:Int):Int
	{
		return loops = value;
	}

	public function getPosition():Vector3D
	{
		// This should work, but it returns null (But checking the inside of the howl, the _pos is actually null... so ¯\_(ツ)_/¯)
		/*
			var arr = parent.buffer.__srcHowl.pos())
			position.x = arr[0];
			position.y = arr[1];
			position.z = arr[2];
		 */

		return position;
	}

	public function setPosition(value:Vector3D):Vector3D
	{
		position.x = value.x;
		position.y = value.y;
		position.z = value.z;
		position.w = value.w;

		if (parent.buffer.__srcHowl != null && parent.buffer.__srcHowl.pos != null) parent.buffer.__srcHowl.pos(position.x, position.y, position.z, id);
		// There are more settings to the position of the sound on the "pannerAttr()" function of howler. Maybe somebody who understands sound should look into it?

		return position;
	}
}
#end
