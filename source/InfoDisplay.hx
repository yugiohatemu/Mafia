package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxTimer;

class InfoDisplay{
	public var _actionPointText:FlxText;
	public var _subtitleText:FlxText;
	public var _textMap:Map<String,String>;
	private var _gamePlay:GamePlay;

	public function new(){
		
		_actionPointText = new FlxText(240,20, "Action Left: " + 4, 10);

		_subtitleText = new FlxText(20,240, "Select your target for tonight", 10 );
		_subtitleText.color = flixel.util.FlxColor.WHITE;

		_textMap = new Map();
		_textMap.set("Select", "Select your target for tonight");
		_textMap.set("Target", "You have selected your target for tonight.");
		_textMap.set("Option", "1. Behaviour\n 2. Distract");
		_textMap.set("Who", "Who do want to vote ?");
		_textMap.set("Vote", "Time to Vote the Killer");
		trace(_textMap);

	}

	public function subscribe( gamePlay:GamePlay):Void{
		gamePlay.add(_actionPointText);
		gamePlay.add(_subtitleText);
		_gamePlay = gamePlay;
	}

	public function update():Void{
		//depends on what state the subtitle is 
		if(FlxG.keys.anyJustPressed(["1"])){
			//...this also depends on how we implement our text system
		}else if(FlxG.keys.anyJustPressed(["2"])){
			
		}
	}

	public function updateActionPoint(actionPoint:Int){
		_actionPointText.text = "Action Left: " + actionPoint;
	}

	//to make it easy and straight forward
	public function showText( string_key:String):Void{	
		_subtitleText.text = _textMap.get(string_key);
	}


	//infuture will besomething like ,show(textmap_key, remainderString)
}