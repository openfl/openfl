package openfl.media;
#if !howlerjs
class SoundSprite { }
#else
import lime.media.howlerjs.Howl;
import js.html.Audio;
import lime.media.AudioBuffer;

@:access(lime.Assets)
@:access(openfl.media.Sound)
@:access(lime.media.AudioBuffer)

#if !lime_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end

class SoundSprite {

  public var buffer:AudioBuffer;
  public var spritePaths:Array<String>;
  public var children = new Map<String, Array<Dynamic>>();
  public var assetKey:String;

  private var __spriteIndex = new Map<String, Array<Dynamic>>();

	public function new (assetKey:String, spritePaths:Array<String>, spriteIndex:Map<String, Dynamic>, ?preload:Bool=false) {
    this.spritePaths = spritePaths;
    this.buffer = AudioBuffer.makeSprite(spritePaths, spriteIndex, preload);
    trace('Requesting files associated with this soundsprite...');
    AudioBuffer.loadFromFiles(spritePaths, this.buffer);
	}

  public static function prepSpriteData(spritePart:SoundSpriteInfo):Dynamic {
    var secToMsStart = spritePart.msStart * 1000;
    var secToMsEnd = spritePart.msEnd * 1000;
    return [secToMsStart, (secToMsEnd - secToMsStart)];
  }

  public function makeSound(spritePart:SoundSpriteInfo):Sound {
    var key = spritePart.spriteKey;
    var sound = Sound.fromAudioBuffer(this.buffer);
    this.children.set(key, [spritePart, sound]);
    return sound;
  }

  public function getIndex():Map<String, Array<Dynamic>> {
    // we may need to jsonify this or something, which is why we use getIndex.
    return __spriteIndex;
  }
}
#end
