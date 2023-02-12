package states;

import mono.timing.Timing;
import ecs.Entity;
import mono.timing.TimingCommand;
import plants.Plant;
import IDs.ParentID;
import IDs.LayerID;
import mono.graphics.DisplayListCommand;
import mono.audio.AudioCommand;
import mono.command.Command;
import ui.elements.UI_Game;

class GameState extends State {
	
	var uig:UI_Game;
	
	var plants:Array<Plant>;
	
	public function init() {
		
		plants = [null, null, null, null];
		
		uig = new UI_Game(ecs);
		
		uig.window.plant0.onPlant = () -> {
			if (plants[0] == null) return;
			uig.seed.setSeed(plants[0].type);
			uig.status.setState(plants[0].soil, plants[0].temp, plants[0].light);
		};
		
		uig.window.plant1.onPlant = () -> {
			if (plants[1] == null) return;
			uig.seed.setSeed(plants[1].type);
			uig.status.setState(plants[1].soil, plants[1].temp, plants[1].light);
		};
		
		uig.window.plant2.onPlant = () -> {
			if (plants[2] == null) return;
			uig.seed.setSeed(plants[2].type);
			uig.status.setState(plants[2].soil, plants[2].temp, plants[2].light);
		};
		
		uig.window.plant3.onPlant = () -> {
			if (plants[3] == null) return;
			uig.seed.setSeed(plants[3].type);
			uig.status.setState(plants[3].soil, plants[3].temp, plants[3].light);
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
		
		Command.queue(ADD_UPDATER(Entity.none, Timing.delay(7, () -> {
			Command.queueMany(
				FADE(1, 1, 0, f -> f * f, "day"),
				FADE(2, 0, 1, null, "night")
			);
		})));
	}
	
	public function exit() {
		
	}
}