package;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxSpriteUtil;

class Killer extends FlxSprite{

	public var _killerID:Int;
	public var _vote_citizenID:Int;
	override public function new(){
		super(16,16);
		super.makeGraphic(16 ,16 , flixel.util.FlxColor.WHITE);
		
		_killerID = -1;
	}

	override public function destroy():Void{
		super.destroy();
	}
}