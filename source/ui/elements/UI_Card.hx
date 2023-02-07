package ui.elements;

import h2d.Bitmap;
import mono.interactive.shapes.Rect;
import haxe.ui.core.Component;
import mono.interactive.Interactive;
import IDs.SheetID;
import mono.animation.AnimCommand;
import mono.command.Command;
import mono.animation.AnimRequest;
import ecs.Universe;

class UI_Card {
	
	public static function setup(ecs:Universe, compo:Component, frames:Array<String>, width:Int, height:Int) {
		
		final uiE = ecs.createEntity();
		
		var anim:Array<AnimRequest> = [
			{
				name : "idle",
				frameNames : [frames[0]],
				loop : false
			},
			{
				name : "hover",
				frameNames : [frames[1]],
				loop : false
			}
		];
		
		var int:Interactive = {
			shape : new Rect(compo.left + width / 2, compo.top + height / 2, width, height),
			onOver : () -> {
				Command.queue(PLAY_ANIMATION(uiE, "hover"));
				hxd.System.setCursor(Button);
				
			},
			onOut : () -> {
				Command.queue(PLAY_ANIMATION(uiE, "idle"));
				hxd.System.setCursor(Default);
			}
		};
		
		ecs.setComponents(uiE, int, (compo:Component), (compo.getImageDisplay().sprite:Bitmap));
		Command.queue(CREATE_ANIMATIONS(uiE, SPRITES, anim, "idle"));
	}
}