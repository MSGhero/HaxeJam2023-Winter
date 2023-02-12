package states;

import IDs.ParentID;
import IDs.LayerID;
import mono.graphics.DisplayListCommand;
import mono.audio.AudioCommand;
import mono.command.Command;
import ui.elements.UI_Game;

class GameState extends State {
	
	var uig:UI_Game;
	
	public function init() {
		
		uig = new UI_Game(ecs);
		
		uig.window.plant0.onPlant = () -> {
			uig.seed.setSeed("pinecone");
			uig.status.setState(0.3, 0.7, 0.1);
		};
		
		uig.window.plant1.onPlant = () -> {
			uig.seed.setSeed("stars");
			uig.status.setState(0.8, 0.2, 0.4);
		};
		
		uig.window.plant2.onPlant = () -> {
			uig.seed.setSeed("cactus");
			uig.status.setState(0.1, 1, 0.7);
		};
		
		uig.window.plant3.onPlant = () -> {
			uig.seed.setSeed("watery");
			uig.status.setState(0.8, 0.1, 0.4);
		};
	}
	
	public function destroy() {
		
	}
	
	public function reset() {
		
	}
	
	public function enter() {
		
		Command.queue(ADD_TO(uig, S2D, S2D_GAME));
		
		Command.queue(PLAY(MUSIC, "music/guitar_track_plant_game.ogg", true, 1, "day"));
		Command.queue(PLAY(MUSIC, "music/jazz_track_plant_game.ogg", true, 0, "night"));
	}
	
	public function exit() {
		
	}
}