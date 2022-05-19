## General Idea of this [Video](https://www.youtube.com/watch?v=19fFbDmvleE)
1. Create two actor for two MotionController (Do know what is a [motion controller](https://en.wikipedia.org/wiki/PlayStation_Move)?)
2. Create a Pawn, and attach two MotionController and CameraComponent to it.
### Actor MotionController
1. Need USkeletalMeshComponent to display hand mesh (attach it to the actor)
2. Need UMotionControllerComponent to track contoller
3. In actor's tick, attach the ControllerComponent to root AS the LeftController or RightController accoring to how the actor would be used. Different use, different orientation upon attachment.
### Pawn of Player
1. SceneComponent as playerPawn's Root
2. Attach a CameraComponent to the Root
3. Spawn a MotionControllerActor, owned by the playerPawn, attached to the Root, and set MotionControllerActor's varible hand as Left.
4. Do the same thing but get a new Right hand MotionControllerActor.
