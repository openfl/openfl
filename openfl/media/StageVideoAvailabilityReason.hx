package openfl.media; #if (display || !flash)

/**
 * ...
 * @author P.J.Shand
 */
class StageVideoAvailabilityReason
{

	public function new() 
	{
		
	}
	
}

#else
typedef StageVideoAvailabilityReason = flash.media.StageVideoAvailabilityReason;
#end