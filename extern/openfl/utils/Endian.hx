package openfl.utils;


/**
 * The Endian class contains values that denote the byte order used to
 * represent multibyte numbers. The byte order is either bigEndian(most
 * significant byte first) or littleEndian(least significant byte first).
 *
 * <p>Content in Flash Player or Adobe<sup>®</sup> AIR™ can interface with
 * a server by using the binary protocol of that server, directly. Some
 * servers use the bigEndian byte order and some servers use the littleEndian
 * byte order. Most servers on the Internet use the bigEndian byte order
 * because "network byte order" is bigEndian. The littleEndian byte order is
 * popular because the Intel x86 architecture uses it. Use the endian byte
 * order that matches the protocol of the server that is sending or receiving
 * data.</p>
 */
@:enum abstract Endian(String) from String to String {
	
	public var BIG_ENDIAN = "bigEndian";
	public var LITTLE_ENDIAN = "littleEndian";
	
}