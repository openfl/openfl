package;

import openfl.events.DatagramSocketDataEvent;
import openfl.net.DatagramSocket;
#if (sys || air)
import openfl.utils.ByteArray;
#end
import utest.Assert;
import utest.Async;
import utest.Test;

/**
 *  UDP unit-tests for openfl.net.DatagramSocket
 *  Requires a desktop/AIR target (`hl`, `neko`, `cpp`, `air`).
 */
class DatagramSocketTest extends Test
{
	#if (sys || air)
	var sockA:DatagramSocket; // “server” conceptually
	var sockB:DatagramSocket; // “client”

	/* ---------- helpers ---------- */
	inline function makeSocket():DatagramSocket
	{
		var s = new DatagramSocket();
		#if air
		s.bind(0, "127.0.0.1");
		#else
		s.bind(); // auto address/port
		#end
		s.receive(); // start listening immediately
		return s;
	}

	inline function close(s:DatagramSocket):Void
	{
		if (s != null && s.bound) s.close();
	}

	/* ---------- teardown ---------- */
	public function teardown()
	{
		close(sockA);
		close(sockB);
		sockA = sockB = null;
	}

	/* ---------- tests ---------- */
	public function test_bind()
	{
		sockA = makeSocket();
		Assert.isTrue(sockA.bound);
		Assert.notNull(sockA.localAddress);
		Assert.isTrue(sockA.localPort > 0);
		close(sockA);
		Assert.isFalse(sockA.bound);
	}

	@:timeout(3000)
	public function test_sendReceive(async:Async)
	{
		sockA = makeSocket();
		sockB = makeSocket();

		var payload = "PING";
		var bytes = new ByteArray();
		bytes.writeUTFBytes(payload);

		// B receives
		sockB.addEventListener(DatagramSocketDataEvent.DATA, function(e)
		{
			if (async.timedOut) return;

			Assert.equals(payload, e.data.toString());
			async.done();
		});

		sockA.send(bytes, 0, 0, sockB.localAddress, sockB.localPort);
	}

	@:timeout(3000)
	public function test_bidirectionalEcho(async:Async)
	{
		sockA = makeSocket();
		sockB = makeSocket();

		var aMsg = "HELLO";
		var bMsg = "WORLD";

		var aBytes = new ByteArray();
		aBytes.writeUTFBytes(aMsg);
		var bBytes = new ByteArray();
		bBytes.writeUTFBytes(bMsg);

		var gotA = false;
		var gotB = false;

		function check()
			if (gotA && gotB && !async.timedOut) async.done();

		sockA.addEventListener(DatagramSocketDataEvent.DATA, function(e)
		{
			if (async.timedOut) return;
			Assert.equals(bMsg, e.data.toString());
			gotA = true;
			check();
		});

		sockB.addEventListener(DatagramSocketDataEvent.DATA, function(e)
		{
			if (async.timedOut) return;
			Assert.equals(aMsg, e.data.toString());
			gotB = true;
			check();
		});

		sockA.send(aBytes, 0, 0, sockB.localAddress, sockB.localPort);
		sockB.send(bBytes, 0, 0, sockA.localAddress, sockA.localPort);
	}
	#else
	/*  Non-sys targets (html5, mobile) – DatagramSocket unavailable. */
	public function test_placeholder()
	{
		Assert.pass();
	}
	#end
}
