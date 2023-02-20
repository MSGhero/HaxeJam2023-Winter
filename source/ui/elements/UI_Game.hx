package ui.elements;

import haxe.ui.containers.Absolute;

@:build(haxe.ui.ComponentBuilder.build("assets/ui/main.xml"))
class UI_Game extends Absolute {
	
	public function new() {
		super();
		
		styleable = false;
		
		ready();
	}
}