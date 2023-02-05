package states;

import haxe.ds.IntMap;
import mono.command.Command;
import states.StateCommand;
import ecs.Universe;
import ecs.System;

class StateSystem extends System {
	
	var states:IntMap<State>;
	
	var enterNotifs:IntMap<Array<()->Void>>;
	var exitNotifs:IntMap<Array<()->Void>>;
	
	public function new(ecs:Universe) {
		super(ecs);
		
		states = new IntMap();
		
		enterNotifs = new IntMap();
		exitNotifs = new IntMap();
	}
	
	override function onEnabled() {
		super.onEnabled();
		
		Command.register(REGISTER_ENTER(0, null), handleSC);
		Command.register(REGISTER_EXIT(0, null), handleSC);
		Command.register(REGISTER_STATE(null, 0), handleSC);
		Command.register(ENTER(0), handleSC);
		Command.register(EXIT(0), handleSC);
	}
	
	function handleSC(sc:StateCommand) {
		
		switch (sc) {
			case REGISTER_ENTER(to, callback):
				enterNotifs.get(to).push(callback);
			case REGISTER_EXIT(to, callback):
				exitNotifs.get(to).push(callback);
			case REGISTER_STATE(state, tag):
				states.set(tag, state);
				state.init();
				enterNotifs.set(tag, []);
				exitNotifs.set(tag, []);
			case ENTER(state):
				states.get(state).enter();
				for (cb in enterNotifs.get(state)) cb();
			case EXIT(state):
				states.get(state).exit();
				for (cb in exitNotifs.get(state)) cb();
		}
	}
}