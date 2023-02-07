package states;

import mono.interactive.shapes.Rect;
import mono.interactive.Interactive;
import h2d.Tile;
import h2d.Bitmap;
import IDs.LayerID;
import IDs.ParentID;
import mono.graphics.DisplayListCommand;
import mono.command.Command;
import util.FPS;

class DebugState extends State {
	
	var fps:FPS;
	
	public function init() {
		
		fps = new FPS();
		fps.x = 960 - 110; // alignment component? aligns top right not necessarily any specific xy
		fps.y = 0;
	}
	
	public function destroy() {
		
		fps = null;
	}
	
	public function reset() {
		
	}
	
	public function enter() {
		
		Command.queue(DisplayListCommand.ADD_TO(fps, S2D, DEBUG));
		
		var bm = new Bitmap(Tile.fromColor(0xffff0000, 100, 100));
		var int:Interactive = {
			shape : new Rect(50, 50, 100, 100),
			onSelect : () -> {
				bm.alpha = Math.random();
				trace("K");
			}
		};
		
		ecs.setComponents(ecs.createEntity(), int);
		
		Command.queue(DisplayListCommand.ADD_TO(bm, S2D, DEBUG));
	}
	
	public function exit() {
		
		Command.queue(DisplayListCommand.REMOVE_FROM_PARENT(fps));
	}
}