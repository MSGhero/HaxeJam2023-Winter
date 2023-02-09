package ui.elements;

import mono.interactive.shapes.Rect;
import mono.interactive.Interactive;
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

// @:build(haxe.ui.ComponentBuilder.build("assets/ui/card.xml"))
class UI_Button extends Component {
	
	public function new(ecs:Universe, frames:Array<String>, onSelect:()->Void, width:Int, height:Int) {
		super();
		
		styleable = false;
		
		final uiE = ecs.createEntity();
		
		final anim:Array<AnimRequest> = [
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
		
		final int:Interactive = {
			shape : new Rect(left + width / 2, top + height / 2, width, height),
			onOver : () -> {
				Command.queue(PLAY_ANIMATION(uiE, "hover"));
				hxd.System.setCursor(Button);
				
			},
			onOut : () -> {
				Command.queue(PLAY_ANIMATION(uiE, "idle"));
				hxd.System.setCursor(Default);
			},
			onSelect : onSelect
		};
		
		ecs.setComponents(uiE, int, (this:Component), (this.getImageDisplay().sprite:Bitmap));
		Command.queue(CREATE_ANIMATIONS(uiE, SPRITES, anim, "idle"));
		
		ready();
	}
}