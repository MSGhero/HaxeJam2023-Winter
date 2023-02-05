package pause;

import mono.command.Command;
import pause.PauseCommand;
import mono.timing.Paralleler;
import ecs.Universe;
import ecs.System;

class PauseSystem extends System {
	
	@:fullFamily
	var pausers : {
		resources : {
			
		},
		requires : {
			triggers:PauseGroup,
			ups:Paralleler
		}
	}
	
	var pauseState:Int;
	
	public function new(ecs:Universe) {
		super(ecs);
		
		pauseState = 0;
	}
	
	override function onEnabled() {
		super.onEnabled();
		
		Command.register(PAUSE(0), handlePC);
		Command.register(UNPAUSE(0), handlePC);
	}
	
	function handlePC(pc:PauseCommand) {
		
		switch (pc) {
			case PAUSE(trigger):
				pauseState |= trigger;
				refresh();
			case UNPAUSE(untrigger):
				pauseState &= ~untrigger;
				refresh();
		}
	}
	
	function refresh() {
		
		iterate(pausers, {
			ups.paused = triggers & pauseState > 0;
		});
	}
}