package format.swf;

import format.abc.Data.ABCData;
import format.abc.Data.ClassDef;
import format.abc.Data.Field;
import format.abc.Data.IName;
import format.abc.Data.Index;
import format.abc.Data.Name;
import format.abc.Data.Namespace;
import format.SWF;
import format.swf.data.SWFFrameLabel;
import format.swf.data.SWFRawTag;
import format.swf.data.SWFRecordHeader;
import format.swf.data.SWFScene;
import format.swf.data.consts.SoundCompression;
import format.swf.events.SWFErrorEvent;
import format.swf.events.SWFEventDispatcher;
import format.swf.events.SWFProgressEvent;
import format.swf.events.SWFWarningEvent;
import format.swf.factories.ISWFTagFactory;
import format.swf.factories.SWFTagFactory;
import format.swf.tags.IDefinitionTag;
import format.swf.tags.IDisplayListTag;
import format.swf.tags.ITag;
import format.swf.tags.TagDefineMorphShape;
import format.swf.tags.TagDefineScalingGrid;
import format.swf.tags.TagDefineSceneAndFrameLabelData;
import format.swf.tags.TagDoABC;
import format.swf.tags.TagEnd;
import format.swf.tags.TagFrameLabel;
import format.swf.tags.TagJPEGTables;
import format.swf.tags.TagPlaceObject;
import format.swf.tags.TagPlaceObject2;
import format.swf.tags.TagPlaceObject3;
import format.swf.tags.TagRemoveObject;
import format.swf.tags.TagRemoveObject2;
import format.swf.tags.TagSetBackgroundColor;
import format.swf.tags.TagShowFrame;
import format.swf.tags.TagSoundStreamBlock;
import format.swf.tags.TagSoundStreamHead;
import format.swf.tags.TagSoundStreamHead2;
import format.swf.tags.TagSymbolClass;
import format.swf.timeline.Frame;
import format.swf.timeline.FrameObject;
import format.swf.timeline.Layer;
import format.swf.timeline.LayerStrip;
import format.swf.timeline.Scene;
import format.swf.timeline.SoundStream;
import format.swf.utils.StringUtils;
import flash.errors.Error;

import flash.display.Sprite;
import flash.events.Event;
import flash.utils.ByteArray;
import flash.utils.Endian;
//import flash.utils.getTimer;

class SWFTimelineContainer extends SWFEventDispatcher
{
	// We're just being lazy here.
	public static var TIMEOUT:Int = 50;
	public static var AUTOBUILD_LAYERS:Bool = false;
	public static var EXTRACT_SOUND_STREAM:Bool = true;
	public static var scalingGrids(default, null):Map<Int, Int>;

	public var tags(default, null):Array<ITag>;
	public var tagsRaw(default, null):Array<SWFRawTag>;
	public var dictionary(default, null):Map<Int, Int>;
	public var scenes(default, null):Array<Scene>;
	public var frames(default, null):Array<Frame>;
	public var layers(default, null):Array<Layer>;
	public var soundStream(default, null):SoundStream;

	public var frameLabels(default, null):Map<Int, String>;
	public var frameIndexes(default, null):Map<String, Int>;

	private var currentFrame:Frame;
	private var hasSoundStream:Bool;

	private var enterFrameProvider:Sprite;
	private var eof:Bool;

	private var _tmpData:SWFData;
	private var _tmpVersion:Int;
	private var _tmpTagIterator:Int = 0;

	public var tagFactory:ISWFTagFactory;

	private var rootTimelineContainer:SWFTimelineContainer;

	public var backgroundColor:Int;
	public var jpegTablesTag:TagJPEGTables;

	public var abcTag:TagDoABC;
	public var abcData:ABCData;
	public var pcode:Array<Dynamic>;
	public var abcClasses(default, null):Map<Int, ClassDef>;


