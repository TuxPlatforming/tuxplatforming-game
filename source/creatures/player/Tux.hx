package creatures.player;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;

class Tux extends FlxSprite
{
    // Movement
    var tuxAcceleration = 2000;
    var deceleration = 1600;
    var gravity = 1000;
    var minJumpHeight = 512;
    var maxJumpHeight = 576;
    var walkSpeed = 320;

    // Direction
    public var direction = 1;

    // Spritesheet
    var bigTuxImage = FlxAtlasFrames.fromSparrow("assets/images/characters/tux/tux.png", "assets/images/characters/tux/tux.xml");

    public function new()
    {
        super();

        // Spritesheet
        frames = bigTuxImage;
        animation.addByPrefix("stand", "stand", 10, false);
        animation.addByPrefix("walk", "walk", 10, true);
        animation.addByPrefix("jump", "jump", 10, false);
        animation.addByPrefix("duck", "duck", 10, false);
        animation.play("stand");
        
        // Hitbox
        setSize(24, 56);
        offset.set(9, 8);

        // Acceleration, deceleration and max velocity.
        drag.x = deceleration;
        acceleration.y = gravity;
        maxVelocity.x = walkSpeed;
    }

    override public function update(elapsed:Float)
    {
        // Stop Tux from falling off the map through the left
        if (x < 0)
        {
            x = 0;
        }

        // from my other game, don't uncomment until the function is added.
        // if (y > Global.PS.map.height - height)
        // {
        //    die();
        // }

        // Functions
        move();
        animate();

        // Put this after everything
        super.update(elapsed);
    }

    // Animate Tux
    function animate()
    {
        // If Tux is on the floor and staying where he is, do stand animation
        if (velocity.x == 0 && isTouching(FLOOR))
        {
            animation.play("stand");
        }
        
        // If Tux is on the floor and not staying where he is, do walk animation
        if (velocity.x != 0 && isTouching(FLOOR))
        {
            animation.play("walk");
        }

        // If Tux is not on the floor, do jump animation
        // TODO: Is velocity.y != 0 needed?
        if (velocity.y != 0 && !isTouching(FLOOR))
        {
            animation.play("jump");
        }
    }

    function move()
    {
        // Speed is 0 at beginning
        acceleration.x = 0;

        // If player presses left keys, walk left
        if (FlxG.keys.anyPressed([LEFT, A]))
        {
            flipX = true;
            direction = -1;
            acceleration.x -= tuxAcceleration;
        }
        // If player presses right keys, walk right
        else if (FlxG.keys.anyPressed([RIGHT, D]))
        {
            flipX = false;
            direction = 1;
            acceleration.x += tuxAcceleration;
        }

        // If player pressing jump keys and is on ground, jump
        if (FlxG.keys.anyJustPressed([SPACE, W, UP]) && isTouching(FLOOR))
        {
            if (velocity.x == walkSpeed || velocity.x == -walkSpeed)
            {
                velocity.y = -maxJumpHeight;
            }
            else
            {
                velocity.y = -minJumpHeight;
            }
        }
        
        // Variable Jump Height
        if (velocity.y < 0 && FlxG.keys.anyJustReleased([SPACE, W, UP]))
        {
            velocity.y -= velocity.y * 0.5;
        }
    }
}