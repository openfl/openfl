import ID3Info from "./ID3Info";
import SoundChannel from "./SoundChannel";
import SoundLoaderContext from "./SoundLoaderContext";
import SoundTransform from "./SoundTransform";
import EventDispatcher from "./../events/EventDispatcher";
import URLRequest from "./../net/URLRequest";
import ByteArray from "./../utils/ByteArray";
import Future from "./../utils/Future";

type AudioBuffer = any;


declare namespace openfl.media {
	
	
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
	 * In Flash Player 10 and later and AIR 1.5 and later, you can also use
	 * this class to work with sound that is generated dynamically. In this case,
	 * the Sound object uses the you assign to a `sampleData`
	 * event handler to poll for sound data. The sound is played as it is
	 * retrieved from a ByteArray object that you populate with sound data. You
	 * can use `Sound.extract()` to extract sound data from a Sound
	 * object, after which you can manipulate it before writing it back to the
	 * stream for playback.
	 *
	 * To control sounds that are embedded in a SWF file, use the properties in
	 * the SoundMixer class.
	 *
	 * **Note**: The ActionScript 3.0 Sound API differs from ActionScript
	 * 2.0. In ActionScript 3.0, you cannot take sound objects and arrange them in
	 * a hierarchy to control their properties.
	 *
	 * When you use this class, consider the following security model: 
	 *
	 * 
	 *  * Loading and playing a sound is not allowed if the calling file is in
	 * a network sandbox and the sound file to be loaded is local.
	 *  * By default, loading and playing a sound is not allowed if the calling
	 * file is local and tries to load and play a remote sound. A user must grant
	 * explicit permission to allow this type of access.
	 *  * Certain operations dealing with sound are restricted. The data in a
	 * loaded sound cannot be accessed by a file in a different domain unless you
	 * implement a cross-domain policy file. Sound-related APIs that fall under
	 * this restriction are `Sound.id3`,
	 * `SoundMixer.computeSpectrum()`,
	 * `SoundMixer.bufferTime`, and the `SoundTransform`
	 * class.
	 * 
	 *
	 * However, in Adobe AIR, content in the `application` security
	 * sandbox(content installed with the AIR application) are not restricted by
	 * these security limitations.
	 *
	 * For more information related to security, see the Flash Player Developer
	 * Center Topic: [Security](http://www.adobe.com/go/devnet_security_en).
	 * 
	 * @:event complete   Dispatched when data has loaded successfully.
	 * @:event id3        Dispatched by a Sound object when ID3 data is available
	 *                   for an MP3 sound.
	 * @:event ioError    Dispatched when an input/output error occurs that causes
	 *                   a load operation to fail.
	 * @:event open       Dispatched when a load operation starts.
	 * @:event progress   Dispatched when data is received as a load operation
	 *                   progresses.
	 * @:event sampleData Dispatched when the runtime requests new audio data.
	 */
	export class Sound extends EventDispatcher {
		
		
		/**
		 * Returns the currently available number of bytes in this sound object. This
		 * property is usually useful only for externally loaded files.
		 */
		public readonly bytesLoaded:number;
		
		/**
		 * Returns the total number of bytes in this sound object.
		 */
		public readonly bytesTotal:number;
		
		/**
		 * Provides access to the metadata that is part of an MP3 file.
		 *
		 * MP3 sound files can contain ID3 tags, which provide metadata about the
		 * file. If an MP3 sound that you load using the `Sound.load()`
		 * method contains ID3 tags, you can query these properties. Only ID3 tags
		 * that use the UTF-8 character set are supported.
		 *
		 * Flash Player 9 and later and AIR support ID3 2.0 tags, specifically 2.3
		 * and 2.4. The following tables list the standard ID3 2.0 tags and the type
		 * of content the tags represent. The `Sound.id3` property
		 * provides access to these tags through the format
		 * `my_sound.id3.COMM`, `my_sound.id3.TIME`, and so on.
		 * The first table describes tags that can be accessed either through the ID3
		 * 2.0 property name or the ActionScript property name. The second table
		 * describes ID3 tags that are supported but do not have predefined
		 * properties in ActionScript. 
		 *
		 * When using this property, consider the Flash Player security model:
		 *
		 * 
		 *  * The `id3` property of a Sound object is always permitted
		 * for SWF files that are in the same security sandbox as the sound file. For
		 * files in other sandboxes, there are security checks.
		 *  * When you load the sound, using the `load()` method of the
		 * Sound class, you can specify a `context` parameter, which is a
		 * SoundLoaderContext object. If you set the `checkPolicyFile`
		 * property of the SoundLoaderContext object to `true`, Flash
		 * Player checks for a URL policy file on the server from which the sound is
		 * loaded. If a policy file exists and permits access from the domain of the
		 * loading SWF file, then the file is allowed to access the `id3`
		 * property of the Sound object; otherwise it is not.
		 * 
		 *
		 * However, in Adobe AIR, content in the `application` security
		 * sandbox(content installed with the AIR application) are not restricted by
		 * these security limitations.
		 *
		 * For more information related to security, see the Flash Player
		 * Developer Center Topic: [Security](http://www.adobe.com/go/devnet_security_en).
		 */
		public readonly id3:ID3Info;
		
		/**
		 * Returns the buffering state of external MP3 files. If the value is
		 * `true`, any playback is currently suspended while the object
		 * waits for more data.
		 */
		public readonly isBuffering:boolean;
		
		// #if flash
		// @:noCompletion @:dox(hide) @:require(flash10_1) public var isURLInaccessible (default, null):boolean;
		// #end
		
		/**
		 * The length of the current sound in milliseconds.
		 */
		public readonly length:number;
		
		/**
		 * The URL from which this sound was loaded. This property is applicable only
		 * to Sound objects that were loaded using the `Sound.load()`
		 * method. For Sound objects that are associated with a sound asset from a
		 * SWF file's library, the value of the `url` property is
		 * `null`.
		 *
		 * When you first call `Sound.load()`, the `url`
		 * property initially has a value of `null`, because the final URL
		 * is not yet known. The `url` property will have a non-null value
		 * as soon as an `open` event is dispatched from the Sound
		 * object.
		 *
		 * The `url` property contains the final, absolute URL from
		 * which a sound was loaded. The value of `url` is usually the
		 * same as the value passed to the `stream` parameter of
		 * `Sound.load()`. However, if you passed a relative URL to
		 * `Sound.load()` the value of the `url` property
		 * represents the absolute URL. Additionally, if the original URL request is
		 * redirected by an HTTP server, the value of the `url` property
		 * reflects the final URL from which the sound file was actually downloaded.
		 * This reporting of an absolute, final URL is equivalent to the behavior of
		 * `LoaderInfo.url`.
		 *
		 * In some cases, the value of the `url` property is truncated;
		 * see the `isURLInaccessible` property for details.
		 */
		public readonly url:string;
		
		
		/**
		 * Creates a new Sound object. If you pass a valid URLRequest object to the
		 * Sound constructor, the constructor automatically calls the
		 * `load()` for the Sound object. If you do not pass a
		 * valid URLRequest object to the Sound constructor, you must call the
		 * `load()` for the Sound object yourself, or the stream
		 * will not load.
		 *
		 * Once `load()` is called on a Sound object, you can't later
		 * load a different sound file into that Sound object. To load a different
		 * sound file, create a new Sound object.
		 * In Flash Player 10 and later and AIR 1.5 and later, instead of using
		 * `load()`, you can use the `sampleData` event handler
		 * to load sound dynamically into the Sound object.
		 * 
		 * @param stream  The URL that points to an external MP3 file.
		 * @param context An optional SoundLoader context object, which can define
		 *                the buffer time(the minimum number of milliseconds of MP3
		 *                data to hold in the Sound object's buffer) and can specify
		 *                whether the application should check for a cross-domain
		 *                policy file prior to loading the sound.
		 */
		public constructor (stream?:URLRequest, context?:SoundLoaderContext);
		
		
		/**
		 * Closes the stream, causing any download of data to cease. No data may be
		 * read from the stream after the `close()` method is called.
		 * 
		 * @throws IOError The stream could not be closed, or the stream was not
		 *                 open.
		 */
		public close ():void;
		
		
		// #if flash
		// @:noCompletion @:dox(hide) @:require(flash10) public extract (target:ByteArray, length:number, startPosition:number = -1):number;
		// #end
		
		
		public static fromAudioBuffer (buffer:AudioBuffer):Sound;
		
		
		public static fromFile (path:string):Sound;
		
		
		/**
		 * Initiates loading of an external MP3 file from the specified URL. If you
		 * provide a valid URLRequest object to the Sound constructor, the
		 * constructor calls `Sound.load()` for you. You only need to call
		 * `Sound.load()` yourself if you don't pass a valid URLRequest
		 * object to the Sound constructor or you pass a `null` value.
		 *
		 * Once `load()` is called on a Sound object, you can't later
		 * load a different sound file into that Sound object. To load a different
		 * sound file, create a new Sound object.
		 *
		 * When using this method, consider the following security model:
		 *
		 * 
		 *  * Calling `Sound.load()` is not allowed if the calling file
		 * is in the local-with-file-system sandbox and the sound is in a network
		 * sandbox.
		 *  * Access from the local-trusted or local-with-networking sandbox
		 * requires permission from a website through a URL policy file.
		 *  * You cannot connect to commonly reserved ports. For a complete list
		 * of blocked ports, see "Restricting Networking APIs" in the _ActionScript
		 * 3.0 Developer's Guide_.
		 *  * You can prevent a SWF file from using this method by setting the
		 * `allowNetworking` parameter of the `object` and
		 * `embed` tags in the HTML page that contains the SWF
		 * content.
		 * 
		 *
		 *  In Flash Player 10 and later, if you use a multipart Content-Type(for
		 * example "multipart/form-data") that contains an upload(indicated by a
		 * "filename" parameter in a "content-disposition" header within the POST
		 * body), the POST operation is subject to the security rules applied to
		 * uploads:
		 *
		 * 
		 *  * The POST operation must be performed in response to a user-initiated
		 * action, such as a mouse click or key press.
		 *  * If the POST operation is cross-domain(the POST target is not on the
		 * same server as the SWF file that is sending the POST request), the target
		 * server must provide a URL policy file that permits cross-domain
		 * access.
		 * 
		 *
		 * Also, for any multipart Content-Type, the syntax must be valid
		 * (according to the RFC2046 standards). If the syntax appears to be invalid,
		 * the POST operation is subject to the security rules applied to
		 * uploads.
		 *
		 * In Adobe AIR, content in the `application` security sandbox
		 * (content installed with the AIR application) are not restricted by these
		 * security limitations.
		 *
		 * For more information related to security, see the Flash Player
		 * Developer Center Topic: [Security](http://www.adobe.com/go/devnet_security_en).
		 * 
		 * @param stream  A URL that points to an external MP3 file.
		 * @param context An optional SoundLoader context object, which can define
		 *                the buffer time(the minimum number of milliseconds of MP3
		 *                data to hold in the Sound object's buffer) and can specify
		 *                whether the application should check for a cross-domain
		 *                policy file prior to loading the sound.
		 * @throws IOError       A network error caused the load to fail.
		 * @throws IOError       The `digest` property of the
		 *                       `stream` object is not `null`.
		 *                       You should only set the `digest` property
		 *                       of a URLRequest object when calling the
		 *                       `URLLoader.load()` method when loading a
		 *                       SWZ file(an Adobe platform component).
		 * @throws SecurityError Local untrusted files may not communicate with the
		 *                       Internet. You can work around this by reclassifying
		 *                       this file as local-with-networking or trusted.
		 * @throws SecurityError You cannot connect to commonly reserved ports. For a
		 *                       complete list of blocked ports, see "Restricting
		 *                       Networking APIs" in the _ActionScript 3.0
		 *                       Developer's Guide_.
		 */
		public load (stream:URLRequest, context?:SoundLoaderContext):void;
		
		
		public loadCompressedDataFromByteArray (bytes:ByteArray, bytesLength:number, forcePlayAsMusic?:boolean):void;
		
		
		public static loadFromFile (path:string):Future<Sound>;
		public static loadFromFiles (paths:Array<String>):Future<Sound>;
		
		
		public loadPCMFromByteArray (bytes:ByteArray, samples:number, format?:string, stereo?:boolean, sampleRate?:number):void;
		
		
		/**
		 * Generates a new SoundChannel object to play back the sound. This method
		 * returns a SoundChannel object, which you access to stop the sound and to
		 * monitor volume.(To control the volume, panning, and balance, access the
		 * SoundTransform object assigned to the sound channel.)
		 * 
		 * @param startTime    The initial position in milliseconds at which playback
		 *                     should start.
		 * @param loops        Defines the number of times a sound loops back to the
		 *                     `startTime` value before the sound channel
		 *                     stops playback.
		 * @param sndTransform The initial SoundTransform object assigned to the
		 *                     sound channel.
		 * @return A SoundChannel object, which you use to control the sound. This
		 *         method returns `null` if you have no sound card or if
		 *         you run out of available sound channels. The maximum number of
		 *         sound channels available at once is 32.
		 */
		public play (startTime?:number, loops?:number, sndTransform?:SoundTransform):SoundChannel;
		
		
	}
	
	
}


export default openfl.media.Sound;