	public function new()
	{
		super();

		if (scalingGrids == null) scalingGrids = new Map<Int, Int>();

		backgroundColor = 0xffffff;
		tags = new Array<ITag>();
		tagsRaw = new Array<SWFRawTag>();
		dictionary = new Map<Int, Int>();
		scenes = new Array<Scene>();
		frames = new Array<Frame>();
		layers = new Array<Layer>();

		tagFactory = new SWFTagFactory();

		rootTimelineContainer = this;

		enterFrameProvider = new Sprite();
	}

	public function getCharacter(characterId:Int):IDefinitionTag {

		var tagIndex:Int = rootTimelineContainer.dictionary.get (characterId);

		if (tagIndex >= 0 && tagIndex < rootTimelineContainer.tags.length) {
			return cast rootTimelineContainer.tags[tagIndex];
		}
		return null;
	}

	public function getScalingGrid(characterId:Int):TagDefineScalingGrid {
		//trace(characterId  + " getScalingGrid" );
		//trace(scalingGrids);

		if (scalingGrids.exists (characterId)) {
			return cast rootTimelineContainer.tags[scalingGrids.get (characterId)];
		}
		return null;
	}

	public function parseTags(data:SWFData, version:Int):Void {
		var tag:ITag;
		parseTagsInit(data, version);
		while ((tag = parseTag(data)) != null && tag.type != TagEnd.TYPE) {};
		parseTagsFinalize();
	}

	public function parseTagsAsync(data:SWFData, version:Int):Void {
		parseTagsInit(data, version);
		enterFrameProvider.addEventListener(Event.ENTER_FRAME, parseTagsAsyncHandler);
	}

	private function parseTagsAsyncHandler(event:Event):Void {
		enterFrameProvider.removeEventListener(Event.ENTER_FRAME, parseTagsAsyncHandler);
		if(dispatchEvent(new SWFProgressEvent(SWFProgressEvent.PROGRESS, _tmpData.position, _tmpData.length, false, true))) {
			parseTagsAsyncInternal();
		}
	}

	private function parseTagsAsyncInternal():Void {
		var tag:ITag;
		var time:Int = flash.Lib.getTimer();
		while ((tag = parseTag(_tmpData, true)) != null && tag.type != TagEnd.TYPE) {
			if((flash.Lib.getTimer() - time) > TIMEOUT) {
				enterFrameProvider.addEventListener(Event.ENTER_FRAME, parseTagsAsyncHandler);
				return;
			}
		}
		parseTagsFinalize();
		if(eof) {
			dispatchEvent(new SWFErrorEvent(SWFErrorEvent.ERROR, SWFErrorEvent.REASON_EOF));
		} else {
			dispatchEvent(new SWFProgressEvent(SWFProgressEvent.PROGRESS, _tmpData.position, _tmpData.length));
			dispatchEvent(new SWFProgressEvent(SWFProgressEvent.COMPLETE, _tmpData.position, _tmpData.length));
		}
	}

	private function parseTagsInit(data:SWFData, version:Int):Void {
		tags = new Array<ITag>();
		frames = new Array<Frame>();
		layers = new Array<Layer>();
		dictionary = new Map<Int, Int>();
		currentFrame = new Frame();
		frameLabels = new Map<Int, String>();
		frameIndexes = new Map<String, Int>();
		hasSoundStream = false;
		_tmpData = data;
		_tmpVersion = version;

		//trace(":: Container parseTagsInit");
	}

