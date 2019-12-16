package openfl._internal.renderer.opengl.utils;

import lime.graphics.opengl.GL;

@SuppressWarnings("checkstyle:FieldDocComment")
@:enum abstract ElementType(Int) from Int to Int
{
	public var BYTE = GL.BYTE;
	public var UNSIGNED_BYTE = GL.UNSIGNED_BYTE;
	public var SHORT = GL.SHORT;
	public var UNSIGNED_SHORT = GL.UNSIGNED_SHORT;
	public var FLOAT = GL.FLOAT;
}
