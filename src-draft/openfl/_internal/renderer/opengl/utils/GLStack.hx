package openfl._internal.renderer.opengl.utils;

import openfl.display3D.Context3D;

@SuppressWarnings("checkstyle:FieldDocComment")
class GLStack
{
	public var lastIndex:Int = 0;
	public var buckets:Array<GLBucket>;
	public var context3D:Context3D;

	public function new(context3D:Context3D)
	{
		this.context3D = context3D;
		buckets = [];
		lastIndex = 0;
	}

	public function reset():Void
	{
		buckets = [];
		lastIndex = 0;
	}

	public function upload():Void
	{
		for (bucket in buckets)
		{
			if (bucket.dirty)
			{
				bucket.upload();
			}
		}
	}
}
