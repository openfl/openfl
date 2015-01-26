package openfl.media; #if !flash #if !lime_legacy


import haxe.io.Path;
import lime.audio.AudioBuffer;
import lime.audio.AudioSource;
import openfl.events.Event;
import openfl.events.EventDispatcher;
import openfl.events.IOErrorEvent;
import openfl.net.URLRequest;
import openfl.utils.ByteArray;


/**
 * The Sound class lets you work with sound in an application. The Sound class
 * lets you create a Sound object, load and play an external MP3 file into
 * that object, close the sound stream, and access data about the sound, such
 * as information about the number of bytes in the stream and ID3 metadata.
 * More detailed control of the sound is performed through the sound source
 *  -  the SoundChannel or Microphone object for the sound  -  and through the
 * properties in the SoundTransform class that control the output of the sound
 * to the computer's speakers.
 *
 * <p>In Flash Player 10 and later and AIR 1.5 and later, you can also use
 * this class to work with sound that is generated dynamically. In this case,
 * the Sound object uses the function you assign to a <code>sampleData</code>
 * event handler to poll for sound data. The sound is played as it is
 * retrieved from a ByteArray object that you populate with sound data. You
 * can use <code>Sound.extract()</code> to extract sound data from a Sound
 * object, after which you can manipulate it before writing it back to the
 * stream for playback.</p>
 *
 * <p>To control sounds that are embedded in a SWF file, use the properties in
 * the SoundMixer class.</p>
 *
 * <p><b>Note</b>: The ActionScript 3.0 Sound API differs from ActionScript
 * 2.0. In ActionScript 3.0, you cannot take sound objects and arrange them in
 * a hierarchy to control their properties.</p>
 *
 * <p>When you use this class, consider the following security model: </p>
 *
 * <ul>
 *   <li>Loading and playing a sound is not allowed if the calling file is in
 * a network sandbox and the sound file to be loaded is local.</li>
 *   <li>By default, loading and playing a sound is not allowed if the calling
 * file is local and tries to load and play a remote sound. A user must grant
 * explicit permission to allow this type of access.</li>
 *   <li>Certain operations dealing with sound are restricted. The data in a
 * loaded sound cannot be accessed by a file in a different domain unless you
 * implement a cross-domain policy file. Sound-related APIs that fall under
 * this restriction are <code>Sound.id3</code>,
 * <code>SoundMixer.computeSpectrum()</code>,
 * <code>SoundMixer.bufferTime</code>, and the <code>SoundTransform</code>
 * class.</li>
 * </ul>
 *
 * <p>However, in Adobe AIR, content in the <code>application</code> security
 * sandbox(content installed with the AIR application) are not restricted by
 * these security limitations.</p>
 *
 * <p>For more information related to security, see the Flash Player Developer
 * Center Topic: <a href="http://www.adobe.com/go/devnet_security_en"
 * scope="external">Security</a>.</p>
 * 
 * @event complete   Dispatched when data has loaded successfully.
 * @event id3        Dispatched by a Sound object when ID3 data is available
 *                   for an MP3 sound.
 * @event ioError    Dispatched when an input/output error occurs that causes
 *                   a load operation to fail.
 * @event open       Dispatched when a load operation starts.
 * @event progress   Dispatched when data is received as a load operation
 *                   progresses.
 * @event sampleData Dispatched when the runtime requests new audio data.
 */

@:autoBuild(openfl.Assets.embedSound())


class Sound extends EventDispatcher {
	
	
	#if html5
	@:noCompletion private static var __registeredSounds = new Map<String, Bool> ();
	#end
	
	/**
	 * Returns the currently available number of bytes in this sound object. This
	 * property is usually useful only for externally loaded files.
	 */
	public var bytesLoaded (default, null):Int;
	
	/**
	 * Returns the total number of bytes in this sound object.
	 */
	public var bytesTotal (default, null):Int;
	
