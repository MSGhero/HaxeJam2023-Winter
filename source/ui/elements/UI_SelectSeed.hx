package ui.elements;

import haxe.ui.containers.Absolute;

@:build(haxe.ui.ComponentBuilder.build("assets/ui/selectseed.xml"))
class UI_SelectSeed extends Absolute {
	
	public function new() {
		super();
		
		styleable = false;
		
		ready();
	}
}