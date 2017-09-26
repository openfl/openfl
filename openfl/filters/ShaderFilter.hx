package openfl.filters; #if !flash #if !openfl_legacy

import openfl.display.Shader;
import openfl.filters.BitmapFilter;
import openfl.geom.Rectangle;
import openfl._internal.renderer.RenderSession;

/**
 * ...
 * @author MrCdK
 */
class ShaderFilter extends BitmapFilter {

	public var bottomExtension(default, set):Int = 0;
	public var leftExtension(default, set):Int = 0;
	public var rightExtension(default, set):Int = 0;
	public var topExtension(default, set):Int = 0;
	public var shader(default, set):Shader;

	public function new(shader:Shader) {
		super();
		this.shader = shader;
	}

	override public function clone():BitmapFilter {
		var f = new ShaderFilter(shader);
		f.bottomExtension = bottomExtension;
		f.leftExtension = leftExtension;
		f.rightExtension = rightExtension;
		f.topExtension = topExtension;
		return f;
	}

	public override function equals(filter:BitmapFilter) {
		// :TODO: Implement shader equal
		return false;
	}

	override function __growBounds (rect:Rectangle) {

		rect.x += -leftExtension;
		rect.y += -topExtension;
		rect.width += rightExtension;
		rect.height += bottomExtension;

	}

	override function __preparePass(pass:Int):Shader {
		return shader;
	}

	inline function set_bottomExtension(v) 	{ return bottomExtension = v; }
	inline function set_topExtension(v) 	{ return topExtension = v; }
	inline function set_rightExtension(v) 	{ return rightExtension = v; }
	inline function set_leftExtension(v) 	{ return leftExtension = v; }
	inline function set_shader(v) 			{ return shader = v; }

}

#else
typedef ShaderFilter = openfl._legacy.filters.ShaderFilter;
#end
#else
typedef ShaderFilter = flash.filters.ShaderFilter;
#end
