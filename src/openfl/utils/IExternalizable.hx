package openfl.utils;

#if !flash
/**
	The IExternalizable interface provides control over serialization of a class as it is
	encoded into a data stream. The `writeExternal()` and `readExternal()` methods of the
	IExternalizable interface are implemented by a class to allow customization of the
	contents and format of the data stream (but not the classname or type) for an object
	and its supertypes. Each individual class must serialize and reconstruct the state of
	its instances. These methods must be symmetrical with the supertype to save its state.
	These methods supercede the native Action Message Format (AMF) serialization behavior.

	If a class does not implement, nor inherits from a class which implements, the
	IExternalizable interface, then an instance of the class will be serialized using the
	default mechanism of public members only. As a result, private, internal, and protected
	members of a class will not be available.

	To serialize private members, a class must use the IExternalizable interface. For
	example, the following class will not serialize any of its members because they are
	private:

	```haxe
	class Example {

		private var one:Int;
		private var two:Int;
	}
	```

	However, if you implement the IExternalizable interface, you can write to, and read
	from, the data stream the private members of the class as follows:

	```haxe
	class Example implement IExternalizable {

		private var one:Int;
		private var two:Int;

		public function writeExternal(output:IDataOutput):Void {

			output.writeInt(one);
			output.writeInt(two);
		}

		public function readExternal(input:IDataInput):Void {

			one = input.readInt();
			two = input.readInt();
		}
	}
	```

	**Note:** If a class implements IExternalizable the default serialization no longer
	applies to instances of that class. If that class inherits public members from a super
	class, you must carefully manage those members as well.

	When a subclass of a class implementing IExternalizable has private members of its own,
	the subclass must override the methods of IExternalizable, as follows:

	```haxe
	class Base implements IExternalizable {

		private var one:Boolean;

		public function writeExternal(output:IDataOutput):Void {

			output.writeBoolean(one);
		}

		public function readExternal(input:IDataInput):Void {

			one = input.readBoolean();
		}
	}

	class Example extends Base {

		private var one:String;


		public override function writeExternal(output:IDataOutput):Void {

			super.writeExternal(output);
			output.writeUTF(one);
		}

		public override function readExternal(input:IDataInput):Void {

			super.readExternal(input);
			one = input.readUTF();
		}
	}
	```

	The IExternalizable interface can also be used to compress data before writing it to a
	data stream. For example:

	```haxe
	class Example implements IExternalizable {

		public var one:Bool;
		public var two:Bool;
		public var three:Bool;
		public var four:Bool;
		public var five:Bool;
		public var six:Bool;
		public var seven:Bool;
		public var eight:Bool;

		public function writeExternal(output:IDataOutput):Void {

			var flag:Int = 0;

			if (one) flag |= 1;
			if (two) flag |= 2;
			if (three) flag |= 4;
			if (four) flag |= 8;
			if (five) flag |= 16;
			if (six) flag |= 32;
			if (seven) flag |= 64;
			if (eight) flag |= 128;

			output.writeByte(flag);
		}

		public function readExternal(input:IDataInput):Void {

			var flag:Int = input.readByte();

			one = (flag & 1) != 0;
			two = (flag & 2) != 0;
			three = (flag & 4) != 0;
			four = (flag & 8) != 0;
			five = (flag & 16) != 0;
			six = (flag & 32) != 0;
			seven = (flag & 64) != 0;
			eight = (flag & 128) != 0;
		}
	}
	```
**/
interface IExternalizable
{
	/**
		A class implements this method to decode itself from a data stream by calling the
		methods of the IDataInput interface. This method must read the values in the same
		sequence and with the same types as were written by the `writeExternal()` method.

		@param	input	The name of the class that implements the IDataInput interface.
	**/
	public function readExternal(input:IDataInput):Void;

	/**
		A class implements this method to encode itself for a data stream by calling the
		methods of the IDataOutput interface.

		@param	output	The name of the class that implements the IDataOutput interface.
	**/
	public function writeExternal(output:IDataOutput):Void;
}
#else
typedef IExternalizable = flash.utils.IExternalizable;
#end
