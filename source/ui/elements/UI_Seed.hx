package ui.elements;

import mono.timing.TimingCommand;
import mono.timing.Timing;
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

@:build(haxe.ui.ComponentBuilder.build("assets/ui/seed.xml"))
class UI_Seed extends Absolute {
	
	public function new() {
		super();
		
		styleable = false;
		
		final ecs = Main.ecs;
		final bgE = ecs.createEntity();
		
		final bgAnim:Array<AnimRequest> = [
			{
				name : "idle",
				frameNames : ["seed_background_standard"],
				loop : false
			},
			{
				name : "day",
				frameNames : ["seed_background_day"],
				loop : false
			},
			{
				name : "night",
				frameNames : ["seed_background_night"],
				loop : false
			}
		];
		
		final seedE = ecs.createEntity();
		
		var seedAnim:Array<AnimRequest> = [
			{
				name : "cactus",
				frameNames : ["seed_dancing_cactus"],
				loop : false
			},
			{
				name : "greeny",
				frameNames : ["seed_greeny"],
				loop : false
			},
			{
				name : "pinecone",
				frameNames : ["seed_pinecone"],
				loop : false
			},
			{
				name : "stars",
				frameNames : ["seed_stars"],
				loop : false
			},
			{
				name : "sunflower",
				frameNames : ["seed_sunflower"],
				loop : false
			},
			{
				name : "watery",
				frameNames : ["seed_watery"],
				loop : false
			}
		];
		
		final wave = Timing.tween(2.5, f -> {
			seed.getImageDisplay().sprite.y = 4 * Math.cos(6.28 * f); // for some reason, the component doesn't like negative y (layout related?)
		});
		
		wave.autoDispose = false;
		wave.repetitions = -1;
		
		ecs.setComponents(bgE, (bg:Component), (bg.getImageDisplay().sprite:Bitmap));
		ecs.setComponents(seedE, (seed:Component), (seed.getImageDisplay().sprite:Bitmap));
		
		Command.queueMany(
			CREATE_ANIMATIONS(bgE, SPRITES, bgAnim, "idle"),
			CREATE_ANIMATIONS(seedE, SPRITES, seedAnim, "cactus"),
			ADD_UPDATER(seedE, wave),
			ADD_TO(this, S2D, DEBUG)
		);
		
		ready();
	}
}