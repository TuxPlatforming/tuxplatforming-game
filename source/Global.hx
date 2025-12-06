package;

import states.PlayState;

class Global
{
    // Total coins + score
    public static var coins = 0;
    public static var score = 0;

    // PlayState can now have stuff from it used from all things
    public static var PS:PlayState;

    // Levels
    public static var levels:Array<String> = ["test"];
    public static var currentLevel = 0;
    public static var levelName:String;

    // Music
    public static var currentSong:String;
}