package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxSpriteUtil;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.util.FlxMath;
import flixel.util.FlxArrayUtil;
import flixel.util.FlxTimer;
import flixel.group.FlxSpriteGroup;

enum GameStage{
	BLOCK_STAGE;
	SELECT_STAGE;
	OBSERVER_STAGE;		
	KILLER_VOTE_STAGE;
	CITIZEN_VOTE_STAGE;
}

class GamePlay extends FlxState
{

	var _killer:Killer;
	var _actionPoint:Int;

	var _citizens:Array<Citizen>;
	var _highlight:Int;
	var _current_stage:GameStage;

	var _infoDisplay:InfoDisplay;
	var _deadCitizen:FlxSpriteGroup;

	var _timer:FlxTimer;

	override public function create():Void{
		FlxG.mouse.visible = false;
		super.create();
		
		//Killer
		_killer = new Killer();{
			add(_killer);
		}

		//Citizen related
		_citizens = new Array();{
			var _temp_ID:Array<Int> = new Array();
			for(i in 0...5){
				_temp_ID.push(i);
			}
			_temp_ID.push(_killer._killerID);

			for(i in 0...5){ //I like the idea of the stick figures surround the camp fire
				_citizens[i] = new Citizen(i, _temp_ID); //
				_citizens[i].setPosition(40 + i * 40, 40);
				add(_citizens[i]);
			}

			_highlight = 0;
			_citizens[_highlight].select();
			_deadCitizen = new FlxSpriteGroup();
		}

		_infoDisplay = new InfoDisplay();{
			_infoDisplay.subscribe(this);
			_actionPoint = 4;
		}

		_current_stage = SELECT_STAGE;
	}
	
	
	override public function destroy():Void{
		super.destroy();
	}
	
	override public function update():Void{
		super.update();
		playerUpdate();
	}

	inline function blockWait(time:Float, ?callBack:FlxTimer ->Void = null):Void{
		_current_stage = BLOCK_STAGE;
		_timer = new FlxTimer(time, callBack);
	}

	function playerUpdate():Void{
		if(_current_stage == BLOCK_STAGE) return ;

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
		   		_citizens[_highlight].killCitizen();
		   		_deadCitizen.add(_citizens[_highlight]);
		   		_citizens.remove(_citizens[_highlight]);
		
			   	_infoDisplay._subtitleText.text = "You have selected " + _citizens[_highlight]._citizenID;
		   		function call_back(timer:FlxTimer){
		   			_current_stage = OBSERVER_STAGE;
		   			_infoDisplay.showText("Option");
		   		} 
		   		blockWait(0.5, call_back);
		   		
		   	}else if(_current_stage == OBSERVER_STAGE){
		   		// if(_actionPoint == 0){
		   		// 	_current_stage == KILLER_VOTE_STAGE;
		   		// 	_infoDisplay.showText("Who");
		   		// 	return ;
		   		// }

		   		_actionPoint--;
		   		_infoDisplay.updateActionPoint(_actionPoint);
		   		_infoDisplay._subtitleText.text = _citizens[_highlight].behaviour();
		   		
		   		if(_actionPoint == 0){
		   			function call_back(timer:FlxTimer ){
			   			_current_stage == KILLER_VOTE_STAGE;
		   				_infoDisplay.showText("Who");
			   		} 
			   		blockWait(0.5, call_back);
		   		}else{
					function call_back(timer:FlxTimer ){
			   			_current_stage = OBSERVER_STAGE;
			   			_infoDisplay.showText("Option");
			   		} 
			   		blockWait(0.5, call_back);
		   		}

		   	}else if(_current_stage == KILLER_VOTE_STAGE){
		   		_killer._vote_citizenID = _citizens[_highlight]._citizenID;
		   		_infoDisplay._subtitleText.text = "You choose to vote " + _killer._vote_citizenID;
		   		trace(" Dynamic ");
		   		function call_back(timer:FlxTimer){
		   			_citizens[_highlight].deselect();
		   			_current_stage = CITIZEN_VOTE_STAGE;
		   			_infoDisplay.showText("Vote");
		   		}
		   		blockWait(0.5, call_back);
	
		   	}else if(_current_stage == CITIZEN_VOTE_STAGE){
		   		//so if follow the case of real life one
		   		//ppl already know who they will vote for
		   		//so it is just a matter of fact of walk around each ppl
		   		//I do rememeber ppl like pointing out who they are suspicious about.. 
		   		//but that will be similar to observaton/behaviour/accuation
		   		//so just walk around each ppl?

		   		//after get vote.. give out a summary of vote


		   		/*
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
		   		}*/

		   		//ok...what if there is a equal case... 
		   		//the whole voting process should be another func
		   		//where as long as there is equal...request a revote...
		   		//for now that is not the most importatn
		   		/*if(max_candidate == _killerID){
		   			youLose();
		   		}else{
		   			_citizens[max_candidate].killCitizen();
		   			_current_stage = SELECT_STAGE;
		   			_actionPoint = 4;
		   			_infoDisplay.updateActionPoint(_actionPoint);
		   		}*/
		   	}

		}
 		
	}	

	function youLose():Void{

	}	
}
