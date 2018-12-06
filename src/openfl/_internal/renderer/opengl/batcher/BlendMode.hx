package openfl._internal.renderer.opengl.batcher;

import lime.graphics.GLRenderContext;
import lime.graphics.opengl.GL;
import openfl.display.BlendMode as OpenFLBlendMode;

class BlendMode {
	public static var NONE(default,never) = new BlendMode(GL.FUNC_ADD, GL.ONE, GL.ZERO);
	public static var NORMAL(default,never) = new BlendMode(GL.FUNC_ADD, GL.ONE, GL.ONE_MINUS_SRC_ALPHA);
	public static var ADD(default,never) = new BlendMode(GL.FUNC_ADD, GL.ONE, GL.ONE);
	public static var MULTIPLY(default,never) = new BlendMode(GL.FUNC_ADD, GL.DST_COLOR, GL.ONE_MINUS_SRC_ALPHA);
	public static var SCREEN(default,never) = new BlendMode(GL.FUNC_ADD, GL.ONE, GL.ONE_MINUS_SRC_COLOR);
	public static var SUBTRACT(default,never) = new BlendMode(GL.FUNC_REVERSE_SUBTRACT, GL.ONE, GL.ONE);
	public static var ERASE(default,never) = new BlendMode(GL.FUNC_ADD, GL.ZERO, GL.ONE_MINUS_SRC_ALPHA);
	public static var MASK(default,never) = new BlendMode(GL.FUNC_ADD, GL.ZERO, GL.SRC_ALPHA);
	public static var BELOW(default,never) = new BlendMode(GL.FUNC_ADD, GL.ONE_MINUS_DST_ALPHA, GL.DST_ALPHA);

	public static var NOPREMULT_NONE(default,never) = new BlendMode(GL.FUNC_ADD, GL.ONE, GL.ZERO);
	public static var NOPREMULT_NORMAL(default,never) = new BlendMode(GL.FUNC_ADD, GL.SRC_ALPHA, GL.ONE_MINUS_SRC_ALPHA);
	public static var NOPREMULT_ADD(default,never) = new BlendMode(GL.FUNC_ADD, GL.SRC_ALPHA, GL.DST_ALPHA);
	public static var NOPREMULT_MULTIPLY(default,never) = new BlendMode(GL.FUNC_ADD, GL.DST_COLOR, GL.ONE_MINUS_SRC_ALPHA);
	public static var NOPREMULT_SCREEN(default,never) = new BlendMode(GL.FUNC_ADD, GL.SRC_ALPHA, GL.ONE);
	public static var NOPREMULT_SUBTRACT(default,never) = new BlendMode(GL.FUNC_REVERSE_SUBTRACT, GL.ONE, GL.ONE);
	public static var NOPREMULT_ERASE(default,never) = new BlendMode(GL.FUNC_ADD, GL.ZERO, GL.ONE_MINUS_SRC_ALPHA);
	public static var NOPREMULT_MASK(default,never) = new BlendMode(GL.FUNC_ADD, GL.ZERO, GL.SRC_ALPHA);
	public static var NOPREMULT_BELOW(default,never) = new BlendMode(GL.FUNC_ADD, GL.ONE_MINUS_DST_ALPHA, GL.DST_ALPHA);
	
	var equation:Int;
	var sFactor:Int;
	var dFactor:Int;
	
	function new(equation, sFactor, dFactor) {
		this.equation = equation;
		this.sFactor = sFactor;
		this.dFactor = dFactor;
	}
	
	public inline function apply(gl:GLRenderContext) {
		gl.blendEquation(equation);
		gl.blendFunc(sFactor, dFactor);
	}
	
	public static function fromOpenFLBlendMode(blendMode:OpenFLBlendMode):BlendMode {
		return switch blendMode {
			case OpenFLBlendMode.ADD: ADD;
			case OpenFLBlendMode.MULTIPLY: MULTIPLY;
			case OpenFLBlendMode.SCREEN: SCREEN;
			case OpenFLBlendMode.SUBTRACT: SUBTRACT;
			case _: NORMAL;
		}
	}
}
