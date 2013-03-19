package;


import haxe.io.Bytes;
import haxe.io.Path;
import format.swf.Data;
import format.swf.Constants;
import format.swf.Reader;
import format.swf.Writer;
import format.wav.Data;
import nme.text.Font;
import nme.utils.ByteArray;
import sys.io.File;
import sys.FileSystem;
import sys.io.FileSeek;


class FlashHelper {
	
	
	private static var swfAssetID = 1000;
	
	
	private static function embedAsset (inAsset:Asset, packageName:String, outTags:Array<SWFTag>) {
		
		var embed = inAsset.embed;
		var name = inAsset.sourcePath;
		var type = inAsset.type;
		var flatName = inAsset.flatName;
		var ext = inAsset.format;
		
		if (!embed) {
			
			return false;
			
		}
		
		LogHelper.info ("", " - Embedding asset: [" + type + "] " + name);
		
		var cid = nextAssetID ();
		
		if (type == AssetType.MUSIC || type == AssetType.SOUND) {
			
			var src = name;
			
			if (ext != "mp3" && ext != "wav") {
				
				for (e in ["wav", "mp3"]) {
					
					src = name.substr (0, name.length - ext.length) + e;
					
					if (FileSystem.exists (src)) {
						
						break;
						
					}
					
				}
				
			}
			
			if (!FileSystem.exists (src)) {
				
				Sys.println ("Warning: Could not embed unsupported audio file \"" + name + "\"");
				return false;
				
			}
			
			var input = File.read (src, true);
			
			if (ext == "mp3") {
				
				var reader = new mpeg.audio.MpegAudioReader(input);
				
				var frameDataWriter = new haxe.io.BytesOutput();
				var totalLengthSamples = 0;
				var samplingFrequency = -1;
				var isStereo:Null<Bool> = null;
				var encoderDelay = 0;
				var endPadding = 0;
				var decoderDelay = 529; // This is a constant delay caused by the Fraunhofer MP3 Decoder used in Flash Player.
				
				while (true) {
					switch (reader.readNext()) {
						case Frame(frame):
						if (frame.header.layer != mpeg.audio.Layer.Layer3) {
							throw "Only Layer-III MP3 files are supported by Flash. File " + src + " is: " + frame.header.layer + ".";
						}
						var frameSamplingFrequency = frame.header.samplingFrequency;
						if (samplingFrequency == -1) {
							samplingFrequency = frameSamplingFrequency;
						} else if (frameSamplingFrequency != samplingFrequency) {
							throw "File " + src + " has a variable sampling frequency, which is not supported by Flash.";
						}
						var frameIsStereo = frame.header.mode != mpeg.audio.Mode.SingleChannel;
						if (isStereo == null) {
							isStereo = frameIsStereo;
						} else if (frameIsStereo != isStereo) {
							throw "File " + src + " contains mixed mono and stereo frames, which is not supported by Flash.";
						}
						frameDataWriter.write(frame.frameData);
						totalLengthSamples += mpeg.audio.Utils.lookupSamplesPerFrame(frame.header.version, frame.header.layer);
						
						case GaplessInfo(giEncoderDelay, giEndPadding):
						encoderDelay = giEncoderDelay;
						endPadding = giEndPadding;
						
						case Info(_): // ignore
						case Unknown(_): // ignore
						case End: break;
					}
				}
				
				if (totalLengthSamples == 0) {
					throw "File " + src + " does not contain any valid MP3 audio data!";
				}
				
				var flashSamplingFrequency = switch (samplingFrequency) {
					case 11025: SR11k;
					case 22050: SR22k;
					case 44100: SR44k;
					
					default: throw "Only 11025, 22050 and 44100kHz MP3 files are supported by Flash. "
							+ "File " + src + " is: " + samplingFrequency + "kHz.";
				}
				
				var frameData = frameDataWriter.getBytes();
				
				var snd:format.swf.Sound = {
					sid: cid,
					format: SFMP3,
					rate: flashSamplingFrequency,
					is16bit: true,
					isStereo: isStereo,
					samples: totalLengthSamples - endPadding - encoderDelay,
					data: SDMp3(encoderDelay + decoderDelay, frameData)
				};
				
				outTags.push (TSound (snd));
				
			} else {
				
				if (input.readString (4) != "RIFF") {
					
					Sys.println ("Warning: Could not embed unrecognized WAV file \"" + name + "\"");
					
				} else {
					
					input = File.read (src, true);
					
					var r = new format.wav.Reader (input);
					var wav = r.read ();
					var hdr = wav.header;
					
					if (hdr.format != WF_PCM) {
						
						throw "Only PCM (uncompressed) wav files can be imported.";
						
					}
					
					// Check sampling rate
					var flashRate = switch (hdr.samplingRate) {
						
						case  5512: SR5k;
						case 11025: SR11k;
						case 22050: SR22k;
						case 44100: SR44k;
						default:
							throw "Only 5512, 11025, 22050 and 44100 Hz wav files are supported by flash. Sampling rate of '" + src + "' is: " + hdr.samplingRate;
						
					}

					var isStereo = switch (hdr.channels) {
						
						case 1: false;
						case 2: true;
						default: 
							throw "Number of channels should be 1 or 2, but for '" + src + "' it is " + hdr.channels;
						
					}

					var is16bit = switch (hdr.bitsPerSample) {
						
						case 8: false;
						case 16: true;
						default: 
							throw "Bits per sample should be 8 or 16, but for '" + src + "' it is " + hdr.bitsPerSample;
						
					}
					
					if (wav.data != null) {
						
						var sampleCount = Std.int (wav.data.length / (hdr.bitsPerSample / 8));
						
						var snd:format.swf.Sound = {
							
							sid : cid,
							format : SFLittleEndianUncompressed,
							rate : flashRate,
							is16bit : is16bit,
							isStereo : isStereo,
							samples : sampleCount,
							data : SDRaw (wav.data)
							
						}
						
						outTags.push (TSound (snd));
						
					} else {
						
						Sys.println ("Warning: Could not embed WAV file \"" + name + "\", the file may be corrupted");
						
					}
					
				}
				
			}
			
			input.close ();
			
		} else if (type == AssetType.IMAGE) {
			
			var src = name;
			
			if (ext == "jpg" || ext == "png" || ext == "gif") {
				
				if (!FileSystem.exists (src)) {
					
					Sys.println ("Warning: Could not find image path \"" + src + "\"");
					
				} else {
					
					var bytes = File.getBytes (src);
					outTags.push (TBitsJPEG (cid, JDJPEG2 (bytes)));
					
				}
				
			} else {
				
				throw ("Unknown image type:" + src );
				
			}
			
		} else if (type == AssetType.FONT) {
			
			// More code ripped off from "samhaxe"
			var src = name;
			var font_name = Path.withoutExtension (name);
			var font = Font.load (src);
			
			var glyphs = new Array <Font2GlyphData> ();
			var glyph_layout = new Array <FontLayoutGlyphData> ();
			
			for (native_glyph in font.glyphs) {
				
				if (native_glyph.char_code > 65535) {
					
					Sys.println("Warning: glyph with character code greater than 65535 encountered ("+ native_glyph.char_code+"). Skipping...");
					continue;
					
				}
				
				var shapeRecords = new Array <ShapeRecord> ();
				var i:Int = 0;
				var styleChanged:Bool = false;

				while (i < native_glyph.points.length) {
					
					var type = native_glyph.points[i++];
					
					switch (type) {
						
						case 1: // Move
							
							var dx = native_glyph.points[i++];
							var dy = native_glyph.points[i++];
							shapeRecords.push( SHRChange({
								moveTo: {dx: dx, dy: -dy},
								// Set fill style to 1 in first style change record
								// Required by DefineFontX
								fillStyle0: if (!styleChanged) {idx: 1} else null,
								fillStyle1: null,
								lineStyle:  null,
								newStyles:  null
							}));
							styleChanged = true;
						
						case 2: // LineTo
							
							var dx = native_glyph.points[i++];
							var dy = native_glyph.points[i++];
							shapeRecords.push (SHREdge(dx, -dy));
						
						case 3: // CurveTo
							var cdx = native_glyph.points[i++];
							var cdy = native_glyph.points[i++];
							var adx = native_glyph.points[i++];
							var ady = native_glyph.points[i++];
							shapeRecords.push (SHRCurvedEdge(cdx, -cdy, adx, -ady));
						
						default:
							throw "Invalid control point type encountered! (" + type + ")";
						
					}
					
				}
				
				shapeRecords.push (SHREnd);
				
				glyphs.push({
					charCode: native_glyph.char_code,
					shape: {
						shapeRecords: shapeRecords
					} 
				});
				
				glyph_layout.push({
					advance: native_glyph.advance,
					bounds: {
						left:    native_glyph.min_x,
						right:   native_glyph.max_x,
						top:    -native_glyph.max_y,
						bottom: -native_glyph.min_y,
					}
				});
				
			}
			
			var kerning = new Array <FontKerningData> ();
			
			if (font.kerning != null) {
				
				for (k in font.kerning) {
					
					kerning.push ({
						charCode1:  k.left_glyph,
						charCode2:  k.right_glyph,
						adjust:     k.x,
					});
					
				}
				
			}
			
			var swf_em = 1024 * 20;
			var ascent = Math.ceil (font.ascend * swf_em / font.em_size);
			var descent = -Math.ceil (font.descend * swf_em / font.em_size);
			var leading = Math.ceil ((font.height - font.ascend + font.descend) * swf_em / font.em_size);
			var language = LangCode.LCNone;
			
			outTags.push (TFont (cid, FDFont3 ({
				shiftJIS:   false,
				isSmall:    false,
				isANSI:     false,
				isItalic:   font.is_italic,
				isBold:     font.is_bold,
				language:   language,
				name:       font_name,
				glyphs:     glyphs,
				layout: {
					ascent:     ascent,
					descent:    descent,
					leading:    leading,
					glyphs:     glyph_layout,
					kerning:    kerning
				}
			})) );
			
		} else {
			
			var bytes:Bytes = null;
			
			if (inAsset.data != null) {
				
				if (Std.is (inAsset.data, Bytes)) {
					
					bytes = cast inAsset.data;
					
				} else {
					
					bytes = Bytes.ofString (Std.string (inAsset.data));
					
				}
				
			}
			
			if (bytes == null) {
				
				bytes = File.getBytes (name);
				
			}
			
			outTags.push (TBinaryData (cid, bytes));
			
		}
		
		outTags.push (TSymbolClass ( [ { cid:cid, className: packageName + "NME_" + flatName } ] ));
		
		return true;
		
	}
	
	
	public static function embedAssets (targetPath:String, assets:Array <Asset>, packageName:String = ""):Void {

		try {
			var input = File.read (targetPath, true);
			if (input != null) {
				var reader = new Reader (input);
				var swf = reader.read ();
				input.close();
				
				var new_tags = new Array <SWFTag> ();
				var inserted = false;
				
				for (tag in swf.tags) {
					
					var name = Type.enumConstructor(tag);
					
					if (name == "TShowFrame" && !inserted && assets.length > 0) {
						
						new_tags.push (TShowFrame);
						
						for (asset in assets) {
							
							if (asset.type != AssetType.TEMPLATE && embedAsset (asset, packageName, new_tags)) {
								
								inserted = true;
								
							}
							
						}
						
					}
					
					new_tags.push (tag);
					
				}

				if (inserted) {
					
					swf.tags = new_tags;
					var output = File.write (targetPath, true);
					var writer = new Writer (output);
					writer.write (swf);
					output.close ();
					
				}
			} else {
				trace("Embedding assets failed! We encountered an error. Does '"+targetPath+"' exist?");
			}
		} catch (e:Dynamic) {
			trace("Embedding assets failed! We encountered an error accessing '"+targetPath+"': " + e);
		}
		
	}
	
	
	private static function nextAssetID () {
		
		return swfAssetID++;
		
	}
	
	
	public static function run (project:NMEProject, workingDirectory:String, targetPath:String):Void {
		
		var player:String = null;
		
		if (!StringTools.endsWith (targetPath, ".html")) {
			
			if (project.environment.exists ("SWF_PLAYER")) {
				
				player = project.environment.get ("SWF_PLAYER");
				
			} else {
				
				player = Sys.getEnv ("FLASH_PLAYER_EXE");
				
			}
			
		}
		
		ProcessHelper.openFile (workingDirectory, targetPath, player);
		
	}
	

}