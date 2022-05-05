package openfl.net;

#if !flash
/**
	This interface is used with the `IDynamicPropertyOutput` interface to
	control the serialization of dynamic properties of dynamic objects. To use
	this interface, assign an object that implements the
	`IDynamicPropertyWriter` interface to the
	`ObjectEncoding.dynamicPropertyWriter` property.
**/
interface IDynamicPropertyWriter
{
	/**
		Writes the name and value of an `IDynamicPropertyOutput` object to an
		object with dynamic properties. If
		`ObjectEncoding.dynamicPropertyWriter` is set, this method is invoked
		for each object with dynamic properties.

		@param obj The object to write to.
		@param output The `IDynamicPropertyOutput` object that contains the name
			and value to dynamically write to the object.
	**/
	function writeDynamicProperties(obj:Dynamic, output:IDynamicPropertyOutput):Void;
}
#else
typedef IDynamicPropertyWriter = flash.net.IDynamicPropertyWriter;
#end
