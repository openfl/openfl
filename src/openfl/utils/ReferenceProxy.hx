package openfl.utils;
#if cpp
class ReferenceProxy<T> 
{
	var isWeak:Bool;
	var strongRef:T;
	var weakRef:cpp.vm.WeakRef<T>;

	public function new(inObject:T, useWeakRefrence:Bool) 
	{
		isWeak = useWeakRefrence;
		
		if (isWeak)
			weakRef = new cpp.vm.WeakRef(inObject);
		else
			strongRef = inObject;
	}

	public function get():T 
	{
		return isWeak ? weakRef.get() : strongRef;
	}

}
#else
//Weak refrences currently only supported for cpp target
class ReferenceProxy<T> 
{
	var ref:T;

	public function new(inObject:T, useWeakRefrence:Bool) 
	{
		ref = inObject;
	}

	public function get():T 
	{
		return ref;
	}
}
#end
