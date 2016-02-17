package openfl.media; #if (display || !flash)

/**
 * ...
 * @author P.J.Shand
 */
class StageVideoAvailability
{
	public static var AVAILABLE:String = "available";
	public static var UNAVAILABLE:String = "unavailable";
	
	public function new() 
	{
		
	}
	
}

#else
typedef StageVideoAvailability = flash.media.StageVideoAvailability;
#end