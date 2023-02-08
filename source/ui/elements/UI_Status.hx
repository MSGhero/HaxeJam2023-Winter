package ui.elements;

import haxe.ui.components.Range;
import h2d.Bitmap;
import haxe.ui.core.Component;
import IDs.SheetID;
import mono.animation.AnimCommand;
import mono.animation.AnimRequest;
import IDs.ParentID;
import IDs.LayerID;
import mono.graphics.DisplayListCommand;
import mono.command.Command;
import ecs.Universe;
import haxe.ui.containers.Absolute;

@:build(haxe.ui.ComponentBuilder.build("assets/ui/status.xml"))
class UI_Status extends Absolute {
	
	public function new(ecs:Universe) {
		super();
		
		styleable = false;
		
		final bgE = ecs.createEntity();
		
		final bgAnim:Array<AnimRequest> = [
			{
				name : "idle",
				frameNames : ["soil_temp_light_meters"],
				loop : false
			}
		];
		
		final thumbE = ecs.createEntity();
		
		var thumbAnim:Array<AnimRequest> = [
			{
				name : "idle",
				frameNames : ["soil_temp_light_thumbnail"],
				loop : false
			}
		];
		
		var thumb = light.findComponent("end-thumb");
		thumb.styleable = false;
		
		// get rid of blue range without messing up positions
		// light.findComponent("range", Range).styleString = "background:red";
		
		ecs.setComponents(bgE, (bg:Component), (bg.getImageDisplay().sprite:Bitmap));
		ecs.setComponents(thumbE, (thumb:Component), (thumb.getImageDisplay().sprite:Bitmap));
		
		Command.queueMany(
			CREATE_ANIMATIONS(bgE, SPRITES, bgAnim, "idle"),
			CREATE_ANIMATIONS(thumbE, SPRITES, thumbAnim, "idle"),
			ADD_TO(this, S2D, DEBUG)
		);
		
		ready();
	}
}