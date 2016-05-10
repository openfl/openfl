package openfl.media; #if (display || !flash)

/**
 * ...
 * @author P.J.Shand
 */
class VideoStatus
{

	public function new() 
	{
		
	}
	
}

#else
typedef StageVideoAvailabilityReason = flash.media.StageVideoAvailabilityReason;
#end