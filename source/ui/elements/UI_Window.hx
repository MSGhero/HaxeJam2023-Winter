package ui.elements;

import h2d.Bitmap;
import haxe.ui.core.Component;
import IDs.SheetID;
import mono.animation.AnimCommand;
import mono.animation.AnimRequest;
import IDs.ParentID;
import IDs.LayerID;
import mono.graphics.DisplayListCommand;
import mono.command.Command;
import haxe.ui.containers.Absolute;

@:build(haxe.ui.ComponentBuilder.build("assets/ui/window.xml"))
class UI_Window extends Absolute {
	
	public function new() {
		super();
		
		styleable = false;
		
		final ecs = Main.ecs;
		final dayE = ecs.createEntity();
		final nightE = ecs.createEntity();
		
		var anims:Array<AnimRequest> = [
			{
				name : "day",
				frameNames : ["windowsill_daytime"],
				loop : false
			},
			{
				name : "night",
				frameNames : ["windowsill_nighttime"],
				loop : false
			}
		];
		
		ecs.setComponents(dayE, (daytime:Component), (daytime.getImageDisplay().sprite:Bitmap));
		ecs.setComponents(nightE, (nighttime:Component), (nighttime.getImageDisplay().sprite:Bitmap));
		
		Command.queueMany(
			CREATE_ANIMATIONS(dayE, SPRITES, anims, "day"),
			COPY_ANIMATIONS(nightE, dayE, "night")
		);
		
		nighttime.getImageDisplay().sprite.visible = false;
		
		ready();
	}
}