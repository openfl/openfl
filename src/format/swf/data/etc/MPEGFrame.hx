package format.swf.data.etc;

import flash.utils.ByteArray;
import flash.errors.Error;

class MPEGFrame 
{
	public static inline var MPEGversion_1_0:Int = 0;
	public static inline var MPEGversion_2_0:Int = 1;
	public static inline var MPEGversion_2_5:Int = 2;
	
	public static inline var MPEG_LAYER_I:Int = 0;
	public static inline var MPEG_LAYER_II:Int = 1;
	public static inline var MPEG_LAYER_III:Int = 2;
	
	public static inline var CHANNEL_MODE_STEREO:Int = 0;
	public static inline var CHANNEL_MODE_JOINT_STEREO:Int = 1;
	public static inline var CHANNEL_MODE_DUAL:Int = 2;
	public static inline var CHANNEL_MODE_MONO:Int = 3;
	
	private static var mpegBitrates:Array<Array<Array<Int>>> = [
		[ [0, 32, 96, 128, 160, 192, 224, 256, 288, 320, 352, 384, 416, 448, -1],
		  [0, 32, 48, 56, 64, 80, 96, 112, 128, 160, 192, 224, 256, 320, 384, -1],
		  [0, 32, 40, 48, 56, 64, 80, 96, 112, 128, 160, 192, 224, 256, 320, -1] ],
		[ [0, 32, 48, 56, 64, 80, 96, 112, 128, 144, 160, 176, 192, 224, 256, -1],
		  [0, 8, 16, 24, 32, 40, 48, 56, 64, 80, 96, 112, 128, 144, 160, -1],
		  [0, 8, 16, 24, 32, 40, 48, 56, 64, 80, 96, 112, 128, 144, 160, -1] ]
	];
	private static var mpegsamplingrates:Array<Array<Int>> = [
		[44100, 48000, 32000],
		[22050, 24000, 16000],
		[11025, 12000, 8000]
	];
	
	public var version (default, null):Int;
	public var layer (default, null):Int;
	public var bitrate (default, null):Int;
	public var samplingrate (default, null):Int;
	public var padding (default, null):Bool;
	public var channelMode (default, null):Int;
	public var channelModeExt (default, null):Int;
	public var copyright (default, null):Bool;
	public var original (default, null):Bool;
	public var emphasis (default, null):Int;
	
	private var _header:ByteArray;
	public var data:ByteArray;
	private var _crc:ByteArray;
	
	public var crc(get_crc, null):Int;
	public var size(get_size, null):Int;
	
	public var hasCRC (default, null):Bool;

	public var samples (default, null):Int;
	
	public function new() {
		samples = 1152;
		init();
	}
	
	private function get_crc():Int { _crc.position = 0; return _crc.readUnsignedShort(); _crc.position = 0; }

	private function get_size():Int {
		var ret:Int = 0;
		if (layer == MPEG_LAYER_I) {
			ret = Math.floor((12000.0 * bitrate) / samplingrate);
			if (padding) {
				ret++;
			}
			// one slot is 4 bytes long
			ret <<= 2;
		} else {
			ret = Math.floor(((version == MPEGversion_1_0) ? 144000.0 : 72000.0) * bitrate / samplingrate);
			if (padding) {
				ret++;
			}
		}
		// subtract header size and (if present) crc size
		return ret - 4 - (hasCRC ? 2 : 0);
	}

	public function setHeaderByteAt(index:Int, value:Int):Void {
		switch(index) {
			case 0:
				if (value != 0xff) {
					throw(new Error("Not a MPEG header."));
				}
			case 1:
				if ((value & 0xe0) != 0xe0) {
					throw(new Error("Not a MPEG header."));
				}
				// get the mpeg version (we only support mpeg 1.0 and 2.0)
				var mpegVersionBits:Int = (value & 0x18) >> 3;
				switch(mpegVersionBits) {
					case 3: version = MPEGversion_1_0;
					case 2: version = MPEGversion_2_0;
					default: throw(new Error("Unsupported MPEG version."));
				}
				// get the mpeg layer version (we only support layer III)
				var mpegLayerBits:Int = (value & 0x06) >> 1;
				switch(mpegLayerBits) {
					case 1: layer = MPEG_LAYER_III;
					default: throw(new Error("Unsupported MPEG layer."));
				}
				// is the frame secured by crc?
				hasCRC = !((value & 0x01) != 0);
			case 2:
				var bitrateIndex:Int = ((value & 0xf0) >> 4);
				// get the frame's bitrate
				if (bitrateIndex == 0 || bitrateIndex == 0x0f) {
					throw(new Error("Unsupported bitrate index."));
				}
				bitrate = mpegBitrates[version][layer][bitrateIndex];
				// get the frame's samplingrate
				var samplingrateIndex:Int = ((value & 0x0c) >> 2);
				if (samplingrateIndex == 3) {
					throw(new Error("Unsupported samplingrate index."));
				}
				samplingrate = mpegsamplingrates[version][samplingrateIndex];
				// is the frame padded?
				padding = ((value & 0x02) == 0x02);
			case 3:
				// get the frame's channel mode:
				// 0: stereo
				// 1: joint stereo
				// 2: dual channel
				// 3: mono
				channelMode = ((value & 0xc0) >> 6);
				// get the frame's extended channel mode (only for joint stereo):
				channelModeExt = ((value & 0x30) >> 4);
				// get the copyright flag
				copyright = ((value & 0x08) == 0x08);
				// get the original flag
				original = ((value & 0x04) == 0x04);
				// get the emphasis:
				// 0: none
				// 1: 50/15 ms
				// 2: reserved
				// 3: ccit j.17
				emphasis = (value & 0x02);
			default:
				throw(new Error("Index out of bounds."));
		}
		// store the raw header byte for easy access
		_header[index] = value;
	}
	
	public function setCRCByteAt(index:Int, value:Int):Void {
		if (index > 1) {
			throw(new Error("Index out of bounds."));
		}
		_crc[index] = value;
	}
	
	private function init():Void {
		_header = new ByteArray();
		_header.writeByte(0);
		_header.writeByte(0);
		_header.writeByte(0);
		_header.writeByte(0);
		_crc = new ByteArray();
		_crc.writeByte(0);
		_crc.writeByte(0);
	}
	
	public function getFrame():ByteArray {
		var ba:ByteArray = new ByteArray();
		ba.writeBytes(_header, 0, 4);
		if(hasCRC) {
			ba.writeBytes(_crc, 0, 2);
		}
		ba.writeBytes(data);
		return ba;
	}
	
	public function toString():String {
		var encoding:String = "MPEG ";
		switch(version) {
			case MPEGFrame.MPEGversion_1_0: encoding += "1.0 ";
			case MPEGFrame.MPEGversion_2_0: encoding += "2.0 ";
			case MPEGFrame.MPEGversion_2_5: encoding += "2.5 ";
			default: encoding += "?.? ";
		}
		switch(layer) {
			case MPEGFrame.MPEG_LAYER_I: encoding += "Layer I";
			case MPEGFrame.MPEG_LAYER_II: encoding += "Layer II";
			case MPEGFrame.MPEG_LAYER_III: encoding += "Layer III";
			default: encoding += "Layer ?";
		}
		var channel:String = "unknown";
		switch(channelMode) {
			case 0: channel = "Stereo";
			case 1: channel = "Joint stereo";
			case 2: channel = "Dual channel";
			case 3: channel = "Mono";
		}
		return encoding + ", " + bitrate + " kbit/s, " + samplingrate + " Hz, " + channel + ", " + size + " bytes";
	}
}