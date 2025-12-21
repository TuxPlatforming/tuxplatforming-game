package objects;

// Made by Vaesea, fixed by AnatolyStev
// Well actually it came from Discover Haxeflixel but still

import creatures.player.Tux;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.effects.particles.FlxParticle;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import objects.Coin;

class EmptySandBrickBlock extends FlxSprite
{
    var scoreAmount = 25;
    var gravity = 1000;

    var hfArea2D:FlxSprite; // Area2D-like thing

    var brickImage = FlxAtlasFrames.fromSparrow('assets/images/objects/brick.png', 'assets/images/objects/brick.xml');
    
    public function new(x:Float, y:Float)
    {
        super(x, y);
        immovable = true;

        frames = brickImage;
        animation.addByPrefix('normal', 'normal', 12, false);
        animation.play("normal");

        hfArea2D = new FlxSprite(x + 8, y + height);
        hfArea2D.makeGraphic(Std.int(width) - 16, Std.int(height) + 3, FlxColor.TRANSPARENT);
        hfArea2D.immovable = true;
        hfArea2D.solid = false;
    }

    override public function update(elapsed:Float)
    {
        if (isOnScreen())
        {
            super.update(elapsed);
        }
    }
    
    public function hit(tux:Tux)
    {
        if (!hfArea2D.overlaps(tux))
        {
            return;
        }

        Global.score += scoreAmount;
        FlxG.sound.play('assets/sounds/impact.ogg');
            
        for (i in 0...4)
        {
            var debris:FlxParticle = new FlxParticle();
            debris.loadGraphic('assets/images/particles/brick.png', true, 16, 8);
            debris.animation.add("rotate", [0, 1], 16, true);
            debris.animation.play("rotate");

            var countX = (i % 2 == 0) ? 1 : -1;
            var countY = (Math.floor(i / 2)) == 0 ? -1 : 1;

            debris.setPosition(4 + x + countX * 4, 4 + y + countY * 4);
            debris.lifespan = 6;
            debris.acceleration.y = gravity;
            debris.velocity.y = -160 + (10 * countY);
            debris.velocity.x = 40 * countX;
            debris.exists = true;

            Global.PS.add(debris);
        }

        kill();
    }
}

class CoinSandBrickBlock extends FlxSprite
{
    var scoreAmount = 25;
    var gravity = 1000;

    var howManyHits = 8;
    var isHit = false;

    var hfArea2D:FlxSprite;

    var brickCoinImage = FlxAtlasFrames.fromSparrow('assets/images/objects/brick.png', 'assets/images/objects/brick.xml');

    public function new(x:Float, y:Float)
    {
        super(x, y);
        solid = true;
        immovable = true;

        frames = brickCoinImage;
        animation.addByPrefix('normal', 'normal', 12, false);
        animation.addByPrefix('empty', 'empty', 12, false);
        animation.play("normal");

        hfArea2D = new FlxSprite(x + 8, y + height);
        hfArea2D.makeGraphic(Std.int(width) - 16, Std.int(height) + 3, FlxColor.TRANSPARENT); // all this STD is gonna give me a... Nevermind. Forget about it. Std.int is there because width and height need to be ints.
        hfArea2D.immovable = true;
        hfArea2D.solid = false;
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);

        if (howManyHits <= 0)
        {
            animation.play("empty");
        }
    }
    
    public function hit(tux:Tux)
    {
        if (!hfArea2D.overlaps(tux) || isHit)
        {
            return;
        }

        if (howManyHits > 0)
        {
            var currentY = y;
            howManyHits -= 1;
            isHit = true;
            FlxTween.tween(this, {y: currentY - 4}, 0.05)
            .wait(0.05)
            .then(FlxTween.tween(this, {y: currentY}, 0.05, {onComplete: function (_)
            {
                isHit = false;
            }}));
            createItem();
        }
    }

    function createItem()
    {
        FlxG.sound.play('assets/sounds/impact.ogg');
        var coin:Coin = new Coin(Std.int(x), Std.int(y - 32));
        coin.setFromBlock();
        Global.PS.items.add(coin);
    }
}