package openfl.net; #if !flash


@:fakeEnum(String) enum SharedObjectFlushStatus {
	
	FLUSHED;
	PENDING;
	
}


#else
typedef SharedObjectFlushStatus = flash.net.SharedObjectFlushStatus;
#end