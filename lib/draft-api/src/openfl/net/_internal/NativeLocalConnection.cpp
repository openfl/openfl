#include <Windows.h>
#include <iostream>
#include <thread>

extern "C" HANDLE native_createInboundPipe(const char* name)
{
	std::string pipeName = std::string("\\\\.\\pipe\\") + name;

	HANDLE hPipe = CreateNamedPipeA(
					   pipeName.c_str(),
					   PIPE_ACCESS_DUPLEX,
					   PIPE_TYPE_MESSAGE | PIPE_READMODE_MESSAGE | PIPE_NOWAIT,
					   PIPE_UNLIMITED_INSTANCES,
					   4096, 4096, 0, NULL
				   );

	if (hPipe == INVALID_HANDLE_VALUE)
	{
		//std::cerr << "Failed to create Inbound pipe. Error: " << GetLastError() << "\n";
		return NULL;
	}

	//std::cout << "Inbound pipe created (Message Mode, Non-Blocking): " << pipeName << std::endl;
	return hPipe;
}

extern "C" bool native_accept(HANDLE hPipe)
{
    if (hPipe == NULL) return false;


    BOOL success = ConnectNamedPipe(hPipe, NULL);
    DWORD error = GetLastError();

    if (success || error == ERROR_PIPE_CONNECTED)
    {
        //std::cout << "Client connected!\n";
        return true; //connection accepted, we will handle new pipe creation on the haxe side
    }

    if (error == ERROR_IO_PENDING)
    {
        //std::cout << "Client connection pending...\n";
        return false; // Still waiting, should check again later on the haxe side?
    }

    return false;
}

extern "C" int native_read(HANDLE hPipe, unsigned char* buffer, int bufferSize)
{
	if (hPipe == NULL) return false;

	DWORD bytesRead;
	if (!ReadFile(hPipe, buffer, bufferSize, &bytesRead, NULL))
	{
		int errCode = GetLastError();
		
		if(errCode == 234){
			return 0;
		}
		
		return errCode;
	}
	
	return 0;
}

extern "C" bool native_write(void* hPipe, const unsigned char* buffer, int bufferSize)
{
	if (hPipe == NULL || buffer == NULL || bufferSize <= 0) return false;

	DWORD bytesWritten;
	if (!WriteFile((HANDLE)hPipe, buffer, bufferSize, &bytesWritten, NULL))
	{
		// std::cerr << "WriteFile failed. Error: " << GetLastError() << "\n";
		return false;
	}

	return bytesWritten == bufferSize;
}

// Close the named pipe
extern "C" void native_close(void* hPipe)
{
	if (hPipe == NULL) return;

	//std::cout << "Closing named pipe...\n";
	CloseHandle((HANDLE)hPipe);
}

extern "C" HANDLE native_connect(const char* pipeName)
{
    std::string fullPipeName = std::string("\\\\.\\pipe\\") + pipeName;

    //std::cout << "Attempting to connect to pipe: " << fullPipeName << "...\n";

    HANDLE hPipe;
	// Number of retry attempts
    int retries = 5; 

    while (retries-- > 0)
    {
        hPipe = CreateFileA(
            fullPipeName.c_str(),
            GENERIC_READ | GENERIC_WRITE, // Allow reading and writing
            0, // No sharing
            NULL, // default security
            OPEN_EXISTING, //Connects to an existing pipe
            0, // Default attributes
            NULL // No template?
        );

        if (hPipe != INVALID_HANDLE_VALUE)
        {
            //std::cout << "Successfully connected to named pipe!\n";
            return hPipe;
        }

        DWORD error = GetLastError();
        //std::cerr << "Failed to connect to named pipe. Error: " << error << "\n";

        if (error == ERROR_PIPE_BUSY)
        {
            //std::cout << "Pipe is busy, waiting...\n";
            if (!WaitNamedPipeA(fullPipeName.c_str(), 500))
            {
                //std::cerr << "WaitNamedPipe failed. Error: " << GetLastError() << "\n";
            }
        }
        else if (error == ERROR_FILE_NOT_FOUND)
        {
            //std::cerr << "Named pipe does not exist. Make sure the server is running.\n";
			// Wait a bit before retrying. Should this be more or less?
            Sleep(500); 
        }
        else
        {
           // std::cerr << "Unexpected error. Exiting.\n";
            return NULL;
        }
    }

    //std::cerr << "Failed to connect after multiple attempts.\n";
    return NULL;
}

extern "C" int native_getBytesAvailable(HANDLE hPipe)
{
	DWORD bytesAvailable;
	if (PeekNamedPipe(hPipe, NULL, 0, NULL, &bytesAvailable, NULL))
	{
		return bytesAvailable;
	}
	// If no data available
	return 0; 
}

extern "C" bool native_isOpen(HANDLE hPipe)
{
	DWORD bytesAvailable;
	if (!PeekNamedPipe(hPipe, NULL, 0, NULL, &bytesAvailable, NULL))
	{
		if (GetLastError() == ERROR_BROKEN_PIPE)
		{
			// Pipe is closed
			return false; 
		}
	}
	// Pipe is still open
	return true; 
}