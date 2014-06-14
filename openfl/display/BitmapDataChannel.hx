package openfl.display; #if !flash


class BitmapDataChannel {
	
   public static inline var ALPHA = 8;
   public static inline var BLUE = 4;
   public static inline var GREEN = 2;
   public static inline var RED = 1;
   
}


#else
typedef BitmapDataChannel = flash.display.BitmapDataChannel;
#end