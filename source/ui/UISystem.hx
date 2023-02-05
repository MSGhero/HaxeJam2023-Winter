package ui;

import haxe.ui.Toolkit;
import haxe.ui.core.Component;
import ecs.Entity;
import mono.graphics.Sprite;
import ecs.Universe;
import ecs.System;

class UISystem extends System {
	
	@:fastFamily
	var uiElts : {
		base:Component
	};
	
	@:fastFamily
	var objProtos : {
		comp:Component,
		proto:Sprite // batchless, animationless sprite
	};
	
	public function new(ecs:Universe) {
		super(ecs);
		
	}
	
	override function onEnabled() {
		super.onEnabled();
		
		Toolkit.init();
		
		uiElts.onEntityAdded.subscribe(handleUIProto);
	}
	
	function handleUIProto(entity:Entity) {
		// dummy Sprite that the component copies various values from
		// to avoid duplicating a lot of code from handling Batch to handling Object
		var proto = new Sprite(null);
		universe.setComponents(entity, (proto:Sprite));
	}
	
	override function update(dt:Float) {
		super.update(dt);
		
		iterate(objProtos, {
			comp.visible = proto.visible;
			comp.alpha = proto.alpha;
		});
	}
}