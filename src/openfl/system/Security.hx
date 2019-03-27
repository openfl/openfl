package openfl.system;

#if !flash
/**
	The Security class lets you specify how content in different domains can
	communicate with each other.
**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class Security
{
	#if false
	/**
		The file is running in an AIR application, and it was installed with
		the package (the AIR file) for that application. This content is
		included in the AIR application resource directory (where the
		application content is installed).
	**/
	// @:noCompletion @:dox(hide) @:require(flash10_1) public static var APPLICATION:String;
	#end

	/**
		The file is a local file and has been trusted by the user, using
		either the Flash Player Settings Manager or a FlashPlayerTrust
		configuration file. The file can read from local data sources and
		communicate with the Internet.
	**/
	public static inline var LOCAL_TRUSTED:String = "localTrusted";

	/**
		The file is a local file, has not been trusted by the user, and it is
		not a SWF file that was published with a networking designation. In
		Adobe AIR, the local file is _not_ in the application resource
		directory; such files are put in the application security sandbox. The
		file may read from local data sources but may not communicate with the
		Internet.
	**/
	public static inline var LOCAL_WITH_FILE:String = "localWithFile";

	/**
		The file is a local file, has not been trusted by the user, and it is
		a SWF file that was published with a networking designation. The file
		can communicate with the Internet but cannot read from local data
		sources.
	**/
	public static inline var LOCAL_WITH_NETWORK:String = "localWithNetwork";

	/**
		The file is from an Internet URL and operates under domain-based
		sandbox rules.
	**/
	public static inline var REMOTE:String = "remote";

	/**
		Undocumented property
	**/
	@:noCompletion @:dox(hide) public static var disableAVM1Loading:Bool;

	/**
		Determines how Flash Player or AIR chooses the domain to use for
		certain content settings, including settings for camera and microphone
		permissions, storage quotas, and storage of persistent shared objects.
		To have the SWF file use the same settings that were used in Flash
		Player 6, set `exactSettings` to `false`.
		In Flash Player 6, the domain used for these player settings was based
		on the trailing portion of the domain of the SWF file. If the domain
		of a SWF file includes more than two segments, such as
		www.example.com, the first segment of the domain ("www") is removed,
		and the remaining portion of the domain is used: example.com. So, in
		Flash Player 6, www.example.com and store.example.com both use
		example.com as the domain for these settings. Similarly,
		www.example.co.uk and store.example.co.uk both use example.co.uk as
		the domain for these settings. In Flash Player 7 and later, player
		settings are chosen by default according to a SWF file's exact domain;
		for example, a SWF file from www.example.com would use the player
		settings for www.example.com, and a SWF file from store.example.com
		would use the separate player settings for store.example.com.

		When `Security.exactSettings` is set to `true`, Flash Player or AIR
		uses exact domains for player settings. The default value for
		`exactSettings` is `true`. If you change `exactSettings` from its
		default value, do so before any events occur that require Flash Player
		or AIR to choose player settings נfor example, using a camera or
		microphone, or retrieving a persistent shared object.

		If you previously published a version 6 SWF file and created
		persistent shared objects from it, and you now need to retrieve those
		persistent shared objects from that SWF file after porting it to
		version 7 or later, or from a different SWF file of version 7 or
		later, set `Security.exactSettings` to `false` before calling
		`SharedObject.getLocal()`.

		@throws SecurityError A Flash Player or AIR application already used
							  the value of `exactSettings` at least once in a
							  decision about player settings.
	**/
	public static var exactSettings:Bool;

	#if false
	/**
		Get the page domain containing the swf. For security reasons, the
		method does not return the full URL, only the page domain, such as
		http://www.example.com.
	**/
	// @:noCompletion @:dox(hide) @:require(flash11) public static var pageDomain (default, null):String;
	#end

	/**
		Indicates the type of security sandbox in which the calling file is
		operating.
		`Security.sandboxType` has one of the following values:

		* `remote` (`Security.REMOTE`)הhis file is from an Internet URL and
		operates under domain-based sandbox rules.
		* `localWithFile` (`Security.LOCAL_WITH_FILE`)הhis file is a local
		file, has not been trusted by the user, and it is not a SWF file that
		was published with a networking designation. The file may read from
		local data sources but may not communicate with the Internet.
		* `localWithNetwork` (`Security.LOCAL_WITH_NETWORK`)הhis SWF file
		is a local file, has not been trusted by the user, and was published
		with a networking designation. The SWF file can communicate with the
		Internet but cannot read from local data sources.
		* `localTrusted` (`Security.LOCAL_TRUSTED`)הhis file is a local
		file and has been trusted by the user, using either the Flash Player
		Settings Manager or a FlashPlayerTrust configuration file. The file
		can read from local data sources and communicate with the Internet.
		* `application` (`Security.APPLICATION`)הhis file is running in an
		AIR application, and it was installed with the package (AIR file) for
		that application. By default, files in the AIR application sandbox can
		cross-script any file from any domain (although files outside the AIR
		application sandbox may not be permitted to cross-script the AIR
		file). By default, files in the AIR application sandbox can load
		content and data from any domain.

		For more information related to security, see the Flash Player
		Developer Center Topic: <a
		href="http://www.adobe.com/go/devnet_security_en"
		scope="external">Security</a>.
	**/
	public static var sandboxType(default, null):String;

	/**
		Lets SWF files in the identified domains access objects and variables
		in the SWF file that contains the `allowDomain()` call.
		_Note:_ Calling this method from code in the AIR application sandbox
		throws a SecurityError exception. Content outside of the application
		security domain cannot directly cross-script content in the
		application sandbox. However, content outside of the application
		sandbox can communicate with content in the application security
		sandbox using a sandbox bridge.

		If two SWF files are served from the same domain נfor example,
		http://mysite.com/swfA.swf and http://mysite.com/swfB.swf נthen
		swfA.swf can examine and modify variables, objects, properties,
		methods, and so on in swfB.swf, and swfB.swf can do the same for
		swfA.swf. This is called _cross-movie scripting_ or _cross-scripting_.

		If two SWF files are served from different domains נfor example,
		http://siteA.com/swfA.swf and http://siteB.com/siteB.swf נthen, by
		default, Flash Player does not allow swfA.swf to script swfB.swf, nor
		swfB.swf to script swfA.swf. A SWF file gives permission to SWF files
		from other domains by calling `Security.allowDomain()`. This is called
		_cross-domain scripting_. By calling
		`Security.allowDomain("siteA.com")`, siteB.swf gives siteA.swf
		permission to script it.

		In any cross-domain situation, it is important to be clear about the
		two parties involved. For the purposes of this discussion, the side
		performing the cross-scripting is called the _accessing party_
		(usually the accessing SWF), and the other side is called _the party
		being accessed_ (usually the SWF file being accessed). When siteA.swf
		scripts siteB.swf, siteA.swf is the accessing party, and siteB.swf is
		the party being accessed.

		![Cross-domain diagram](/images/crossScript_load.jpg)

		Cross-domain permissions that are established with `allowDomain()` are
		asymmetrical. In the previous example, siteA.swf can script siteB.swf,
		but siteB.swf cannot script siteA.swf, because siteA.swf has not
		called `allowDomain()` to give SWF files at siteB.com permission to
		script it. You can set up symmetrical permissions by having both SWF
		files call `allowDomain()`.

		In addition to protecting SWF files from cross-domain scripting
		originated by other SWF files, Flash Player protects SWF files from
		cross-domain scripting originated by HTML files. HTML-to-SWF scripting
		can occur with older browser functions such as `SetVariable` or
		callbacks established through `ExternalInterface.addCallback()`. When
		HTML-to-SWF scripting crosses domains, the SWF file being accessed
		must call `allowDomain()`, just as when the accessing party is a SWF
		file, or the operation will fail.

		Specifying an IP address as a parameter to `allowDomain()` does not
		permit access by all parties that originate at the specified IP
		address. Instead, it permits access only by a party that contains the
		specified IP address it its URL, rather than a domain name that maps
		to that IP address.

		**Version-specific differences**

		Flash Player's cross-domain security rules have evolved from version
		to version. The following table summarizes the differences.

		| Latest SWF version involved in cross-scripting | `allowDomain()` needed? | `allowInsecureDomain()` needed? | Which SWF file must call `allowDomain()` or `allowInsecureDomain()`? | What can be specified in `allowDomain()` or `allowInsecureDomain()`? |
		| --- | --- | --- | --- | --- |
		| 5 or earlier | No | No | N/A | N/A |
		| 6 | Yes, if superdomains don't match | No | The SWF file being accessed, or any SWF file with the same superdomain as the SWF file being accessed | <ul><li>Text-based domain (mysite.com)</li><li>IP address (192.168.1.1)</li></ul> |
		| 7 | Yes, if domains don't match exactly | Yes, if performing HTTP-to-HTTPS access (even if domains match exactly) | The SWF file being accessed, or any SWF file with exactly the same domain as the SWF file being accessed | <ul><li>Text-based domain (mysite.com)</li><li>IP address (192.168.1.1)</li></ul> |
		| 8 or later | Yes, if domains don't match exactly | Yes, if performing HTTP-to-HTTPS access (even if domains match exactly) | SWF file being accessed | <ul><li>Text-based domain (mysite.com)</li><li>IP address (192.168.1.1)</li><li>Wildcard (*)</li></ul> |

		The versions that control the behavior of Flash Player are _SWF
		versions_ (the published version of a SWF file), not the version of
		Flash Player itself. For example, when Flash Player 8 is playing a SWF
		file published for version 7, it applies behavior that is consistent
		with version 7. This practice ensures that player upgrades do not
		change the behavior of `Security.allowDomain()` in deployed SWF files.

		The version column in the previous table shows the latest SWF version
		involved in a cross-scripting operation. Flash Player determines its
		behavior according to either the accessing SWF file's version or the
		version of the SWF file that is being accessed, whichever is later.

		The following paragraphs provide more detail about Flash Player
		security changes involving `Security.allowDomain()`.

		**Version 5**. There are no cross-domain scripting restrictions.

		**Version 6**. Cross-domain scripting security is introduced. By
		default, Flash Player forbids cross-domain scripting;
		`Security.allowDomain()` can permit it. To determine whether two files
		are in the same domain, Flash Player uses each file's superdomain,
		which is the exact host name from the file's URL, minus the first
		segment, down to a minimum of two segments. For example, the
		superdomain of www.mysite.com is mysite.com. SWF files from
		www.mysite.com and store.mysite.com to script each other without a
		call to `Security.allowDomain()`.

		**Version 7**. Superdomain matching is changed to exact domain
		matching. Two files are permitted to script each other only if the
		host names in their URLs are identical; otherwise, a call to
		`Security.allowDomain()` is required. By default, files loaded from
		non-HTTPS URLs are no longer permitted to script files loaded from
		HTTPS URLs, even if the files are loaded from exactly the same domain.
		This restriction helps protect HTTPS files, because a non-HTTPS file
		is vulnerable to modification during download, and a maliciously
		modified non-HTTPS file could corrupt an HTTPS file, which is
		otherwise immune to such tampering. `Security.allowInsecureDomain()`
		is introduced to allow HTTPS SWF files that are being accessed to
		voluntarily disable this restriction, but the use of
		`Security.allowInsecureDomain()` is discouraged.

		**Version 8**. There are two major areas of change:

		* Calling `Security.allowDomain()` now permits cross-scripting
		operations only if the SWF file being accessed is the SWF file that
		called `Security.allowDomain()`. In other words, a SWF file that calls
		`Security.allowDomain()` now permits access only to itself. In
		previous versions, calling `Security.allowDomain()` permitted
		cross-scripting operations where the SWF file being accessed could be
		any SWF file in the same domain as the SWF file that called
		`Security.allowDomain()`. Calling `Security.allowDomain()` previously
		opened up the entire domain of the calling SWF file.
		* Support has been added for wildcard values with
		`Security.allowDomain("*")` and `Security.allowInsecureDomain("*")`.
		The wildcard (*) value permits cross-scripting operations where the
		accessing file is any file at all, loaded from anywhere. Think of the
		wildcard as a global permission. Wildcard permissions are required to
		enable certain kinds of operations under the local file security
		rules. Specifically, for a local SWF file with network-access
		permissions to script a SWF file on the Internet, the Internet SWF
		file being accessed must call `Security.allowDomain("*")`, reflecting
		that the origin of a local SWF file is unknown. (If the Internet SWF
		file is loaded from an HTTPS URL, the Internet SWF file must instead
		call `Security.allowInsecureDomain("*")`.)

		Occasionally, you may encounter the following situation: You load a
		child SWF file from a different domain and want to allow the child SWF
		file to script the parent SWF file, but you don't know the final
		domain of the child SWF file. This can happen, for example, when you
		use load-balancing redirects or third-party servers.

		In this situation, you can use the `url` property of the URLRequest
		object that you pass to `Loader.load()`. For example, if you load a
		child SWF file into a parent SWF, you can access the
		`contentLoaderInfo` property of the Loader object for the parent SWF:

		```as3
		Security.allowDomain(loader.contentLoaderInfo.url)
		```

		Make sure that you wait until the child SWF file begins loading to get
		the correct value of the `url` property. To determine when the child
		SWF has begun loading, use the `progress` event.

		The opposite situation can also occur; that is, you might create a
		child SWF file that wants to allow its parent to script it, but
		doesn't know what the domain of its parent will be. In this situation,
		you can access the `loaderInfo` property of the display object that is
		the SWF's root object. In the child SWF, call ` Security.allowDomain(
		this.root.loaderInfo.loaderURL)`. You don't have to wait for the
		parent SWF file to load; the parent will already be loaded by the time
		the child loads.

		If you are publishing for Flash Player 8 or later, you can also handle
		these situations by calling `Security.allowDomain("*")`. However,
		this can sometimes be a dangerous shortcut, because it allows the
		calling SWF file to be accessed by any other SWF file from any domain.
		It is usually safer to use the `_url` property.

		For more information related to security, see the Flash Player
		Developer Center Topic: <a
		href="http://www.adobe.com/go/devnet_security_en"
		scope="external">Security</a>.

		@throws SecurityError Calling this method from code in the AIR
							  application security sandbox throws a
							  SecurityError exception. Content outside of the
							  application security sandbox cannot cross-script
							  content in the application security sandbox.
	**/
	public static function allowDomain(p1:Dynamic = null, p2:Dynamic = null, p3:Dynamic = null, p4:Dynamic = null, p5:Dynamic = null):Void {}

	/**
		Lets SWF files and HTML files in the identified domains access objects
		and variables in the calling SWF file, which is hosted by means of the
		HTTPS protocol.
		Flash Player provides `allowInsecureDomain()` to maximize flexibility,
		but calling this method is not recommended. Serving a file over HTTPS
		provides several protections for you and your users, and calling
		`allowInsecureDomain` weakens one of those protections.

		_Note:_ Calling this method from code in the AIR application sandbox
		throws a SecurityError exception. Content outside of the application
		security domain cannot directly cross-script content in the
		application sandbox. However, content outside of the application
		sandbox can communicate with content in the application security
		sandbox using a sandbox bridge.

		This method works in the same way as `Security.allowDomain()`, but it
		also permits operations in which the accessing party is loaded with a
		non-HTTPS protocol, and the party being accessed is loaded with HTTPS.
		In Flash Player 7 and later, non-HTTPS files are not allowed to script
		HTTPS files. The `allowInsecureDomain()` method lifts this restriction
		when the HTTPS SWF file being accessed uses it.

		Use `allowInsecureDomain()` only to enable scripting from non-HTTPS
		files to HTTPS files. Use it to enable scripting when the accessing
		non-HTTPS file and the HTTPS file being accessed are served from the
		same domain, for example, if a SWF file at http://mysite.com wants to
		script a SWF file at https://mysite.com. Do not use this method to
		enable scripting between non-HTTPS files, between HTTPS files, or from
		HTTPS files to non-HTTPS files. For those situations, use
		`allowDomain()` instead.
		The following scenario illustrates how `allowInsecureDomain()` can
		compromise security, if it is not used with careful consideration.
		Note that the following information is only one possible scenario,
		designed to help you understand `allowInsecureDomain()` through a
		real-world example of cross-scripting. It does not cover all issues
		with security architecture and should be used for background
		information only. The Flash Player Developer Center contains extensive
		information on Flash Player and security. For more information, see
		the Flash Player Developer Center Topic <a
		href="http://www.adobe.com/go/devnet_security_en"
		scope="external">Security</a>.

		Suppose you are building an e-commerce site that consists of two
		components: a catalog, which does not need to be secure, because it
		contains only public information; and a shopping cart/checkout
		component, which must be secure to protect users' financial and
		personal information. Suppose you are considering serving the catalog
		from http://mysite.com/catalog.swf and the cart from
		https://mysite.com/cart.swf. One requirement for your site is that a
		third party should not be able to steal your users' credit card
		numbers by taking advantage of a weakness in your security
		architecture.

		Suppose that a middle-party attacker intervenes between your server
		and your users, attempting to steal the credit card numbers that your
		users enter into your shopping cart application. A middle party might,
		for example, be an unscrupulous ISP used by some of your users, or a
		malicious administrator at a user's workplace נanyone who has the
		ability to view or alter network packets transmitted over the public
		Internet between your users and your servers. This situation is not
		uncommon.

		If cart.swf uses HTTPS to transmit credit card information to your
		servers, then the middle-party attacker can't directly steal this
		information from network packets, because the HTTPS transmission is
		encrypted. However, the attacker can use a different technique:
		altering the contents of one of your SWF files as it is delivered to
		the user, replacing your SWF file with an altered version that
		transmits the user's information to a different server, owned by the
		attacker.

		The HTTPS protocol, among other things, prevents this "modification"
		attack from working, because, in addition to being encrypted, HTTPS
		transmissions are tamper-resistant. If a middle-party attacker alters
		a packet, the receiving side detects the alteration and discards the
		packet. So the attacker in this situation can't alter cart.swf,
		because it is delivered over HTTPS.

		However, suppose that you want to allow buttons in catalog.swf, served
		over HTTP, to add items to the shopping cart in cart.swf, served over
		HTTPS. To accomplish this, cart.swf calls `allowInsecureDomain()`,
		which allows catalog.swf to script cart.swf. This action has an
		unintended consequence: Now the attacker can alter catalog.swf as it
		is initially being downloaded by the user, because catalog.swf is
		delivered with HTTP and is not tamper-resistant. The attacker's
		altered catalog.swf can now script cart.swf, because cart.swf contains
		a call to `allowInsecureDomain()`. The altered catalog.swf file can
		use ActionScript to access the variables in cart.swf, thus reading the
		user's credit card information and other sensitive data. The altered
		catalog.swf can then send this data to an attacker's server.

		Obviously, this implementation is not desired, but you still want to
		allow cross-scripting between the two SWF files on your site. Here are
		two possible ways to redesign this hypothetical e-commerce site to
		avoid `allowInsecureDomain()`:

		* Serve all SWF files in the application over HTTPS. This is by far
		the simplest and most reliable solution. In the scenario described,
		you would serve both catalog.swf and cart.swf over HTTPS. You might
		experience slightly higher bandwidth consumption and server CPU load
		when switching a file such as catalog.swf from HTTP to HTTPS, and your
		users might experience slightly longer application load times. You
		need to experiment with real servers to determine the severity of
		these effects; usually they are no worse than 10-20% each, and
		sometimes they are not present at all. You can usually improve results
		by using HTTPS-accelerating hardware or software on your servers. A
		major benefit of serving all cooperating SWF files over HTTPS is that
		you can use an HTTPS URL as the main URL in the user's browser without
		generating any mixed-content warnings from the browser. Also, the
		browser's padlock icon becomes visible, providing your users with a
		common and trusted indicator of security.
		* Use HTTPS-to-HTTP scripting, rather than HTTP-to-HTTPS scripting. In
		the scenario described, you could store the contents of the user's
		shopping cart in catalog.swf, and have cart.swf manage only the
		checkout process. At checkout time, cart.swf could retrieve the cart
		contents from ActionScript variables in catalog.swf. The restriction
		on HTTP-to-HTTPS scripting is asymmetrical; although an HTTP-delivered
		catalog.swf file cannot safely be allowed to script an HTTPS-delivered
		cart.swf file, an HTTPS cart.swf file can script the HTTP catalog.swf
		file. This approach is more delicate than the all-HTTPS approach; you
		must be careful not to trust any SWF file delivered over HTTP, because
		of its vulnerability to tampering. For example, when cart.swf
		retrieves the ActionScript variable that describes the cart contents,
		the ActionScript code in cart.swf cannot trust that the value of this
		variable is in the format that you expect. You must verify that the
		cart contents do not contain invalid data that might lead cart.swf to
		take an undesired action. You must also accept the risk that a middle
		party, by altering catalog.swf, could supply valid but inaccurate data
		to cart.swf; for example, by placing items in the user's cart. The
		usual checkout process mitigates this risk somewhat by displaying the
		cart contents and total cost for final approval by the user, but the
		risk remains present.

		Web browsers have enforced separation between HTTPS and non-HTTPS
		files for years, and the scenario described illustrates one good
		reason for this restriction. Flash Player gives you the ability to
		work around this security restriction when you absolutely must, but be
		sure to consider the consequences carefully before doing so.

		For more information related to security, see the Flash Player
		Developer Center Topic: <a
		href="http://www.adobe.com/go/devnet_security_en"
		scope="external">Security</a>.

		@throws SecurityError Calling this method from code in the AIR
							  application security sandbox causes a
							  SecurityError exception to be thrown. Content
							  outside of the application security sandbox
							  cannot cross-script content in the application
							  security sandbox.
	**/
	public static function allowInsecureDomain(p1:Dynamic = null, p2:Dynamic = null, p3:Dynamic = null, p4:Dynamic = null, p5:Dynamic = null):Void {}

	// @:noCompletion @:dox(hide) @:require(flash10_1) public static function duplicateSandboxBridgeInputArguments (toplevel:Dynamic, args:Array<Dynamic>):Array<Dynamic>;
	// @:noCompletion @:dox(hide) @:require(flash10_1) public static function duplicateSandboxBridgeOutputArgument (toplevel:Dynamic, arg:Dynamic):Dynamic;

	/**
		Looks for a policy file at the location specified by the `url`
		parameter. Adobe AIR and Flash Player use policy files to determine
		whether to permit applications to load data from servers other than
		their own. Note that even though the method name is `
		loadPolicyFile()`, the file isn't actually loaded until a network
		request that requires a policy file is made.
		With `Security.loadPolicyFile()`, Flash Player or AIR can load policy
		files from arbitrary locations, as shown in the following example:

		```as3
		Security.loadPolicyFile("http://www.example.com/sub/dir/pf.xml");
		```

		This causes Flash Player or AIR to attempt to retrieve a policy file
		from the specified URL. Any permissions granted by the policy file at
		that location will apply to all content at the same level or lower in
		the virtual directory hierarchy of the server.

		For example, following the previous code, these lines do not throw an
		exception:

		```haxe
		import openfl.net.*;

		var request = new URLRequest("http://www.example.com/sub/dir/vars.txt");
		var loader = new URLLoader();
		loader.load(request);

		var loader2 = new URLLoader();
		var request2 = new URLRequest("http://www.example.com/sub/dir/deep/vars2.txt");
		loader2.load(request2);
		```

		However, the following code does throw a security exception:

		```haxe
		import openfl.net.*;

		var request3 = new URLRequest("http://www.example.com/elsewhere/vars3.txt");
		var loader3 = new URLLoader();
		loader3.load(request3);
		```

		You can use `loadPolicyFile()` to load any number of policy files.
		When considering a request that requires a policy file, Flash Player
		or AIR always waits for the completion of any policy file downloads
		before denying a request. As a final fallback, if no policy file
		specified with `loadPolicyFile()` authorizes a request, Flash Player
		or AIR consults the original default locations.

		When checking for a master policy file, Flash Player waits three
		seconds for a server response. If a response isn't received, Flash
		Player assumes that no master policy file exists. However, there is no
		default timeout value for calls to `loadPolicyFile()`; Flash Player
		assumes that the file being called exists, and waits as long as
		necessary to load it. Therefore, if you want to make sure that a
		master policy file is loaded, use `loadPolicyFile()` to call it
		explicitly.

		You cannot connect to commonly reserved ports. For a complete list of
		blocked ports, see "Restricting Networking APIs" in the _ActionScript
		3.0 Developer's Guide_.

		Using the `xmlsocket` protocol along with a specific port number lets
		you retrieve policy files directly from an XMLSocket server, as shown
		in the following example. Socket connections are not subject to the
		reserved port restriction described above.

		```haxe
		Security.loadPolicyFile("xmlsocket://foo.com:414");
		```

		This causes Flash Player or AIR to attempt to retrieve a policy file
		from the specified host and port. Upon establishing a connection with
		the specified port, Flash Player or AIR transmits
		`<policy-file-request />`, terminated by a `null` byte. The server
		must send a null byte to terminate a policy file, and may thereafter
		close the connection; if the server does not close the connection,
		Flash Player or AIR does so upon receiving the terminating `null`
		byte.

		You can prevent a SWF file from using this method by setting the
		`allowNetworking` parameter of the `object` and `embed` tags in the
		HTML page that contains the SWF content.

		For more information related to security, see the Flash Player
		Developer Center Topic: <a
		href="http://www.adobe.com/go/devnet_security_en"
		scope="external">Security</a>.

		@param url The URL location of the policy file to be loaded.
	**/
	public static function loadPolicyFile(url:String):Void
	{
		// var res = haxe.Http.requestUrl( url );
	}

	#if false
	/**
		Displays the Security Settings panel in Flash Player. This method does
		not apply to content in Adobe AIR; calling it in an AIR application
		has no effect.

		@param panel A value from the SecurityPanel class that specifies which
					 Security Settings panel you want to display. If you omit
					 this parameter, `SecurityPanel.DEFAULT` is used.
	**/
	// @:noCompletion @:dox(hide) public static function showSettings (panel:openfl.system.SecurityPanel = null):Void;
	#end
}
#else
typedef Security = flash.system.Security;
#end