	/**
	 * Provides access to the metadata that is part of an MP3 file.
	 *
	 * <p>MP3 sound files can contain ID3 tags, which provide metadata about the
	 * file. If an MP3 sound that you load using the <code>Sound.load()</code>
	 * method contains ID3 tags, you can query these properties. Only ID3 tags
	 * that use the UTF-8 character set are supported.</p>
	 *
	 * <p>Flash Player 9 and later and AIR support ID3 2.0 tags, specifically 2.3
	 * and 2.4. The following tables list the standard ID3 2.0 tags and the type
	 * of content the tags represent. The <code>Sound.id3</code> property
	 * provides access to these tags through the format
	 * <code>my_sound.id3.COMM</code>, <code>my_sound.id3.TIME</code>, and so on.
	 * The first table describes tags that can be accessed either through the ID3
	 * 2.0 property name or the ActionScript property name. The second table
	 * describes ID3 tags that are supported but do not have predefined
	 * properties in ActionScript. </p>
	 *
	 * <p>When using this property, consider the Flash Player security model:</p>
	 *
	 * <ul>
	 *   <li>The <code>id3</code> property of a Sound object is always permitted
	 * for SWF files that are in the same security sandbox as the sound file. For
	 * files in other sandboxes, there are security checks.</li>
	 *   <li>When you load the sound, using the <code>load()</code> method of the
	 * Sound class, you can specify a <code>context</code> parameter, which is a
	 * SoundLoaderContext object. If you set the <code>checkPolicyFile</code>
	 * property of the SoundLoaderContext object to <code>true</code>, Flash
	 * Player checks for a URL policy file on the server from which the sound is
	 * loaded. If a policy file exists and permits access from the domain of the
	 * loading SWF file, then the file is allowed to access the <code>id3</code>
	 * property of the Sound object; otherwise it is not.</li>
	 * </ul>
	 *
	 * <p>However, in Adobe AIR, content in the <code>application</code> security
	 * sandbox(content installed with the AIR application) are not restricted by
	 * these security limitations.</p>
	 *
	 * <p>For more information related to security, see the Flash Player
	 * Developer Center Topic: <a
	 * href="http://www.adobe.com/go/devnet_security_en"
	 * scope="external">Security</a>.</p>
	 */
	public var id3 (get, null):ID3Info;
	
	/**
	 * Returns the buffering state of external MP3 files. If the value is
	 * <code>true</code>, any playback is currently suspended while the object
	 * waits for more data.
	 */
	public var isBuffering (default, null):Bool;
	
	/**
	 * The length of the current sound in milliseconds.
	 */
	public var length (default, null):Float;
	
	/**
	 * The URL from which this sound was loaded. This property is applicable only
	 * to Sound objects that were loaded using the <code>Sound.load()</code>
	 * method. For Sound objects that are associated with a sound asset from a
	 * SWF file's library, the value of the <code>url</code> property is
	 * <code>null</code>.
	 *
	 * <p>When you first call <code>Sound.load()</code>, the <code>url</code>
	 * property initially has a value of <code>null</code>, because the final URL
	 * is not yet known. The <code>url</code> property will have a non-null value
	 * as soon as an <code>open</code> event is dispatched from the Sound
	 * object.</p>
	 *
	 * <p>The <code>url</code> property contains the final, absolute URL from
	 * which a sound was loaded. The value of <code>url</code> is usually the
	 * same as the value passed to the <code>stream</code> parameter of
	 * <code>Sound.load()</code>. However, if you passed a relative URL to
	 * <code>Sound.load()</code> the value of the <code>url</code> property
	 * represents the absolute URL. Additionally, if the original URL request is
	 * redirected by an HTTP server, the value of the <code>url</code> property
	 * reflects the final URL from which the sound file was actually downloaded.
	 * This reporting of an absolute, final URL is equivalent to the behavior of
	 * <code>LoaderInfo.url</code>.</p>
	 *
	 * <p>In some cases, the value of the <code>url</code> property is truncated;
	 * see the <code>isURLInaccessible</code> property for details.</p>
	 */
	public var url (default, null):String;
	
