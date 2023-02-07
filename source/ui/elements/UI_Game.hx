package ui.elements;

import IDs.LayerID;
import IDs.ParentID;
import mono.graphics.DisplayListCommand;
import mono.command.Command;
import haxe.ui.core.Component;
import ecs.Universe;
import haxe.ui.containers.Absolute;

@:build(haxe.ui.ComponentBuilder.build("assets/ui/main.xml"))
class UI_Game extends Absolute {
	
	public function new(ecs:Universe) {
		super();
		
		styleable = false;
		
		UI_Card.setup(ecs, drawCard, ["playcard_idle", "playcard_hover"], 219, 229);
		
		Command.queue(ADD_TO(this, S2D, DEBUG));
		
		ready();
	}
}