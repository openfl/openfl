package;

import openfl.events.Event;
#if (sys || air)
import openfl.events.ProgressEvent;
import openfl.events.ServerSocketConnectEvent;
import openfl.net.ServerSocket;
import openfl.net.Socket;
#end
import utest.Assert;
import utest.Async;
import utest.Test;

class ServerSocketTest extends Test
{
	#if (sys || air)
	private var serverSocket:ServerSocket;
	private var clientSocket:Socket;

	public function teardown()
	{
		if (clientSocket != null && clientSocket.connected)
		{
			clientSocket.close();
		}
		clientSocket = null;
		if (serverSocket != null && serverSocket.bound)
		{
			serverSocket.close();
		}
		serverSocket = null;
	}

	public function test_bind():Void
	{
		serverSocket = new ServerSocket();
		Assert.isFalse(serverSocket.bound);
		serverSocket.bind();
		Assert.isTrue(serverSocket.bound);
		Assert.notNull(serverSocket.localAddress);
		Assert.isTrue(serverSocket.localAddress.length > 0);
		Assert.isTrue(serverSocket.localPort > 0);
		serverSocket.close();
		Assert.isFalse(serverSocket.bound);
	}

	public function test_listen():Void
	{
		serverSocket = new ServerSocket();
		Assert.isFalse(serverSocket.bound);
		serverSocket.bind();
		Assert.isTrue(serverSocket.bound);
		Assert.notNull(serverSocket.localAddress);
		Assert.isTrue(serverSocket.localAddress.length > 0);
		Assert.isTrue(serverSocket.localPort > 0);
		serverSocket.listen();
		serverSocket.close();
		Assert.isFalse(serverSocket.bound);
	}

	@:timeout(5000)
	public function test_connect(async:Async):Void
	{
		var serverConnected = false;
		var clientConnected = false;
		serverSocket = new ServerSocket();
		Assert.isFalse(serverSocket.bound);
		#if air
		serverSocket.bind(0, "127.0.0.1");
		#else
		serverSocket.bind();
		#end
		Assert.isTrue(serverSocket.bound);
		serverSocket.addEventListener(ServerSocketConnectEvent.CONNECT, function(event:ServerSocketConnectEvent):Void
		{
			var serverClientSocket = event.socket;
			if (async.timedOut)
			{
				return;
			}
			Assert.notNull(serverClientSocket);
			Assert.isTrue(serverClientSocket.connected);
			serverConnected = true;
			if (serverConnected && clientConnected)
			{
				serverClientSocket.close();
				serverSocket.close();
				Assert.isFalse(serverSocket.bound);
				async.done();
			}
		});
		serverSocket.listen();
		var clientSocket = new Socket();
		clientSocket.addEventListener(Event.CONNECT, function(event:Event):Void
		{
			if (async.timedOut)
			{
				return;
			}
			Assert.isTrue(clientSocket.connected);
			clientConnected = true;
			if (serverConnected && clientConnected)
			{
				clientSocket.close();
				serverSocket.close();
				async.done();
			}
		});
		Assert.isFalse(clientSocket.connected);
		clientSocket.connect(serverSocket.localAddress, serverSocket.localPort);
	}

	@:timeout(5000)
	public function test_sendDataToClient(async:Async):Void
	{
		serverSocket = new ServerSocket();
		Assert.isFalse(serverSocket.bound);
		#if air
		serverSocket.bind(0, "127.0.0.1");
		#else
		serverSocket.bind();
		#end
		Assert.isTrue(serverSocket.bound);
		serverSocket.addEventListener(ServerSocketConnectEvent.CONNECT, function(event:ServerSocketConnectEvent):Void
		{
			if (async.timedOut)
			{
				return;
			}
			var serverClientSocket = event.socket;
			Assert.notNull(serverClientSocket);
			Assert.isTrue(serverClientSocket.connected);
			serverClientSocket.writeUTFBytes("PING\r\n");
		});
		serverSocket.listen();
		var loadedData = "";
		var clientSocket = new Socket();
		clientSocket.addEventListener(ProgressEvent.SOCKET_DATA, function(event:ProgressEvent):Void
		{
			if (async.timedOut)
			{
				return;
			}
			loadedData += clientSocket.readUTFBytes(Std.int(event.bytesLoaded));
			if (loadedData == "PING\r\n")
			{
				clientSocket.close();
				Assert.isFalse(clientSocket.connected);
				serverSocket.close();
				Assert.isFalse(serverSocket.bound);
				async.done();
			}
		});
		Assert.isFalse(clientSocket.connected);
		clientSocket.connect(serverSocket.localAddress, serverSocket.localPort);
	}

	@:timeout(5000)
	public function test_sendDataToServer(async:Async):Void
	{
		serverSocket = new ServerSocket();
		Assert.isFalse(serverSocket.bound);
		#if air
		serverSocket.bind(0, "127.0.0.1");
		#else
		serverSocket.bind();
		#end
		Assert.isTrue(serverSocket.bound);
		serverSocket.addEventListener(ServerSocketConnectEvent.CONNECT, function(event:ServerSocketConnectEvent):Void
		{
			if (async.timedOut)
			{
				return;
			}
			var serverClientSocket = event.socket;
			Assert.notNull(serverClientSocket);
			Assert.isTrue(serverClientSocket.connected);
			var loadedData = "";
			serverClientSocket.addEventListener(ProgressEvent.SOCKET_DATA, function(event:ProgressEvent):Void
			{
				if (async.timedOut)
				{
					return;
				}
				loadedData += serverClientSocket.readUTFBytes(Std.int(event.bytesLoaded));
				if (loadedData == "PING\r\n")
				{
					serverClientSocket.close();
					Assert.isFalse(serverClientSocket.connected);
					serverSocket.close();
					Assert.isFalse(serverSocket.bound);
					async.done();
				}
			});
		});
		serverSocket.listen();
		var clientSocket = new Socket();
		clientSocket.addEventListener(Event.CONNECT, function(event:Event):Void
		{
			if (async.timedOut)
			{
				return;
			}
			Assert.isTrue(clientSocket.connected);
			clientSocket.writeUTFBytes("PING\r\n");
		});
		Assert.isFalse(clientSocket.connected);
		clientSocket.connect(serverSocket.localAddress, serverSocket.localPort);
	}
	#else
	public function test_test()
	{
		Assert.pass();
	}
	#end
}
