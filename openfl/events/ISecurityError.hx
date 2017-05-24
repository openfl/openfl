package events;

import openfl.events.SecurityErrorEvent;

/**
 * The interface for Security Error events.
 */
interface ISecurityError 
{
	/**
	 * The function called when a security-related error is thrown.
	 */
	public var securityError:SecurityErrorEvent -> Void;
  
}