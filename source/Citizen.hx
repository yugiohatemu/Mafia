package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxSpriteUtil;


class Citizen extends FlxSprite 
{
	public var _citizenID:Int;
	public var _isAlive:Bool;
	public var _behaviour:Behaviour;

	override public function new(citizenID:Int, citizenID_list:Array<Int>){
		super(16,16);
		_isAlive = true;
		_citizenID = citizenID;

		citizenID_list.remove(citizenID);
		_behaviour = new Behaviour(citizenID_list);
		
		this.makeGraphic( 16 , 16 , flixel.util.FlxColor.RED);
	}

	override public function destroy():Void{
		super.destroy();
	}

	public function select():Void{
		if(_isAlive) this.makeGraphic( 16 , 16 , flixel.util.FlxColor.MAGENTA);
	}


	public function deselect():Void{
		if(_isAlive) this.makeGraphic( 16 , 16 , flixel.util.FlxColor.RED);	
	}

	public function killCitizen():Void{
		_isAlive = false;
		this.makeGraphic( 16 , 16 , flixel.util.FlxColor.BLUE);		
	}

	public function behaviour():String{
		return "HAHAHA";
	}

	public function vote():Int{
		return _behaviour.vote();
	}
}