package events;

import openfl.events.HTTPStatusEvent;

/**
 * The interface for HTTP Status events.
 */
interface IHTTPStatus 
{
	
	/**
	 * The function called when a response is received by the HTTP status
	 * request. This is called before actual response data is received.
	 */
	public var statusResponse:HTTPStatusEvent -> Void;
	
	/**
	 * The function called when data is received by a HTTP status request.
	 */
	public var status:HTTPStatusEvent -> Void;
	
}