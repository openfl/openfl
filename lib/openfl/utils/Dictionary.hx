package openfl.utils;

abstract Dictionary<K, V>(Dynamic)
{
	public function new(weakKeys:Bool = false)
	{
		this = {};
	}

	public inline function exists(key:K):Bool
	{
		return Reflect.hasField(this, cast key);
	}

	@:arrayAccess public inline function get(key:K):V
	{
		return Reflect.field(this, cast key);
	}

	public inline function remove(key:K):Bool
	{
		if (Reflect.hasField(this, cast key))
		{
			Reflect.deleteField(this, cast key);
			return true;
		}

		return false;
	}

	@:arrayAccess public inline function set(key:K, value:V):V
	{
		Reflect.setField(this, cast key, value);
		return value;
	}

	public inline function iterator():Iterator<K>
	{
		var fields = Reflect.fields(this);
		if (fields != null) return cast fields.iterator();
		return null;
	}

	public inline function each():Iterator<V>
	{
		var values = [];

		for (field in Reflect.fields(this))
		{
			values.push(Reflect.field(this, field));
		}

		return values.iterator();
	}
}
