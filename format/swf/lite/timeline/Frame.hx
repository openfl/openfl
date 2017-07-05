package format.swf.lite.timeline;


@:keep class Frame implements hxbit.Serializable {


	@:s public var label:String;
	@:s public var objects:Array <FrameObject>;


	public function new () {

		objects = new Array <FrameObject> ();

	}


}