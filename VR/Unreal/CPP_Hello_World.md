Before you try the C++ Hello World, I recommend this introduction [video](https://www.youtube.com/watch?v=p5Rp500kbOc) for knowing what C++ Programming is in Unreal Engine.
## [C++ Hello World](https://www.youtube.com/watch?v=19fFbDmvleE)
### Summary 
1. Create two actors for two MotionControllers ([what is MotionController](https://en.wikipedia.org/wiki/PlayStation_Move))
2. Create a Pawn.
3. Attach two MotionControllers and a CameraComponent to it.
### A Minimalistic C++ Game with Unreal Engine 5.0.3
1. Create a blank C++ Game project (name it as "helloWorld") with no Starter Content.
2. Get an empty world (called "level" in UE). 
3. Create a new C++ class called MyCharacter which inherits the Character Class.
4. Add our MyCharacter to our floor.
5. Change MyCharacter's attribute (Pawn -> Auto Prosseses Player) from Disabled to player_0 so we can spawn in the current level.
6. We have written zero code so we can not do anything (cannot move with keyboard or change view with mouse) in the level. But we can save the level and enter the game at least. 
### Add Input Methods to MyCharacter
1. Click the level we saved
2. In project settings, add action mapping and axis mapping.
3. Let's choose player_0 in MyCharacter's detail so MyCharacter will auto-receive input.
4. Edit MyCharacter.cpp and MyCharacter.h (My Project name is "MyProject" be careful about MYPROJECT_API) 
* MyCharacter.cpp
```cpp
#include "MyCharacter.h"
#include "Camera/CameraComponent.h"
#include "Components/CapsuleComponent.h"
#include "Components/InputComponent.h" 

AMyCharacter::AMyCharacter()
{
	Camera = CreateDefaultSubobject<UCameraComponent>(TEXT("FirstPersonCamera"));
	Camera->SetupAttachment(GetCapsuleComponent());
	Camera->bUsePawnControlRotation = true;
}

void AMyCharacter::BeginPlay()
{
	Super::BeginPlay();
}

void AMyCharacter::SetupPlayerInputComponent(UInputComponent* PlayerInputComponent)
{
	Super::SetupPlayerInputComponent(PlayerInputComponent);
	PlayerInputComponent->BindAction("Jump", IE_Pressed, this, &ACharacter::Jump);
	PlayerInputComponent->BindAction("Jump", IE_Released, this, &ACharacter::StopJumping);
	PlayerInputComponent->BindAxis("Turn", this, &APawn::AddControllerYawInput);
	PlayerInputComponent->BindAxis("LookUp", this, &APawn::AddControllerPitchInput);
}
```
* MyCharacter.h 
```cpp
#pragma once

#include "CoreMinimal.h"
#include "GameFramework/Character.h"
#include "MyCharacter.generated.h"

class UInputComponent;
class UCameraComponent;

UCLASS()
class HELLOWORLD_API AMyCharacter : public ACharacter // HELLOWORLD_API is project name plus API
{
    GENERATED_BODY()
    UPROPERTY(VisibleAnywhere)
		UCameraComponent* Camera;

public:
	AMyCharacter();

protected:
	virtual void BeginPlay();

	virtual void SetupPlayerInputComponent(class UInputComponent* PlayerInputComponent) override;

};
```
### Actor MotionController
1. Need USkeletalMeshComponent to display hand mesh (attach it to the actor)
2. Need UMotionControllerComponent to track contoller
3. In actor's tick, attach the ControllerComponent to root AS the LeftController or RightController accoring to how the actor would be used. Different use, different orientation upon attachment.
### Pawn of Player
1. SceneComponent as playerPawn's Root
2. Attach a CameraComponent to the Root
3. Spawn a MotionControllerActor, owned by the playerPawn, attached to the Root, and set MotionControllerActor's varible hand as Left.
4. Do the same thing but get a new Right hand MotionControllerActor.


5. Now you can jump and move view
