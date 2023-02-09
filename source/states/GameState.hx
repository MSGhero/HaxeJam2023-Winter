package states;

import ui.elements.UI_Status;
import ui.elements.UI_Card;
import ui.elements.UI_Game;

class GameState extends State {
	
	public function init() {
		
	}
	
	public function destroy() {
		
	}
	
	public function reset() {
		
	}
	
	public function enter() {
		
		new UI_Game(ecs);
		//new UI_Card(ecs);
		//new UI_Status(ecs);
	}
	
	public function exit() {
		
	}
}