package ui.elements;

import mono.timing.TimingCommand;
import mono.interactive.Interactive;
import mono.interactive.shapes.Rect;
import mono.timing.Timing;
import h2d.Bitmap;
import haxe.ui.core.Component;
import IDs.SheetID;
import mono.animation.AnimCommand;
import mono.animation.AnimRequest;
import mono.command.Command;
import haxe.ui.containers.Absolute;

@:build(haxe.ui.ComponentBuilder.build("assets/ui/plant.xml"))
class UI_Plant extends Absolute {
	
	public var onPlant:()->Void = null;
	
	public function new() {
		super();
		
		styleable = false;
		
		final ecs = Main.ecs;
		final soilE = ecs.createEntity();
		
		final soilAnim:Array<AnimRequest> = [
			{
				name : "idle",
				frameNames : ["seedbag_closed"],
				loop : false
			}
		];
		
		final plantE = ecs.createEntity();
		
		var plantAnim:Array<AnimRequest> = [
			{
				name : "idle",
				frameNames : ["seed_greeny"],
				loop : false
			}
		];
		
		final bm:Bitmap = soil.getImageDisplay().sprite;
		final rect = new Rect(0, 0, 0, 0); // gets populated on the next frame
		final int:Interactive = {
			shape : rect,
			onOver : () -> {
				
				hxd.System.setCursor(Button);
				
			},
			onOut : () -> {
				
				hxd.System.setCursor(Default);
			},
			onSelect : () -> if (onPlant != null) onPlant()
		};
		
		ecs.setComponents(soilE, int, (soil:Component), bm);
		ecs.setComponents(plantE, (plant:Component), (plant.getImageDisplay().sprite:Bitmap));
		
		Command.queueMany(
			CREATE_ANIMATIONS(soilE, SPRITES, soilAnim, "idle"),
			CREATE_ANIMATIONS(plantE, SPRITES, plantAnim, "idle"),
			ADD_UPDATER(Main.ecs.createEntity(), Timing.delay(0.001, () -> {
				rect.setFromTL(parentComponent.left + left, parentComponent.top + top, bm.tile.width, bm.tile.height);
			}))
		);
		
		ready();
	}
}