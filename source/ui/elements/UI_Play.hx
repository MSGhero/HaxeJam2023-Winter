package ui.elements;

import mono.timing.TimingCommand;
import mono.timing.Timing;
import mono.interactive.shapes.Rect;
import mono.interactive.Interactive;
import h2d.Bitmap;
import haxe.ui.core.Component;
import IDs.SheetID;
import mono.animation.AnimCommand;
import mono.animation.AnimRequest;
import mono.command.Command;

class UI_Play extends Component implements IUI {
	
	public var interactive(default, null):Interactive;
	
	public function new() {
		super();
		
		styleable = false;
		
		final ecs = Main.ecs;
		final uiE = ecs.createEntity();
		
		final anim:Array<AnimRequest> = [
			{
				name : "idle",
				frameNames : ["playcard_idle"],
				loop : false
			},
			{
				name : "hover",
				frameNames : ["playcard_hover"],
				loop : false
			}
		];
		
		final bm:Bitmap = getImageDisplay().sprite;
		final rect = new Rect(0, 0, 0, 0); // gets populated on the next frame
		interactive = {
			shape : rect,
			onOver : () -> {
				Command.queue(PLAY_ANIMATION(uiE, "hover"));
				
			},
			onOut : () -> {
				Command.queue(PLAY_ANIMATION(uiE, "idle"));
			}
		};
		
		ecs.setComponents(uiE, interactive, (this:Component), bm);
		Command.queueMany(
			CREATE_ANIMATIONS(uiE, SPRITES, anim, "idle"),
			ADD_UPDATER(Main.ecs.createEntity(), Timing.delay(0.001, () -> {
				rect.setFromTL(parentComponent.left + left, parentComponent.top + top, bm.tile.width, bm.tile.height);
			}))
		);
		
		ready();
	}
}