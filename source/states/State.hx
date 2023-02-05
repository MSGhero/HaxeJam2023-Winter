package states;

import ecs.Universe;
import h2d.Layers;

abstract class State extends Layers {
	
	public var active:Bool;
	var ecs:Universe;
	
	public function new(ecs:Universe) {
		super();
		
		active = false;
		this.ecs = ecs;
	}
	
	public abstract function init():Void;
	public abstract function destroy():Void;
	public abstract function reset():Void;
	public abstract function enter():Void;
	public abstract function exit():Void;
}