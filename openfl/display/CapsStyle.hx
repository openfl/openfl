package openfl.display; #if (!display && !flash) #if !openfl_legacy


enum CapsStyle {
	
	NONE;
	ROUND;
	SQUARE;
	
}


#else
typedef CapsStyle = openfl._legacy.display.CapsStyle;
#end
#else


/**
 * The CapsStyle class is an enumeration of constant values that specify the
 * caps style to use in drawing lines. The constants are provided for use as
 * values in the <code>caps</code> parameter of the
 * <code>openfl.display.Graphics.lineStyle()</code> method. You can specify the
 * following three types of caps:
 */

#if flash
@:native("flash.display.CapsStyle")
#end

@:fakeEnum(String) extern enum CapsStyle {
	
	/**
	 * Used to specify no caps in the <code>caps</code> parameter of the
	 * <code>openfl.display.Graphics.lineStyle()</code> method.
	 */
	NONE;
	
	/**
	 * Used to specify round caps in the <code>caps</code> parameter of the
	 * <code>openfl.display.Graphics.lineStyle()</code> method.
	 */
	ROUND;
	
	/**
	 * Used to specify square caps in the <code>caps</code> parameter of the
	 * <code>openfl.display.Graphics.lineStyle()</code> method.
	 */
	SQUARE;
	
}


#end