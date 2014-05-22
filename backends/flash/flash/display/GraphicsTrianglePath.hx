package flash.display;

/*
 It was not possible to override flash.Vector with a smarter abstract type, since this is 
 baked into genswf9.ml. Instead, we'll set classes that use flash.Vector to reference
 openfl.Vector instead.
*/

@:final extern class GraphicsTrianglePath implements IGraphicsData implements IGraphicsPath {
	var culling : TriangleCulling;
	var indices : openfl.Vector<Int>;
	var uvtData : openfl.Vector<Float>;
	var vertices : openfl.Vector<Float>;
	function new(?vertices : openfl.Vector<Float>, ?indices : openfl.Vector<Int>, ?uvtData : openfl.Vector<Float>, ?culling : TriangleCulling) : Void;
}
