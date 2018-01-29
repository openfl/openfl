package format.swf.tags.etc;

import format.swf.tags.ITag;
import format.swf.tags.TagUnknown;

class TagSWFEncryptActions extends TagUnknown implements ITag
{
	public static inline var TYPE:Int = 253;
	
	public function new(type:Int = 0) {
		
		super ();
		
		this.type = TYPE;
		name = "SWFEncryptActions";
		
	}
	
}