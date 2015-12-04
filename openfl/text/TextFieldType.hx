package openfl.text; #if (!display && !flash)


enum TextFieldType {
	
	DYNAMIC;
	INPUT;
	
}


#else


/**
 * The TextFieldType class is an enumeration of constant values used in
 * setting the <code>type</code> property of the TextField class.
 */

#if flash
@:native("flash.text.TextFieldType")
#end

@:fakeEnum(String) extern enum TextFieldType {
	
	/**
	 * Used to specify a <code>dynamic</code> TextField.
	 */
	DYNAMIC;
	
	/**
	 * Used to specify an <code>input</code> TextField.
	 */
	INPUT;
	
}


#end