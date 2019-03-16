package openfl.media;

#if !flash
/**
	The SoundLoaderContext class provides security checks for files that load
	sound. SoundLoaderContext objects are passed as an argument to the
	constructor and the `load()` method of the Sound class.

	When you use this class, consider the following security model:


	* Loading and playing a sound is not allowed if the calling file is in
	a network sandbox and the sound file to be loaded is local.
	* By default, loading and playing a sound is not allowed if the calling
	is local and tries to load and play a remote sound. A user must grant
	explicit permission to allow this.
	* Certain operations dealing with sound are restricted. The data in a
	loaded sound cannot be accessed by a file in a different domain unless you
	implement a URL policy file. Sound-related APIs that fall under this
	restriction are the `Sound.id3` property and the
	`SoundMixer.computeSpectrum()`,
	`SoundMixer.bufferTime`, and `SoundTransform()`
	methods.


	However, in Adobe AIR, content in the `application` security
	sandbox(content installed with the AIR application) are not restricted by
	these security limitations.

	For more information related to security, see the Flash Player Developer
	Center Topic: [Security](http://www.adobe.com/go/devnet_security_en).
**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class SoundLoaderContext
{
	/**
		The number of milliseconds to preload a streaming sound into a buffer
		before the sound starts to stream.

		Note that you cannot override the value of
		`SoundLoaderContext.bufferTime` by setting the global
		`SoundMixer.bufferTime` property. The
		`SoundMixer.bufferTime` property affects the buffer time for
		embedded streaming sounds in a SWF file and is independent of dynamically
		created Sound objects(that is, Sound objects created in
		ActionScript).
	**/
	public var bufferTime:Float;

	/**
		Specifies whether the application should try to download a URL policy
		file from the loaded sound's server before beginning to load the
		sound. This property applies to sound that is loaded from outside the
		calling file's own domain using the `Sound.load()` method.
		Set this property to `true` when you load a sound from outside the
		calling file's own domain and code in the calling file needs low-level
		access to the sound's data. Examples of low-level access to a sound's
		data include referencing the `Sound.id3` property to get an ID3Info
		object or calling the `SoundMixer.computeSpectrum()` method to get
		sound samples from the loaded sound. If you try to access sound data
		without setting the `checkPolicyFile` property to `true` at loading
		time, you may get a SecurityError exception because the required
		policy file has not been downloaded.

		If you don't need low-level access to the sound data that you are
		loading, avoid setting `checkPolicyFile` to `true`. Checking for a
		policy file consumes network bandwidth and might delay the start of
		your download, so it should only be done when necessary.

		When you call `Sound.load()` with `SoundLoaderContext.checkPolicyFile`
		set to `true`, Flash Player or AIR must either successfully download a
		relevant URL policy file or determine that no such policy file exists
		before it begins downloading the specified sound. Flash Player or AIR
		performs the following actions, in this order, to verify the existence
		of a policy file:

		* Flash Player or AIR considers policy files that have already been
		downloaded.
		* Flash Player or AIR tries to download any pending policy files
		specified in calls to `Security.loadPolicyFile()`.
		* Flash Player or AIR tries to download a policy file from the default
		location that corresponds to the sound's URL, which is
		`/crossdomain.xml` on the same server as `URLRequest.url`. (The
		sound's URL is specified in the `url` property of the URLRequest
		object passed to `Sound.load()` or the Sound() constructor function.)

		In all cases, Flash Player or AIR requires that an appropriate policy
		file exist on the sound's server, that it provide access to the sound
		file at `URLRequest.url` by virtue of the policy file's location, and
		that it allow the domain of the calling file to access the sound,
		through one or more `<allow-access-from>` tags.

		If you set `checkPolicyFile` to `true`, Flash Player or AIR waits
		until the policy file is verified before loading the sound. You should
		wait to perform any low-level operations on the sound data, such as
		calling `Sound.id3` or `SoundMixer.computeSpectrum()`, until
		`progress` and `complete` events are dispatched from the Sound object.


		If you set `checkPolicyFile` to `true` but no appropriate policy file
		is found, you will not receive an error until you perform an operation
		that requires a policy file, and then Flash Player or AIR throws a
		`SecurityError` exception. After you receive a `complete` event, you
		can test whether a relevant policy file was found by getting the value
		of `Sound.id3` within a `try` block and seeing if a `SecurityError` is
		thrown.

		Be careful with `checkPolicyFile` if you are downloading sound from a
		URL that uses server-side HTTP redirects. Flash Player or AIR tries to
		retrieve policy files that correspond to the `url` property of the
		URLRequest object passed to `Sound.load()`. If the final sound file
		comes from a different URL because of HTTP redirects, then the
		initially downloaded policy files might not be applicable to the
		sound's final URL, which is the URL that matters in security
		decisions.

		If you find yourself in this situation, here is one possible solution.
		After you receive a `progress` or `complete` event, you can examine
		the value of the `Sound.url` property, which contains the sound's
		final URL. Then call the `Security.loadPolicyFile()` method with a
		policy file URL that you calculate based on the sound's final URL.
		Finally, poll the value of `Sound.id3` until no exception is thrown.

		This does not apply to content in the AIR application sandbox. Content
		in the application sandbox always has programatic access to sound
		content, regardless of its origin.

		For more information related to security, see the Flash Player
		Developer Center Topic: <a
		href="http://www.adobe.com/go/devnet_security_en"
		scope="external">Security</a>.
	**/
	public var checkPolicyFile:Bool;

	/**
		Creates a new sound loader context object.

		@param bufferTime      The number of seconds to preload a streaming sound
							   into a buffer before the sound starts to stream.
		@param checkPolicyFile Specifies whether the existence of a URL policy
							   file should be checked upon loading the object
							  (`true`) or not.
	**/
	public function new(bufferTime:Float = 1000, checkPolicyFile:Bool = false)
	{
		this.bufferTime = bufferTime;
		this.checkPolicyFile = checkPolicyFile;
	}
}
#else
typedef SoundLoaderContext = flash.media.SoundLoaderContext;
#end