	@:noCompletion private var __buffer:AudioBuffer;
	
	#if html5
	@:noCompletion private var __sound:SoundJSInstance;
	@:noCompletion private var __soundID:String;
	#end
	
	
	/**
	 * Creates a new Sound object. If you pass a valid URLRequest object to the
	 * Sound constructor, the constructor automatically calls the
	 * <code>load()</code> function for the Sound object. If you do not pass a
	 * valid URLRequest object to the Sound constructor, you must call the
	 * <code>load()</code> function for the Sound object yourself, or the stream
	 * will not load.
	 *
	 * <p>Once <code>load()</code> is called on a Sound object, you can't later
	 * load a different sound file into that Sound object. To load a different
	 * sound file, create a new Sound object.</p>
	 * In Flash Player 10 and later and AIR 1.5 and later, instead of using
	 * <code>load()</code>, you can use the <code>sampleData</code> event handler
	 * to load sound dynamically into the Sound object.
	 * 
	 * @param stream  The URL that points to an external MP3 file.
	 * @param context An optional SoundLoader context object, which can define
	 *                the buffer time(the minimum number of milliseconds of MP3
	 *                data to hold in the Sound object's buffer) and can specify
	 *                whether the application should check for a cross-domain
	 *                policy file prior to loading the sound.
	 */
	public function new (stream:URLRequest = null, context:SoundLoaderContext = null) {
		
		super (this);
		
		bytesLoaded = 0;
		bytesTotal = 0;
		id3 = null;
		isBuffering = false;
		length = 0;
		url = null;
		
		if (stream != null) {
			
			load (stream, context);
			
		}
		
	}
	
	
	/**
	 * Closes the stream, causing any download of data to cease. No data may be
	 * read from the stream after the <code>close()</code> method is called.
	 * 
	 * @throws IOError The stream could not be closed, or the stream was not
	 *                 open.
	 */
	public function close ():Void {
		
		#if !html5
		if (__buffer != null) {
			
			__buffer.dispose ();
			
		}
		#else
		if (__registeredSounds.exists (__soundID)) {
			
			SoundJS.removeSound (__soundID);
			
		}
		#end
		
	}
	
	
	public static function fromAudioBuffer (buffer:AudioBuffer):Sound {
		
		var sound = new Sound ();
		sound.__buffer = buffer;
		return sound;
		
	}
	
	
	/**
	 * Initiates loading of an external MP3 file from the specified URL. If you
	 * provide a valid URLRequest object to the Sound constructor, the
	 * constructor calls <code>Sound.load()</code> for you. You only need to call
	 * <code>Sound.load()</code> yourself if you don't pass a valid URLRequest
	 * object to the Sound constructor or you pass a <code>null</code> value.
	 *
	 * <p>Once <code>load()</code> is called on a Sound object, you can't later
	 * load a different sound file into that Sound object. To load a different
	 * sound file, create a new Sound object.</p>
	 *
	 * <p>When using this method, consider the following security model:</p>
	 *
	 * <ul>
	 *   <li>Calling <code>Sound.load()</code> is not allowed if the calling file
	 * is in the local-with-file-system sandbox and the sound is in a network
	 * sandbox.</li>
	 *   <li>Access from the local-trusted or local-with-networking sandbox
	 * requires permission from a website through a URL policy file.</li>
	 *   <li>You cannot connect to commonly reserved ports. For a complete list
	 * of blocked ports, see "Restricting Networking APIs" in the <i>ActionScript
	 * 3.0 Developer's Guide</i>.</li>
	 *   <li>You can prevent a SWF file from using this method by setting the
	 * <code>allowNetworking</code> parameter of the <code>object</code> and
	 * <code>embed</code> tags in the HTML page that contains the SWF
	 * content.</li>
	 * </ul>
	 *
	 * <p> In Flash Player 10 and later, if you use a multipart Content-Type(for
	 * example "multipart/form-data") that contains an upload(indicated by a
	 * "filename" parameter in a "content-disposition" header within the POST
	 * body), the POST operation is subject to the security rules applied to
	 * uploads:</p>
	 *
	 * <ul>
	 *   <li>The POST operation must be performed in response to a user-initiated
	 * action, such as a mouse click or key press.</li>
	 *   <li>If the POST operation is cross-domain(the POST target is not on the
	 * same server as the SWF file that is sending the POST request), the target
	 * server must provide a URL policy file that permits cross-domain
	 * access.</li>
	 * </ul>
	 *
	 * <p>Also, for any multipart Content-Type, the syntax must be valid
	 * (according to the RFC2046 standards). If the syntax appears to be invalid,
	 * the POST operation is subject to the security rules applied to
	 * uploads.</p>
	 *
	 * <p>In Adobe AIR, content in the <code>application</code> security sandbox
	 * (content installed with the AIR application) are not restricted by these
	 * security limitations.</p>
	 *
	 * <p>For more information related to security, see the Flash Player
	 * Developer Center Topic: <a
	 * href="http://www.adobe.com/go/devnet_security_en"
	 * scope="external">Security</a>.</p>
	 * 
	 * @param stream  A URL that points to an external MP3 file.
	 * @param context An optional SoundLoader context object, which can define
	 *                the buffer time(the minimum number of milliseconds of MP3
	 *                data to hold in the Sound object's buffer) and can specify
	 *                whether the application should check for a cross-domain
	 *                policy file prior to loading the sound.
	 * @throws IOError       A network error caused the load to fail.
	 * @throws IOError       The <code>digest</code> property of the
	 *                       <code>stream</code> object is not <code>null</code>.
	 *                       You should only set the <code>digest</code> property
	 *                       of a URLRequest object when calling the
	 *                       <code>URLLoader.load()</code> method when loading a
	 *                       SWZ file(an Adobe platform component).
	 * @throws SecurityError Local untrusted files may not communicate with the
	 *                       Internet. You can work around this by reclassifying
	 *                       this file as local-with-networking or trusted.
	 * @throws SecurityError You cannot connect to commonly reserved ports. For a
	 *                       complete list of blocked ports, see "Restricting
	 *                       Networking APIs" in the <i>ActionScript 3.0
	 *                       Developer's Guide</i>.
	 */
	public function load (stream:URLRequest, context:SoundLoaderContext = null):Void {
		
		#if !html5
		AudioBuffer.fromURL (stream.url, AudioBuffer_onURLLoad);
		#else
		url = stream.url;
		__soundID = Path.withoutExtension (stream.url);
		
		if (!__registeredSounds.exists (__soundID)) {
			
			__registeredSounds.set (__soundID, true);
			SoundJS.addEventListener ("fileload", SoundJS_onFileLoad);
			SoundJS.addEventListener ("fileerror", SoundJS_onFileError);
			SoundJS.registerSound (url, __soundID);
			
		} else {
			
			dispatchEvent (new Event (Event.COMPLETE));
			
		}
		#end
		
	}
	
	
	public function loadCompressedDataFromByteArray (bytes:ByteArray, bytesLength:Int, forcePlayAsMusic = false):Void {
		
		// TODO: handle byte length
		
		#if !html5
		__buffer = AudioBuffer.fromBytes (bytes);
		#else
		openfl.Lib.notImplemented ("Sound.loadCompressedDataFromByteArray");
		#end
		
	}
	
	
	public function loadPCMFromByteArray (bytes:ByteArray, samples:Int, format:String = null, stereo:Bool = true, sampleRate:Float = 44100):Void {
		
		// TODO: handle pre-decoded data
		
		#if !html5
		__buffer = AudioBuffer.fromBytes (bytes);
		#else
		openfl.Lib.notImplemented ("Sound.loadPCMFromByteArray");
		#end
		
	}
	
	
	/**
	 * Generates a new SoundChannel object to play back the sound. This method
	 * returns a SoundChannel object, which you access to stop the sound and to
	 * monitor volume.(To control the volume, panning, and balance, access the
	 * SoundTransform object assigned to the sound channel.)
	 * 
	 * @param startTime    The initial position in milliseconds at which playback
	 *                     should start.
	 * @param loops        Defines the number of times a sound loops back to the
	 *                     <code>startTime</code> value before the sound channel
	 *                     stops playback.
	 * @param sndTransform The initial SoundTransform object assigned to the
	 *                     sound channel.
	 * @return A SoundChannel object, which you use to control the sound. This
	 *         method returns <code>null</code> if you have no sound card or if
	 *         you run out of available sound channels. The maximum number of
	 *         sound channels available at once is 32.
	 */
	public function play (startTime:Float = 0.0, loops:Int = 0, sndTransform:SoundTransform = null):SoundChannel {
		
		if (sndTransform == null) {
			
			sndTransform = new SoundTransform (1, 0);
			
		}
		
		// TODO: handle start time, loops, sound transform
		
		#if !html5
		var source = new AudioSource (__buffer);
		return new SoundChannel (source);
		#else
		var instance = SoundJS.play (__soundID, SoundJS.INTERRUPT_ANY, 0, Std.int (startTime), loops, sndTransform.volume, sndTransform.pan);
		return new SoundChannel (instance);
		#end
		
	}
	
	
	#if html5
	@:noCompletion private static function __init__ ():Void {
		
		if (untyped window.createjs != null) {
			
			SoundJS.alternateExtensions = [ "ogg", "mp3", "wav" ];
			
		}
		
	}
	#end
	
	
	
	
	// Get & Set Methods
	
	
	
	
	@:noCompletion private function get_id3 ():ID3Info {
		
		return new ID3Info ();
		
	}
	
	
	
	
	// Event Handlers
	
	
	
	
	@:noCompletion private function AudioBuffer_onURLLoad (buffer:AudioBuffer):Void {
		
		__buffer = buffer;
		dispatchEvent (new Event (Event.COMPLETE));
		
	}
	
	
	#if html5
	@:noCompletion private function SoundJS_onFileLoad (event:Dynamic):Void {
		
		if (event.id == __soundID) {
			
			SoundJS.removeEventListener ("fileload", SoundJS_onFileLoad);
			SoundJS.removeEventListener ("fileerror", SoundJS_onFileError);
			dispatchEvent (new Event (Event.COMPLETE));
			
		}
		
	}
	
