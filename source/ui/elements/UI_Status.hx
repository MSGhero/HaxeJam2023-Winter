package ui.elements;

import haxe.ui.components.Range;
import h2d.Bitmap;
import haxe.ui.core.Component;
import IDs.SheetID;
import mono.animation.AnimCommand;
import mono.animation.AnimRequest;
import mono.command.Command;
import haxe.ui.containers.Absolute;

@:build(haxe.ui.ComponentBuilder.build("assets/ui/status.xml"))
class UI_Status extends Absolute {
	
	public function new() {
		super();
		
		styleable = false;
		disabled = true;
		
		final ecs = Main.ecs;
		final bgE = ecs.createEntity();
		
		final bgAnim:Array<AnimRequest> = [
			{
				name : "idle",
				frameNames : ["soil_temp_light_meters"],
				loop : false
			}
		];
		
		final sliders = [soil, temp, light];
		final thumbAnim:Array<AnimRequest> = [
			{
				name : "idle",
				frameNames : ["soil_temp_light_thumbnail"],
				loop : false
			}
		];
		
		for (slider in sliders) {
			final thumbE = ecs.createEntity();
			final thumb = slider.findComponent("end-thumb");
			thumb.styleable = false;
			slider.styleable = false;
			slider.findComponent("range", Range).styleable = false;
			slider.findComponent("range-value").styleable = false;
			ecs.setComponents(thumbE, (thumb:Component), (thumb.getImageDisplay().sprite:Bitmap));
			Command.queue(CREATE_ANIMATIONS(thumbE, SPRITES, thumbAnim, "idle"));
		}
		
		ecs.setComponents(bgE, (bg:Component), (bg.getImageDisplay().sprite:Bitmap));
		
		Command.queueMany(
			CREATE_ANIMATIONS(bgE, SPRITES, bgAnim, "idle")
		);
		
		ready();
	}
	
	public function setState(soilP:Float, tempP:Float, lightP:Float) {
		soil.pos = soilP * 100;
		temp.pos = tempP * 100;
		light.pos = lightP * 100;
	}
}