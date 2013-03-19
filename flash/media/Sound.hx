package flash.media;
#if (flash || display)


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
extern class Sound extends flash.events.EventDispatcher {

	/**
	 * Returns the currently available number of bytes in this sound object. This
	 * property is usually useful only for externally loaded files.
	 */
	var bytesLoaded(default,null) : Int;

	/**
	 * Returns the total number of bytes in this sound object.
	 */
	var bytesTotal(default,null) : Int;

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
	var id3(default,null) : ID3Info;

	/**
	 * Returns the buffering state of external MP3 files. If the value is
	 * <code>true</code>, any playback is currently suspended while the object
	 * waits for more data.
	 */
	var isBuffering(default,null) : Bool;

	/**
	 * Indicates if the <code>Sound.url</code> property has been truncated. When
	 * the <code>isURLInaccessible</code> value is <code>true</code> the
	 * <code>Sound.url</code> value is only the domain of the final URL from
	 * which the sound loaded. For example, the property is truncated if the
	 * sound is loaded from <code>http://www.adobe.com/assets/hello.mp3</code>,
	 * and the <code>Sound.url</code> property has the value
	 * <code>http://www.adobe.com</code>. The <code>isURLInaccessible</code>
	 * value is <code>true</code> only when all of the following are also true:
	 * <ul>
	 *   <li>An HTTP redirect occurred while loading the sound file.</li>
	 *   <li>The SWF file calling <code>Sound.load()</code> is from a different
	 * domain than the sound file's final URL.</li>
	 *   <li>The SWF file calling <code>Sound.load()</code> does not have
	 * permission to access the sound file. Permission is granted to access the
	 * sound file the same way permission is granted for the
	 * <code>Sound.id3</code> property: establish a policy file and use the
	 * <code>SoundLoaderContext.checkPolicyFile</code> property.</li>
	 * </ul>
	 *
	 * <p><b>Note:</b> The <code>isURLInaccessible</code> property was added for
	 * Flash Player 10.1 and AIR 2.0. However, this property is made available to
	 * SWF files of all versions when the Flash runtime supports it. So, using
	 * some authoring tools in "strict mode" causes a compilation error. To work
	 * around the error use the indirect syntax
	 * <code>mySound["isURLInaccessible"]</code>, or disable strict mode. If you
	 * are using Flash Professional CS5 or Flex SDK 4.1, you can use and compile
	 * this API for runtimes released before Flash Player 10.1 and AIR 2.</p>
	 *
	 * <p>For application content in AIR, the value of this property is always
	 * <code>false</code>.</p>
	 */
	@:require(flash10_1) var isURLInaccessible(default,null) : Bool;

	/**
	 * The length of the current sound in milliseconds.
	 */
	var length(default,null) : Float;

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
	var url(default,null) : String;

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
	function new(?stream : flash.net.URLRequest, ?context : SoundLoaderContext) : Void;

	/**
	 * Closes the stream, causing any download of data to cease. No data may be
	 * read from the stream after the <code>close()</code> method is called.
	 * 
	 * @throws IOError The stream could not be closed, or the stream was not
	 *                 open.
	 */
	function close() : Void;

	/**
	 * Extracts raw sound data from a Sound object.
	 *
	 * <p>This method is designed to be used when you are working with
	 * dynamically generated audio, using a function you assign to the
	 * <code>sampleData</code> event for a different Sound object. That is, you
	 * can use this method to extract sound data from a Sound object. Then you
	 * can write the data to the byte array that another Sound object is using to
	 * stream dynamic audio.</p>
	 *
	 * <p>The audio data is placed in the target byte array starting from the
	 * current position of the byte array. The audio data is always exposed as
	 * 44100 Hz Stereo. The sample type is a 32-bit floating-point value, which
	 * can be converted to a Number using <code>ByteArray.readFloat()</code>.
	 * </p>
	 * 
	 * @param target A ByteArray object in which the extracted sound samples are
	 *               placed.
	 * @param length The number of sound samples to extract. A sample contains
	 *               both the left and right channels  -  that is, two 32-bit
	 *               floating-point values.
	 * @return The number of samples written to the ByteArray specified in the
	 *         <code>target</code> parameter.
	 */
	@:require(flash10) function extract(target : flash.utils.ByteArray, length : Float, startPosition : Float = -1) : Float;

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
	function load(stream : flash.net.URLRequest, ?context : SoundLoaderContext) : Void;
	@:require(flash11) function loadCompressedDataFromByteArray(bytes : flash.utils.ByteArray, bytesLength : Int) : Void;
	@:require(flash11) function loadPCMFromByteArray(bytes : flash.utils.ByteArray, samples : Int, ?format : String, stereo : Bool = true, sampleRate : Float = 44100) : Void;

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
	function play(startTime : Float = 0, loops : Int = 0, ?sndTransform : SoundTransform) : SoundChannel;
}


#end