	private function parseTag(data:SWFData, async:Bool = false):ITag {
		var pos:Int = data.position;
		// Bail out if eof
		eof = (pos >= data.length);
		if(eof) {
			trace("WARNING: end of file encountered, no end tag.");
			return null;
		}
		var tagRaw:SWFRawTag = data.readRawTag();
		var tagHeader:SWFRecordHeader = tagRaw.header;
		var tag:ITag = tagFactory.create(tagHeader.type);
		try {
			if(Std.is (tag, SWFTimelineContainer)) {
				var timelineContainer:SWFTimelineContainer = cast tag;
				// Currently, the only SWFTimelineContainer (other than the SWF root
				// itself) is TagDefineSprite (MovieClips have their own timeline).
				// Inject the current tag factory there.
				timelineContainer.tagFactory = tagFactory;
				timelineContainer.rootTimelineContainer = this;
			}

			// Parse tag
			tag.parse(data, tagHeader.contentLength, _tmpVersion, async);
		} catch(e:Error) {
			// If we get here there was a problem parsing this particular tag.
			// Corrupted SWF, possible SWF exploit, or obfuscated SWF.
			// TODO: register errors and warnings
			trace("WARNING: parse error: " + e.message + ", Tag: " + tag.name + ", Index: " + tags.length);
			throw(e);
		}
		// Register tag
		tags.push(tag);
		tagsRaw.push(tagRaw);

		// Build dictionary and display list etc
		processTag(tag);
		// Adjust position (just in case the parser under- or overflows)
		var position:UInt = pos + tagHeader.tagLength;
		if(data.position != position) {
			var index:Int = tags.length - 1;
			var excessBytes:Int = data.position - (pos + tagHeader.tagLength);
			var eventType:String = (excessBytes < 0) ? SWFWarningEvent.WARN_UNDERFLOW : SWFWarningEvent.WARN_OVERFLOW;
			var eventData:Dynamic = {
				pos: pos,
				bytes: (excessBytes < 0) ? -excessBytes : excessBytes
			};
			if(rootTimelineContainer == this) {
				trace("WARNING: excess bytes: " + excessBytes + ", " +
					"Tag: " + tag.name + ", " +
					"Index: " + index
				);
			} else {
				eventData.indexRoot = rootTimelineContainer.tags.length;
				trace("WARNING: excess bytes: " + excessBytes + ", " +
					"Tag: " + tag.name + ", " +
					"Index: " + index + ", " +
					"IndexRoot: " + eventData.indexRoot
				);
			}
			var event:SWFWarningEvent = new SWFWarningEvent(eventType, index, eventData, false, true);
			var cancelled:Bool = !dispatchEvent(event);
			if (cancelled) {
				tag = null;
			}
			data.position = pos + tagHeader.tagLength;
		}
		return tag;
	}

	private function parseTagsFinalize():Void {
		if(soundStream != null && soundStream.data.length == 0) {
			soundStream = null;
		}
		if(AUTOBUILD_LAYERS) {
			// TODO: This needs to go into processTags()
			buildLayers();
		}
		//trace(":: Container parseTagsFinalize");
	}

	public function publishTags(data:SWFData, version:Int):Void {
		var tag:ITag;
		var tagRaw:SWFRawTag;
		for (i in 0...tags.length) {
			tag = tags[i];
			tagRaw = (i < tagsRaw.length) ? tagsRaw[i] : null;
			publishTag(data, tag, tagRaw, version);
		}
	}

	public function publishTagsAsync(data:SWFData, version:Int):Void {
		_tmpData = data;
		_tmpVersion = version;
		_tmpTagIterator = 0;
		enterFrameProvider.addEventListener(Event.ENTER_FRAME, publishTagsAsyncHandler);
	}

	private function publishTagsAsyncHandler(event:Event):Void {
		enterFrameProvider.removeEventListener(Event.ENTER_FRAME, publishTagsAsyncHandler);
		if(dispatchEvent(new SWFProgressEvent(SWFProgressEvent.PROGRESS, _tmpTagIterator, tags.length))) {
			publishTagsAsyncInternal();
		}
	}

	private function publishTagsAsyncInternal():Void {
		var tag:ITag;
		var tagRaw:SWFRawTag;
		var time:Int = flash.Lib.getTimer();
		do {
			tag = (_tmpTagIterator < tags.length) ? tags[_tmpTagIterator] : null;
			tagRaw = (_tmpTagIterator < tagsRaw.length) ? tagsRaw[_tmpTagIterator] : null;
			publishTag(_tmpData, tag, tagRaw, _tmpVersion);
			_tmpTagIterator++;
			if((flash.Lib.getTimer() - time) > TIMEOUT) {
				enterFrameProvider.addEventListener(Event.ENTER_FRAME, publishTagsAsyncHandler);
				return;
			}
		}
		while (tag.type != TagEnd.TYPE);
		dispatchEvent(new SWFProgressEvent(SWFProgressEvent.PROGRESS, _tmpTagIterator, tags.length));
		dispatchEvent(new SWFProgressEvent(SWFProgressEvent.COMPLETE, _tmpTagIterator, tags.length));
	}

