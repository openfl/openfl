package format.swf.tags;

import format.swf.SWFData;
import format.swf.data.SWFFrameLabel;
import format.swf.data.SWFScene;
import format.swf.utils.StringUtils;

class TagDefineSceneAndFrameLabelData implements ITag
{
	public static inline var TYPE:Int = 86;
	
	public var type(default, null):Int;
	public var name(default, null):String;
	public var version(default, null):Int;
	public var level(default, null):Int;
	
	public var scenes (default, null):Array<SWFScene>;
	public var frameLabels (default, null):Array<SWFFrameLabel>;
	
	public function new() {
		type = TYPE;
		name = "DefineSceneAndFrameLabelData";
		version = 9;
		level = 1;
		scenes = new Array<SWFScene>(); 
		frameLabels = new Array<SWFFrameLabel>();
	}
	
	public function parse(data:SWFData, length:Int, version:Int, async:Bool = false):Void {
		var i:Int;
		var sceneCount:Int = data.readEncodedU32();
		for (i in 0...sceneCount) {
			var sceneOffset:Int = data.readEncodedU32();
			var sceneName:String = data.readSTRING();
			scenes.push(new SWFScene(sceneOffset, sceneName));
		}
		
		var frameLabelCount:Int = data.readEncodedU32();
		for (i in 0...frameLabelCount) {
			var frameNumber:Int = data.readEncodedU32();
			var frameLabel:String = data.readSTRING();
			frameLabels.push(new SWFFrameLabel(frameNumber, frameLabel));
		}
	}

	public function publish(data:SWFData, version:Int):Void {
		var i:Int;
		var body:SWFData = new SWFData();
		body.writeEncodedU32(this.scenes.length);
		for (i in 0...this.scenes.length) {
			var scene:SWFScene = this.scenes[i];
			body.writeEncodedU32(scene.offset);
			body.writeSTRING(scene.name);
		}
		body.writeEncodedU32(this.frameLabels.length);
		for (i in 0...this.frameLabels.length) {
			var label :SWFFrameLabel = this.frameLabels[i];
			body.writeEncodedU32(label.frameNumber);
			body.writeSTRING(label.name);
		}
		data.writeTagHeader(type, body.length);
		data.writeBytes(body);
	}

	public function toString(indent:Int = 0):String {
		var str:String = Tag.toStringCommon(type, name, indent);
		var i:Int;
		if (scenes.length > 0) {
			str += "\n" + StringUtils.repeat(indent + 2) + "Scenes:";
			for (i in 0...scenes.length) {
				str += "\n" + StringUtils.repeat(indent + 4) + "[" + i + "] " + scenes[i].toString();
			}
		}
		if (frameLabels.length > 0) {
			str += "\n" + StringUtils.repeat(indent + 2) + "FrameLabels:";
			for (i in 0...frameLabels.length) {
				str += "\n" + StringUtils.repeat(indent + 4) + "[" + i + "] " + frameLabels[i].toString();
			}
		}
		return str;
	}
}