	@:noCompletion private function SoundJS_onFileError (event:Dynamic):Void {
		
		if (event.id == __soundID) {
			
			SoundJS.removeEventListener ("fileload", SoundJS_onFileLoad);
			SoundJS.removeEventListener ("fileerror", SoundJS_onFileError);
			dispatchEvent (new IOErrorEvent (IOErrorEvent.IO_ERROR));
			
		}
		
	}
	#end
	
	
}


#if html5
@:native("createjs.Sound") extern class SoundJS {
	
	public static function addEventListener (type:String, listener:Dynamic, ?useCapture:Bool):Dynamic;
	public static function dispatchEvent (eventObj:Dynamic, ?target:Dynamic):Bool;
	public static function hasEventListener (type:String):Bool;
	public static function removeAllEventListeners (?type:String):Void;
	public static function removeEventListener (type:String, listener:Dynamic, ?useCapture:Bool):Void;
	
	public static function createInstance (src:String):SoundJSInstance;
	public static function getCapabilities ():Dynamic;
	public static function getCapability (key:String):Dynamic;
	public static function getMute ():Bool;
	public static function getVolume ():Float;
	public static function initializeDefaultPlugins ():Bool;
	public static function isReady ():Bool;
	public static function loadComplete (src:String):Bool;
	//public static function mute(value:Bool):Void;
	public static function play (src:String, ?interrupt:String = INTERRUPT_NONE, ?delay:Int = 0, ?offset:Int = 0, ?loop:Int = 0, ?volume:Float = 1, ?pan:Float = 0):SoundJSInstance;
	public static function registerManifest (manifest:Array<Dynamic>, basepath:String):Dynamic;
	public static function registerPlugin (plugin:Dynamic):Bool;
	public static function registerPlugins (plugins:Array<Dynamic>):Bool;
	public static function registerSound (src:String, ?id:String, ?data:Float, ?preload:Bool = true):Dynamic;
	
	public static function removeAllSounds ():Void;
	public static function removeManifest (manifest:Array<Dynamic>):Dynamic;
	public static function removeSound (src:String):Void;
	
	public static function setMute (value:Bool):Bool;
	public static function setVolume (value:Float):Void;
	public static function stop ():Void;
	
	public static var activePlugin:Dynamic;
	public static var alternateExtensions:Array<String>;
	//public static var AUDIO_TIMEOUT:Float;
	public static var defaultInterruptBehavior:String;
	public static var DELIMITER:String;
	//public static var EXTENSION_MAP:Dynamic;
	public static inline var INTERRUPT_ANY:String = "any";
	public static inline var INTERRUPT_EARLY:String = "early";
	public static inline var INTERRUPT_LATE:String = "late";
	public static inline var INTERRUPT_NONE:String = "none";
	//public var onLoadComplete:Dynamic->Void;
	public static var PLAY_FAILED:String;
	public static var PLAY_FINISHED:String;
	public static var PLAY_INITED:String;
	public static var PLAY_INTERRUPTED:String;
	public static var PLAY_SUCCEEDED:String;
	public static var SUPPORTED_EXTENSIONS:Array<String>;
	
}