	public function publishTag(data:SWFData, tag:ITag, rawTag:SWFRawTag, version:Int):Void {
		try {
			tag.publish(data, version);
		}
		catch (e:Error) {
			trace("WARNING: publish error: " + e.message + " (tag: " + tag.name + ")");
			if(rawTag != null) {
				rawTag.publish(data);
			} else {
				trace("FATAL: publish error: No raw tag fallback");
			}
		}
	}

	private function processTag(tag:ITag):Void {

		//trace("  ..Process: " + tag.type + " - name: " + tag.name);

		var currentTagIndex:Int = tags.length - 1;
		if(Std.is (tag, IDefinitionTag)) {
			processDefinitionTag(cast tag, currentTagIndex);
			return;
		} else if(Std.is (tag, IDisplayListTag)) {
			processDisplayListTag(cast tag, currentTagIndex);
			return;
		}

		switch(cast (tag.type, Int)) {
			// Frame labels and scenes
			case TagFrameLabel.TYPE, TagDefineSceneAndFrameLabelData.TYPE:
				processFrameLabelTag(tag, currentTagIndex);
			// Sound stream
			case TagSoundStreamHead.TYPE, TagSoundStreamHead2.TYPE, TagSoundStreamBlock.TYPE:
				if(EXTRACT_SOUND_STREAM) {
					processSoundStreamTag(tag, currentTagIndex);
				}
			// Background color
			case TagSetBackgroundColor.TYPE:
				processBackgroundColorTag(cast tag, currentTagIndex);
			// Global JPEG Table
			case TagJPEGTables.TYPE:
				processJPEGTablesTag(cast tag, currentTagIndex);
			// Scale-9 grids
			case TagDefineScalingGrid.TYPE:
				processScalingGridTag(cast tag, currentTagIndex);
			// Actionscript 3
			case TagDoABC.TYPE:
				processAS3Tag(cast tag, currentTagIndex);
		}
	}

	private function processDefinitionTag(tag:IDefinitionTag, currentTagIndex:Int):Void {
		if(tag.characterId > 0) {
			// Register definition tag in dictionary
			// key: character id
			// value: definition tag index
			dictionary.set (tag.characterId, currentTagIndex);
			// Register character id in the current frame's character array
			currentFrame.characters.push(tag.characterId);
		}
	}

	private function processDisplayListTag(tag:IDisplayListTag, currentTagIndex:Int):Void {
		switch(cast (tag.type, Int)) {
			case TagShowFrame.TYPE:
				currentFrame.tagIndexEnd = currentTagIndex;
				if (currentFrame.label == null && frameLabels.exists (currentFrame.frameNumber)) {
					currentFrame.label = frameLabels.get (currentFrame.frameNumber);
				}
				frames.push(currentFrame);
				currentFrame = currentFrame.clone();
				currentFrame.frameNumber = frames.length;
				currentFrame.tagIndexStart = currentTagIndex + 1;
			case TagPlaceObject.TYPE, TagPlaceObject2.TYPE, TagPlaceObject3.TYPE:
				currentFrame.placeObject(currentTagIndex, cast tag);
			case TagRemoveObject.TYPE, TagRemoveObject2.TYPE:
				currentFrame.removeObject(cast tag);
		}
	}

