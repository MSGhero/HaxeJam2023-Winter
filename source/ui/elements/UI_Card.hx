package ui.elements;

import interactive.InteractiveGroup;
import mono.timing.TimingCommand;
import mono.interactive.Interactive;
import mono.interactive.shapes.Rect;
import mono.timing.Timing;
import mono.timing.Tweener;
import h2d.Bitmap;
import haxe.ui.core.Component;
import IDs.SheetID;
import mono.animation.AnimCommand;
import mono.animation.AnimRequest;
import mono.command.Command;
import haxe.ui.containers.Absolute;

@:build(haxe.ui.ComponentBuilder.build("assets/ui/card.xml"))
class UI_Card extends Absolute {
	
	var upTween:Tweener;
	var downTween:Tweener;
	
	public var onCard:()->Void = null;
	
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
		
		final bm:Bitmap = bg.getImageDisplay().sprite;
		final rect = new Rect(0, 0, 0, 0); // gets populated on the next frame
		final int:Interactive = {
			shape : rect,
			disablers : InteractiveGroup.DISABLED | InteractiveGroup.SELECT_SEED,
			onOver : () -> {
				downTween.cancel();
				upTween.resetCounter();
				upTween.repetitions = 1;
				hxd.System.setCursor(Button);
				
			},
			onOut : () -> {
				upTween.cancel();
				downTween.resetCounter();
				downTween.repetitions = 1;
				hxd.System.setCursor(Default);
			},
			onSelect : () -> if (onCard != null) onCard()
		};
		
		upTween = Timing.tween(0.1, f -> {
			top = rect.top - 30 * f;
		});
		
		downTween = Timing.tween(0.1, f -> {
			top = rect.top - 30 * (1 - f);
		});
		
		upTween.autoDispose = downTween.autoDispose = false;
		upTween.repetitions = downTween.repetitions = 0;
		upTween.ease = downTween.ease = f -> (2 - f) * f;
		
		ecs.setComponents(bgE, int, (bg:Component), bm);
		ecs.setComponents(cardE, (card:Component), (card.getImageDisplay().sprite:Bitmap));
		
		Command.queueMany(
			CREATE_ANIMATIONS(bgE, SPRITES, bgAnim, "idle"),
			CREATE_ANIMATIONS(cardE, SPRITES, cardAnim, "state0"),
			ADD_UPDATER(Main.ecs.createEntity(), Timing.delay(0.01, () -> {
				rect.setFromTL(parentComponent.left + left, parentComponent.top + top, bm.tile.width, bm.tile.height);
			})),
			ADD_UPDATER(bgE, upTween),
			ADD_UPDATER(bgE, downTween)
		);
		
		ready();
	}
}