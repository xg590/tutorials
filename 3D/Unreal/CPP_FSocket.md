```cpp  
#include "Runtime/Networking/Public/Networking.h"
#include "Runtime/Sockets/Public/Sockets.h"
#include "Runtime/Sockets/Public/SocketSubsystem.h"  

// Called when the game starts or when spawned
void APawn::BeginPlay() { 
	{ // Networking 
		FIPv4Address IPAddress;
		FIPv4Address::Parse(FString("192.168.12.34"), IPAddress);
		TSharedRef<FInternetAddr> addr = ISocketSubsystem::Get(PLATFORM_SOCKETSUBSYSTEM)->CreateInternetAddr();
		addr->SetIp(IPAddress.Value);
		addr->SetPort(12345);

		sock = ISocketSubsystem::Get(PLATFORM_SOCKETSUBSYSTEM)->CreateSocket(NAME_Stream, TEXT("xg590"), false);

		bool connected = sock->Connect(*addr);   
    
    FString msg = "123456\n";
	  TCHAR* msgInChar = msg.GetCharArray().GetData();
	  uint8 msgSize = FCString::Strlen(msgInChar);
	  int32 sent = 0;
	   
	  bool successful = sock->Send((uint8*)TCHAR_TO_ANSI(msgInChar), msgSize, sent);  
	}   
}
```
