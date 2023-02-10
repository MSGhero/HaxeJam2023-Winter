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

@:build(haxe.ui.ComponentBuilder.build("assets/ui/card.xml"))
class UI_Card extends Absolute {
	
	public function new() {
		super();
		
		styleable = false;
		
		final ecs = Main.ecs;
		final bgE = ecs.createEntity();
		
		final bgAnim:Array<AnimRequest> = [
			{
				name : "idle",
				frameNames : ["card_background"],
				loop : false
			}
		];
		
		final cardE = ecs.createEntity();
		
		var cardAnim:Array<AnimRequest> = [
			{
				name : "state0",
				frameNames : ["card_fire"],
				loop : false
			},
			{
				name : "state1",
				frameNames : ["card_sun"],
				loop : false
			},
			{
				name : "state2",
				frameNames : ["card_ice1"],
				loop : false
			},
			{
				name : "state3",
				frameNames : ["card_ice2"],
				loop : false
			},
			{
				name : "state4",
				frameNames : ["card_time"],
				loop : false
			},
			{
				name : "state5",
				frameNames : ["card_water1"],
				loop : false
			},
			{
				name : "state6",
				frameNames : ["card_water2"],
				loop : false
			}
		];
		
		ecs.setComponents(bgE, (bg:Component), (bg.getImageDisplay().sprite:Bitmap));
		ecs.setComponents(cardE, (card:Component), (card.getImageDisplay().sprite:Bitmap));
		
		Command.queueMany(
			CREATE_ANIMATIONS(bgE, SPRITES, bgAnim, "idle"),
			CREATE_ANIMATIONS(cardE, SPRITES, cardAnim, "state0"),
			ADD_TO(this, S2D, DEBUG)
		);
		
		ready();
	}
}