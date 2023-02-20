package states;

import ui.elements.UI_SelectSeed;
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
	var selectSeed:UI_SelectSeed;
	
	var turnCount:Int;
	var plants:Array<Plant>;
	
	public function init() {
		
		plants = [null, null, null, null];
		
		uig = new UI_Game();
		selectSeed = new UI_SelectSeed();
		
		uig.window.plant0.interactive.onSelect = () -> {
			if (plants[0] == null) return;
			uig.seed.setSeed(plants[0].type);
			uig.status.setState(plants[0].soil, plants[0].temp, plants[0].light);
		};
		
		uig.window.plant1.interactive.onSelect = () -> {
			if (plants[1] == null) return;
			uig.seed.setSeed(plants[1].type);
			uig.status.setState(plants[1].soil, plants[1].temp, plants[1].light);
		};
		
		uig.window.plant2.interactive.onSelect = () -> {
			if (plants[2] == null) return;
			uig.seed.setSeed(plants[2].type);
			uig.status.setState(plants[2].soil, plants[2].temp, plants[2].light);
		};
		
		uig.window.plant3.interactive.onSelect = () -> {
			if (plants[3] == null) return;
			uig.seed.setSeed(plants[3].type);
			uig.status.setState(plants[3].soil, plants[3].temp, plants[3].light);
		};
		
		uig.card0.interactive.onSelect = () -> {
			// how does this interact with the play button?
			// card doesn't tween down?
			// and then turns
			trace("K");
		};
		
		uig.seed.interactive.enabled = false;
		
		selectSeed.seed0.interactive.onSelect = () -> trace("K");
		selectSeed.seed1.interactive.enabled = false;
		
		uig.seedbag.interactive.onSelect = () -> {
			selectSeed.visible = true;
			
		};
		
		selectSeed.visible = false;
	}
	
	public function destroy() {
		
	}
	
	public function reset() {
		
	}
	
	public function enter() {
		
		turnCount = 0;
		
		Command.queueMany(
			ADD_TO(uig, S2D, S2D_GAME),
			ADD_TO(selectSeed, S2D, UI_WINDOW),
			PLAY(MUSIC, "music/guitar_track_plant_game.ogg", true, 1, "day"),
			PLAY(MUSIC, "music/jazz_track_plant_game.ogg", true, 0, "night")
		);
		
		Command.queue(ADD_UPDATER(Entity.none, Timing.delay(7, () -> {
			onNight();
		})));
	}
	
	public function exit() {
		
	}
	
	function onDay() {
		Command.queueMany(
			FADE(1, 1, 0, f -> f * f, "night"),
			FADE(2, 0, 1, null, "day")
		);
	}
	
	function onNight() {
		Command.queueMany(
			FADE(1, 1, 0, f -> f * f, "day"),
			FADE(2, 0, 1, null, "night")
		);
	}
	
	function updatePlants() {
		
		if (plants[0] != null) {
			uig.window.plant0.setPlant(plants[0].soilType, plants[0].type);
		}
		
		if (plants[1] != null) {
			uig.window.plant0.setPlant(plants[1].soilType, plants[1].type);
		}
		
		if (plants[2] != null) {
			uig.window.plant0.setPlant(plants[2].soilType, plants[2].type);
		}
		
		if (plants[3] != null) {
			uig.window.plant0.setPlant(plants[3].soilType, plants[3].type);
		}
	}
}