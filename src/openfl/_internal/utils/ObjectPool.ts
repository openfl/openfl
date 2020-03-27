export default class ObjectPool<T>
{
	public activeObjects: number;
	public inactiveObjects: number;

	protected __inactiveObject0: T;
	protected __inactiveObject1: T;
	protected __inactiveObjectList: Array<T>;
	protected __pool: Map<T, boolean>;
	protected __size: null | number;

	public constructor(create: () => T = null, clean: (object: T) => void = null, size: null | number = null)
	{
		this.__pool = new Map();

		this.activeObjects = 0;
		this.inactiveObjects = 0;

		this.__inactiveObject0 = null;
		this.__inactiveObject1 = null;
		this.__inactiveObjectList = new Array<T>();

		if (create != null)
		{
			this.create = create;
		}
		if (clean != null)
		{
			this.clean = clean;
		}
		if (size != null)
		{
			this.size = size;
		}
	}

	public add(object: T): void
	{
		if (!this.__pool.has(object))
		{
			this.__pool.set(object, false);
			this.clean(object);
			this.__addInactive(object);
		}
	}

	public clean(object: T): void { }

	public clear(): void
	{
		this.__pool = new Map();

		this.activeObjects = 0;
		this.inactiveObjects = 0;

		this.__inactiveObject0 = null;
		this.__inactiveObject1 = null;
		this.__inactiveObjectList.length = 0;
	}

	public create(): T
	{
		return null;
	}

	public get(): T
	{
		var object = null;

		if (this.inactiveObjects > 0)
		{
			object = this.__getInactive();
		}
		else if (this.__size == null || this.activeObjects < this.__size)
		{
			object = this.create();

			if (object != null)
			{
				this.__pool.set(object, true);
				this.activeObjects++;
			}
		}

		return object;
	}

	public release(object: T): void
	{
		this.activeObjects--;

		if (this.__size == null || this.activeObjects + this.inactiveObjects < this.__size)
		{
			this.clean(object);
			this.__addInactive(object);
		}
		else
		{
			this.__pool.delete(object);
		}
	}

	public remove(object: T): void
	{
		if (this.__pool.has(object))
		{
			this.__pool.delete(object);

			if (this.__inactiveObject0 == object)
			{
				this.__inactiveObject0 = null;
				this.inactiveObjects--;
			}
			else if (this.__inactiveObject1 == object)
			{
				this.__inactiveObject1 = null;
				this.inactiveObjects--;
			}
			else if (this.__inactiveObjectList.indexOf(object) > -1)
			{
				this.__inactiveObjectList.splice(this.__inactiveObjectList.indexOf(object), 1);
				this.inactiveObjects--;
			}
			else
			{
				this.activeObjects--;
			}
		}
	}

	protected __addInactive(object: T): void
	{
		if (this.__inactiveObject0 == null)
		{
			this.__inactiveObject0 = object;
		}
		else if (this.__inactiveObject1 == null)
		{
			this.__inactiveObject1 = object;
		}
		else
		{
			this.__inactiveObjectList.push(object);
		}

		this.inactiveObjects++;
	}

	protected __getInactive(): T
	{
		var object = null;

		if (this.__inactiveObject0 != null)
		{
			object = this.__inactiveObject0;
			this.__inactiveObject0 = null;
		}
		else if (this.__inactiveObject1 != null)
		{
			object = this.__inactiveObject1;
			this.__inactiveObject1 = null;
		}
		else
		{
			object = this.__inactiveObjectList.pop();

			if (this.__inactiveObjectList.length > 0)
			{
				this.__inactiveObject0 = this.__inactiveObjectList.pop();
			}

			if (this.__inactiveObjectList.length > 0)
			{
				this.__inactiveObject1 = this.__inactiveObjectList.pop();
			}
		}

		this.inactiveObjects--;
		this.activeObjects++;

		return object;
	}

	protected __removeInactive(count: number): void
	{
		if (count <= 0 || this.inactiveObjects == 0) return;

		if (this.__inactiveObject0 != null)
		{
			this.__pool.delete(this.__inactiveObject0);
			this.__inactiveObject0 = null;
			this.inactiveObjects--;
			count--;
		}

		if (count == 0 || this.inactiveObjects == 0) return;

		if (this.__inactiveObject1 != null)
		{
			this.__pool.delete(this.__inactiveObject1);
			this.__inactiveObject1 = null;
			this.inactiveObjects--;
			count--;
		}

		if (count == 0 || this.inactiveObjects == 0) return;

		for (let i = this.__inactiveObjectList.length - 1; i >= 0; i--)
		{
			this.__pool.delete(this.__inactiveObjectList[i]);
			this.__inactiveObjectList.length--;
			this.inactiveObjects--;
			count--;

			if (count == 0 || this.inactiveObjects == 0) return;
		}
	}

	// Get & Set Methods

	public get size(): null | number
	{
		return this.__size;
	}

	public set size(value: null | number)
	{
		if (value == null)
		{
			this.__size = null;
		}
		else
		{
			var current = this.inactiveObjects + this.activeObjects;
			this.__size = value;

			if (current > value)
			{
				this.__removeInactive(current - value);
			}
			else if (value > current)
			{
				var object;

				for (let i = 0; i < (value - current); i++)
				{
					object = this.create();

					if (object != null)
					{
						this.__pool.set(object, false);
						this.__inactiveObjectList.push(object);
						this.inactiveObjects++;
					}
					else
					{
						break;
					}
				}
			}
		}
	}
}
