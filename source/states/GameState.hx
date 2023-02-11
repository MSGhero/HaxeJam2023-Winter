package states;

import IDs.ParentID;
import IDs.LayerID;
import mono.graphics.DisplayListCommand;
import mono.audio.AudioCommand;
import mono.command.Command;
import ui.elements.UI_Game;

class GameState extends State {
	
	public function init() {
		
	}
	
	public function destroy() {
		
	}
	
	public function reset() {
		
	}
	
	public function enter() {
		
		var uig = new UI_Game(ecs);
		Command.queue(ADD_TO(uig, S2D, S2D_GAME));
		
		// Command.queue(PLAY(MUSIC, "music/jazz_track_plant_game.ogg", true, 1, "day"));
	}
	
	public function exit() {
		
	}
}