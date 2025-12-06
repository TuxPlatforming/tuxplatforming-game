package objects;

import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;

class Coin extends FlxSprite
{
    // Spritesheet
    var coinImage = FlxAtlasFrames.fromSparrow("assets/images/objects/coin.png", "assets/images/objects/coin.xml");

    var scoreAmount = 50;

    public function new(x:Float, y:Float)
    {
        super(x, y);

        // Spritesheet
        frames = coinImage;

        // Animations
        animation.addByPrefix("normal", "normal", 10, true);
        animation.play("normal");
    }

    public function collect()
    {
        Global.score += scoreAmount;
        Global.coins += 1;

        kill();
    }
}