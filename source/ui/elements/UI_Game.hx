package ui.elements;

import IDs.LayerID;
import IDs.ParentID;
import mono.graphics.DisplayListCommand;
import mono.command.Command;
import ecs.Universe;
import haxe.ui.containers.Absolute;

@:build(haxe.ui.ComponentBuilder.build("assets/ui/main.xml"))
class UI_Game extends Absolute {
	
	public function new(ecs:Universe) {
		super();
		
		styleable = false;
		
		Command.queue(ADD_TO(this, S2D, DEBUG));
		
		ready();
	}
}