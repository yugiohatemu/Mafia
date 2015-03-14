package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxSpriteUtil;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.util.FlxMath;
import flixel.util.FlxArrayUtil;
import haxe.Timer;
import flixel.group.FlxSpriteGroup;

enum GameStage{
	SELECT_STAGE;
	OBSERVER_STAGE;		
	VOTE_STAGE;

}

class GamePlay extends FlxState
{

	var _player:FlxSprite;
	var _killerID:Int;
	var _actionPoint:Int;

	var _citizens:Array<Citizen>;
	var _highlight:Int;
	var _current_stage:GameStage;

	var _infoDisplay:InfoDisplay;
	var _deadCitizen:FlxSpriteGroup;

	override public function create():Void{
		//FlxG.mouse.visible = false;
		super.create();
		
		//Player related
		{
			_killerID = -1;

			_player = new FlxSprite(16, 16);
			_player.makeGraphic( 16 ,16 , flixel.util.FlxColor.WHITE);
			add(_player); 
		}

		//Citizen related
		{
			_citizens = new Array();
			var _temp_ID:Array<Int> = new Array();
			for(i in 0...5){
				_temp_ID.push(i);
			}
			_temp_ID.push(_killerID);

			for(i in 0...5){ //I like the idea of the stick figures surround the camp fire
				_citizens[i] = new Citizen(i, _temp_ID); //
				_citizens[i].setPosition(40 + i * 40, 40);
				add(_citizens[i]);
			}

			_highlight = 0;
			_citizens[_highlight].select();
		
			_current_stage = SELECT_STAGE;
		}

		_deadCitizen = new FlxSpriteGroup();


		_infoDisplay = new InfoDisplay();
		_infoDisplay.subscribe(this);
		_actionPoint = 4;
	}
	
	
	override public function destroy():Void{
		super.destroy();
	}
	
	override public function update():Void{
		super.update();
		playerUpdate();
	}

	function playerUpdate():Void{
		//The selection should avoid dead citizen
		if (FlxG.keys.anyJustPressed(["LEFT", "A"])){
			if(_highlight != 0){
				_citizens[_highlight].deselect();
				_highlight--;
				_citizens[_highlight].select();
			}
			
		}else if (FlxG.keys.anyJustPressed(["RIGHT", "D"])){
			if(_highlight != _citizens.length - 1){
				_citizens[_highlight].deselect();
				_highlight++;
				_citizens[_highlight].select();
			}
			
		}else {
			_infoDisplay.update();
		}

		
		if(FlxG.keys.anyJustPressed(["ENTER"])){
		   	if(_current_stage == SELECT_STAGE){
		   		

		   		// var daed:Citizen = _citizens[_highlight];
		   		_citizens[_highlight].killCitizen();

		   		_deadCitizen.add(_citizens[_highlight]);
		   		_citizens.remove(_citizens[_highlight]);

		   		_current_stage = OBSERVER_STAGE;

		   		_infoDisplay._subtitleText.text = "You have selected " + _citizens[_highlight]._citizenID;
		   		trace(_infoDisplay._subtitleText.text);
		   		//wait a sec

		   		//then display optino
		   		
		   		_infoDisplay.showText("Option");
		   	}else if(_current_stage == OBSERVER_STAGE){
			 	//_infoDisplay._subtitleText.text = _citizens[_highlight].behaviour();
		   		_actionPoint--;
		   		_infoDisplay.updateActionPoint(_actionPoint);
		   		 _infoDisplay.showText("Option");
		   		if(_actionPoint == 0){
		   			_current_stage == VOTE_STAGE;
		   		}

		   	}else if(_current_stage == VOTE_STAGE){
		   		//Ok...if we do that the Mafia way..it will be like put your hands up ...pppl can see the voters...
		   		//interesting...

		   		var votes:Map<Int, Int> = new Map();
		   		for(i in 0 ... _citizens.length){
		   			if(_citizens[i]._isAlive){
		   				var target = _citizens[i].vote();
		   				if(!votes.exists(target)){ 
		   					votes[target] = 1;
		   				}else {
		   					votes[target] += 1;
		   				} 
		   			}
		   		}

		   		//now we get the one with the maximum
		   		var max_candidate:Int = _killerID;
		   		var max_vote:Int = 0;
		   		for(it in votes.keys()){
		   			if(votes[it] > max_vote){
		   				max_vote = votes[it];
		   				max_candidate = it;
		   			}
		   		}
		   		//ok...what if there is a equal case... 
		   		//the whole voting process should be another func
		   		//where as long as there is equal...request a revote...
		   		//for now that is not the most importatn
		   		if(max_candidate == _killerID){
		   			youLose();
		   		}else{
		   			_citizens[max_candidate].killCitizen();
		   			_current_stage = SELECT_STAGE;
		   			_actionPoint = 4;
		   			_infoDisplay.updateActionPoint(_actionPoint);
		   		}
		   	}

		}
 		
	}	

	function youLose():Void{

	}	
}