	private function processFrameLabelTag(tag:ITag, currentTagIndex:Int):Void {
		switch(cast (tag.type, Int)) {
			case TagDefineSceneAndFrameLabelData.TYPE:
				// This seems to be unnecessary (at least for frame labels) because frameLabels appear again as TagFrameLabel, and TagDefineSceneAndFrameLabelData does not appear on every MC
				var tagSceneAndFrameLabelData:TagDefineSceneAndFrameLabelData = cast tag;
				var i:Int;
				for(i in 0...tagSceneAndFrameLabelData.frameLabels.length) {
					var frameLabel:SWFFrameLabel = tagSceneAndFrameLabelData.frameLabels[i];
					frameLabels.set (frameLabel.frameNumber, frameLabel.name);
					frameIndexes.set (frameLabel.name, frameLabel.frameNumber + 1);
				}
				for(i in 0...tagSceneAndFrameLabelData.scenes.length) {
					var scene:SWFScene = cast tagSceneAndFrameLabelData.scenes[i];
					scenes.push(new Scene(scene.offset, scene.name));
				}
			case TagFrameLabel.TYPE:
				var tagFrameLabel:TagFrameLabel = cast tag;
				currentFrame.label = tagFrameLabel.frameName;
				frameLabels.set(currentFrame.frameNumber, tagFrameLabel.frameName);
				frameIndexes.set (tagFrameLabel.frameName, currentFrame.frameNumber + 1);
		}
	}

	private function processSoundStreamTag(tag:ITag, currentTagIndex:Int):Void {
		switch(cast (tag.type, Int)) {
			case TagSoundStreamHead.TYPE, TagSoundStreamHead2.TYPE:
				var tagSoundStreamHead:TagSoundStreamHead = cast tag;
				soundStream = new SoundStream();
				soundStream.compression = tagSoundStreamHead.streamSoundCompression;
				soundStream.rate = tagSoundStreamHead.streamSoundRate;
				soundStream.size = tagSoundStreamHead.streamSoundSize;
				soundStream.type = tagSoundStreamHead.streamSoundType;
				soundStream.numFrames = 0;
				soundStream.numSamples = 0;
			case TagSoundStreamBlock.TYPE:
				if(soundStream != null) {
					if(!hasSoundStream) {
						hasSoundStream = true;
						soundStream.startFrame = currentFrame.frameNumber;
					}
					var tagSoundStreamBlock:TagSoundStreamBlock = cast tag;
					var soundData:ByteArray = tagSoundStreamBlock.soundData;
					soundData.endian = Endian.LITTLE_ENDIAN;
					soundData.position = 0;
					switch(soundStream.compression) {
						case SoundCompression.ADPCM: // ADPCM
							// TODO
						case SoundCompression.MP3: // MP3
							var numSamples:Int = soundData.readUnsignedShort();
							var seekSamples:Int = soundData.readShort();
							if(numSamples > 0) {
								soundStream.numSamples += numSamples;
								soundStream.data.writeBytes(soundData, 4);
							}
					}
					soundStream.numFrames++;
				}
		}
	}

	private function processBackgroundColorTag(tag:TagSetBackgroundColor, currentTagIndex:Int):Void {
		backgroundColor = tag.color;
	}

	private function processJPEGTablesTag(tag:TagJPEGTables, currentTagIndex:Int):Void {
		jpegTablesTag = tag;
	}

	private function processScalingGridTag(tag:TagDefineScalingGrid, currentTagIndex:Int):Void {
		scalingGrids.set (tag.characterId, currentTagIndex);
	}

	private function processAS3Tag(tag:TagDoABC, currentTagIndex:Int):Void {
		// Just store it for now
		abcTag = tag;

		//trace("ABC: " + tag.toString());

		var bytes = #if flash haxe.io.Bytes.ofData(tag.bytes) #else tag.bytes #end;
		var input = new haxe.io.BytesInput(bytes);
		var reader = new format.abc.Reader(input);

		//trace("Reading...");
		abcData = reader.read();

		pcode = new Array();
		for (fn in abcData.functions) {
			pcode.push(format.abc.OpReader.decode(new haxe.io.BytesInput(fn.code)));
		}
	}