@:native("createjs.SoundInstance") extern class SoundJSInstance extends SoundJSEventDispatcher {
	
	public function new (src:String, owner:Dynamic):Void;
	public function getDuration ():Int;
	public function getMute ():Bool;
	public function getPan ():Float;
	public function getPosition ():Int;
	public function getVolume ():Float;
	//public function mute (value:Bool):Bool;
	public function pause ():Bool;
	public function play (?interrupt:String = Sound.INTERRUPT_NONE, ?delay:Int = 0, ?offset:Int = 0, ?loop:Int = 0, ?volume:Float = 1, ?pan:Float = 0):Void;
	public function resume ():Bool;
	public function setMute (value:Bool):Bool;
	public function setPan (value:Float):Float;
	public function setPosition (value:Int):Void;
	public function setVolume (value:Float):Bool;
	public function stop ():Bool;
	
	public var gainNode:Dynamic;
	public var pan:Float;
	public var panNode:Dynamic;
	public var playState:String;
	public var sourceNode:Dynamic;
	//public var startTime:Float;
	public var uniqueId:Dynamic;
	public var volume:Float;
	
	public var onComplete:SoundJSInstance->Void;
	public var onLoop:SoundJSInstance->Void;
	public var onPlayFailed:SoundJSInstance->Void;
	public var onPlayInterrupted:SoundJSInstance->Void;
	public var onPlaySucceeded:SoundJSInstance->Void;
	public var onReady:SoundJSInstance->Void;
	
}


@:native("createjs.EventDispatcher") extern class SoundJSEventDispatcher {
	
	public function addEventListener (type:String, listener:Dynamic, ?useCapture:Bool):Dynamic;
	public function dispatchEvent (eventObj:Dynamic, ?target:Dynamic):Bool;
	public function hasEventListener (type:String):Bool;
	public static function initialize (target:Dynamic):Void;
	public function off (type:String, listener:Dynamic, ?useCapture:Bool):Bool;
	public function on (type:String, listener:Dynamic, ?scope:Dynamic, ?once:Bool=false, ?data:Dynamic = null, ?useCapture:Bool=false):Dynamic;
	public function removeAllEventListeners (?type:String):Void;
	public function removeEventListener(type:String, listener:Dynamic, ?useCapture:Bool):Void;
	public function toString ():String;
	
}
#end


#else
typedef Sound = openfl._v2.media.Sound;
#end
#else
typedef Sound = flash.media.Sound;
#end