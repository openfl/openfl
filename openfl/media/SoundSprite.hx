package openfl.media;
#if !howlerjs
class SoundSprite { }
#else
import lime.media.howlerjs.Howl;
import js.html.Audio;
import lime.media.AudioBuffer;
import lime.app.Future;

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

  private var __bufferFuture:Future<AudioBuffer>;
  private var __spriteIndex = new Map<String, Array<Dynamic>>();

	public function new (assetKey:String, spritePaths:Array<String>, spriteIndex:Map<String, Dynamic>, ?preload:Bool=false) {
    this.spritePaths = spritePaths;
    trace('Requesting files associated with this soundsprite...');
    if (this.__bufferFuture == null) {
      this.buffer = AudioBuffer.makeSprite(spritePaths, spriteIndex, preload);
      this.__bufferFuture = AudioBuffer.loadFromFiles(spritePaths);
      this.__bufferFuture.onComplete(function(a:AudioBuffer) {
        trace('bufferFuture loaded; setting this.buffer.');
        this.buffer = a;
      });
    }
	}

  public static function prepSpriteData(spritePart:SoundSpriteInfo):Dynamic {
    var secToMsStart = spritePart.msStart;
    var secToMsEnd = spritePart.msEnd;
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
