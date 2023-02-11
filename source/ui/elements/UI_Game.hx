package ui.elements;

import ecs.Universe;
import haxe.ui.containers.Absolute;

@:build(haxe.ui.ComponentBuilder.build("assets/ui/main.xml"))
class UI_Game extends Absolute {
	
	public function new(ecs:Universe) {
		super();
		
		styleable = false;
		
		ready();
	}
}