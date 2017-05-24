package events;

import openfl.events.DataEvent;

/**
 * The interface for Data events.
 */
interface IData 
{
	/**
	 * The function called when data is downloading.
	 */
	public var data:DataEvent -> Void;
	
	/**
	 * The function called when data has completed uploading.
	 */
	public var uploadCompleteData:DataEvent -> Void;
}