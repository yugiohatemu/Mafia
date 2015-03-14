
package;


typedef Observe = {
	suspicisonLevel:Int,
	citizen_ID:Int
}

class Behaviour{
	
	var observation_list:Array<Behaviour.Observe>;
	var nervous_level:Int;	
	
	public function new(_citizenID:Array<Int>){ //list of citizenID
		observation_list = new Array();
		for(i in 0 ... _citizenID.length){
			var _temp:Behaviour.Observe = { 
				suspicisonLevel: 5 * _citizenID.length, citizen_ID: _citizenID[i] 
			};
			// var _temp:Behaviour.Observe;
			// _temp.suspicisonLevel = 5 * _citizenID.length;
			// _temp.citizen_ID = _citizenID[i];
			observation_list.push(_temp);
		}

	}
	//

	//return a string to describe it
	public function description():String{
		return "hahah";
	}

	private function accusation():String{
		return "hahahh";
	}

	private function beingAccused( accusorId:Int ):String{
		//+5?
		var index:Int = 0;
		var i:Int = 0;
		
		for(i in 0 ... observation_list.length){
			if(observation_list[i].citizen_ID == accusorId){
				index = i;
			}
		}

		observation_list[index].suspicisonLevel += 5;
		return "BLAHABLAH";
	}

	public function vote():Int{
		//give out the most suspicisous one
		
		var maxSuspicisous = 0;
		var candidate:Int = 0;
		for(i in 0 ... observation_list.length){
			if(observation_list[i].suspicisonLevel > maxSuspicisous){
				candidate = observation_list[i].citizen_ID;
				maxSuspicisous = observation_list[i].suspicisonLevel;
			}
		}
		return candidate;
	}

	public function getTotal():Int{
		var sum = 0;
		for(i in 0 ... observation_list.length){
			sum += observation_list[i].suspicisonLevel;	
		}
		return sum;
	}

	public function adjustSuspicion(dead_id:Int):Void{
		observation_list.remove(observation_list[dead_id]);
	}
}
