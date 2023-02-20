package ui.elements;

import mono.interactive.InteractiveCommand;
import mono.interactive.Interactive;
import mono.interactive.shapes.Rect;
import ecs.Entity;
import mono.timing.TimingCommand;
import mono.timing.Timing;
import h2d.Bitmap;
import haxe.ui.core.Component;
import IDs.SheetID;
import mono.animation.AnimCommand;
import mono.animation.AnimRequest;
import mono.command.Command;
import haxe.ui.containers.Absolute;

@:build(haxe.ui.ComponentBuilder.build("assets/ui/seed.xml"))
class UI_Seed extends Absolute implements IUI {
	
	final bgE:Entity;
	final seedE:Entity;
	
	public var interactive(default, null):Interactive;
	
	public function new() {
		super();
		
		styleable = false;
		
		final ecs = Main.ecs;
		bgE = ecs.createEntity();
		
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
		
		seedE = ecs.createEntity();
		
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
		
		final bm:Bitmap = bg.getImageDisplay().sprite;
		final rect = new Rect(0, 0, 0, 0); // gets populated on the next frame
		interactive = {
			shape : rect
		};
		
		final wave = Timing.tween(2.5, f -> {
			seed.getImageDisplay().sprite.y = 4 * Math.cos(6.28 * f); // for some reason, the component doesn't like negative y (layout related?)
		});
		
		wave.autoDispose = false;
		wave.repetitions = -1;
		
		ecs.setComponents(bgE, interactive, (bg:Component), bm);
		ecs.setComponents(seedE, (seed:Component), (seed.getImageDisplay().sprite:Bitmap));
		
		Command.queueMany(
			CREATE_ANIMATIONS(bgE, SPRITES, bgAnim, "idle"),
			CREATE_ANIMATIONS(seedE, SPRITES, seedAnim, "cactus"),
			ADD_UPDATER(Main.ecs.createEntity(), Timing.delay(0.01, () -> {
				rect.setFromTL(parentComponent.left + left, parentComponent.top + top, bm.tile.width, bm.tile.height);
			})),
			ADD_UPDATER(seedE, wave)
		);
		
		ready();
	}
	
	public function setBG(name:String) {
		Command.queue(PLAY_ANIMATION(bgE, name));
	}
	
	public function setSeed(name:String) {
		Command.queue(PLAY_ANIMATION(seedE, name));
	}
}