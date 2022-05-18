### A Minimal C++ Game
1. Create a blank C++ Game project with no Starter Content
2. Get into an empty level (world) with a floor (static mesh), a sky sphere (blueprint), and other things (like player start) in your world outliner. 
3. Create a new C++ class called MyCharacter which inherits Class Character. 
3. Delete player start and add our MyCharacter on our floor.
4. Choose player_0 in MyCharacter's detail so MyCharacter will auto-possess it.
5. Since we written zero code, we can not do anything if we play the game. 
6. At this moment, MyCharacter responses to no input.
7. Save current level
### Cannot move with keyboard or change view with mouse? Add Input Methods to MyCharacter
1. Click the level we saved
2. In project settings, add action mapping and axis mapping.
3. Let's choose player_0 in MyCharacter's detail so MyCharacter will auto-receive input.
4. Edit MyCharacter.cpp and MyCharacter.h (My Project name is "MyProject" be careful about MYPROJECT_API)
* Whole MyCharacter.h
```cpp 
#pragma once

#include "CoreMinimal.h"
#include "GameFramework/Character.h"
#include "MyCharacter.generated.h"

class UInputComponent;
class UCameraComponent;

UCLASS()
class MYPROJECT_API AMyCharacter : public ACharacter // MYPROJECT_API is project name plus API
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
* Whole MyCharacter.cpp
```cpp
// 
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
5. Now you can jump and move view
