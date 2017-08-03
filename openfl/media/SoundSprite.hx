package openfl.media;
#if howlerjs
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
  
  private var __dirty:Bool = false;
  private var __spriteIndex = new Map<String, Array<Dynamic>>();

	public function new (assetKey:String, spritePaths:Array<String>, spriteIndex:Map<String, Array<Dynamic>>) {
    this.spritePaths = spritePaths;
	}

  public function registerSound(key:String, member:Sound, ?loop:Bool):Void {
    var timings = [2, 3];
    this.children.set(key, [member, timings, loop]);
    __spriteIndex.set(key, [timings[0], timings[1], loop]);
    member.__buffer = this.buffer;
  }

  public function getIndex():Map<String, Array<Dynamic>> {
    // we may need to jsonify this or something, which is why we use getIndex.
    return __spriteIndex;
  }

	public function makeSprite(?preload:Bool):AudioBuffer {
		var audioBuffer = new AudioBuffer ();
		audioBuffer.__srcHowl = new Howl ({
			src: spritePaths,
			sprite: this.__spriteIndex,
			preload: (preload == null ? false : preload)
		});
		return audioBuffer;
	}
}
#end