	public function buildLayers():Void {
		var i:Int;
		var depth:String;
		var depthInt:Int;
		var depths = new Map <Int, Array <Int>>();
		var depthsAvailable:Array<Int> = [];

		for(i in 0...frames.length) {
			var frame:Frame = frames[i];
			for(depth in frame.objects.keys()) {
				depthInt = Std.int(depth);
				var foundIndex = false;
				for (index in depthsAvailable) {
					if (index == depthInt) foundIndex = true; break;
				}
				if(foundIndex) {
					(depths.get (depth)).push(frame.frameNumber);
				} else {
					depths.set (depth, [ frame.frameNumber ]);
					depthsAvailable.push(depthInt);
				}
			}
		}

		depthsAvailable.sort(sortNumeric);

		for(i in 0...depthsAvailable.length) {
			var layer:Layer = new Layer(depthsAvailable[i], frames.length);
			var frameIndices = depths.get (depthsAvailable[i]);
			var frameIndicesLen:Int = frameIndices.length;
			if(frameIndicesLen > 0) {
				var curStripType:Int = LayerStrip.TYPE_EMPTY;
				//var startFrameIndex:Int = uint.MAX_VALUE;
				var startFrameIndex:Int = Std.int (SWFData.MAX_FLOAT_VALUE);
				//var endFrameIndex:Int = uint.MAX_VALUE;
				var endFrameIndex:Int = Std.int (SWFData.MAX_FLOAT_VALUE);
				for(j in 0...frameIndicesLen) {
					var curFrameIndex:Int = frameIndices[j];
					var curFrameObject:FrameObject = frames[curFrameIndex].objects.get (layer.depth);
					if(curFrameObject.isKeyframe) {
						// a keyframe marks the start of a new strip: save current strip
						layer.appendStrip(curStripType, startFrameIndex, endFrameIndex);
						// set start of new strip
						startFrameIndex = curFrameIndex;
						// evaluate type of new strip (motion tween detection see below)
						curStripType = (Std.is (getCharacter(curFrameObject.characterId), TagDefineMorphShape)) ? LayerStrip.TYPE_SHAPETWEEN : LayerStrip.TYPE_STATIC;
					} else if(curStripType == LayerStrip.TYPE_STATIC && curFrameObject.lastModifiedAtIndex > 0) {
						// if one of the matrices of an object in a static strip is
						// modified at least once, we are dealing with a motion tween:
						curStripType = LayerStrip.TYPE_MOTIONTWEEN;
					}
					// update the end of the strip
					endFrameIndex = curFrameIndex;
				}
				layer.appendStrip(curStripType, startFrameIndex, endFrameIndex);
			}
			layers.push(layer);
		}

		for(i in 0...frames.length) {
			var frameObjs = frames[i].objects;
			for (depth in frameObjs.keys()) {

				for (j in 0...depthsAvailable.length) {

					if (depth == depthsAvailable[j]) {

						frameObjs.get (depth).layer = j;

					}

				}


			}
		}
	}

	private function sortNumeric (a:Int, b:Int):Int {

		return a - b;

	}

	public function toString(indent:Int = 0):String {
		var i:Int;
		var str:String = "";
		if (tags.length > 0) {
			str += "\n" + StringUtils.repeat(indent + 2) + "Tags:";
			for (i in 0...tags.length) {
				str += "\n" + tags[i].toString(indent + 4);
			}
		}
		if (scenes.length > 0) {
			str += "\n" + StringUtils.repeat(indent + 2) + "Scenes:";
			for (i in 0...scenes.length) {
				str += "\n" + scenes[i].toString(indent + 4);
			}
		}
		if (frames.length > 0) {
			str += "\n" + StringUtils.repeat(indent + 2) + "Frames:";
			for (i in 0...frames.length) {
				str += "\n" + frames[i].toString(indent + 4);
			}
		}
		if (layers.length > 0) {
			str += "\n" + StringUtils.repeat(indent + 2) + "Layers:";
			for (i in 0...layers.length) {
				str += "\n" + StringUtils.repeat(indent + 4) +
					"[" + i + "] " + layers[i].toString(indent + 4);
			}
		}
		return str;
	}
}
