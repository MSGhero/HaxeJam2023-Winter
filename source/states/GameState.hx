package states;

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
	}
	
	public function exit() {
		
	}
}