package util;

import h3d.Engine;
import hxd.res.DefaultFont;
import h2d.RenderContext;
import h2d.Tile;
import h2d.Text;
import h2d.Object;

class FPS extends Object {

	var text:Text;
	var numbers:Text;
	var bg:Tile;

	public function new() {
		super();
		
		var font = DefaultFont.get().clone();
		// maybe pass some params to manipulate size, etc
		
		text = new Text(font, this);
		text.textColor = 0xff000000;
		text.textAlign = Left;
		text.x = 5; text.y = 5;
		
		text.text =
			"FPS:" +
			"\nMem KB:" +
			"\nTex KB:" +
			"\nDraw calls:" +
			"\nBuffers:"
		;
		
		numbers = new Text(font, this);
		numbers.textColor = 0xff000000;
		numbers.maxWidth = 100;
		numbers.textAlign = Right;
		numbers.x = 5; numbers.y = 5;
		
		bg = Tile.fromColor(0xffffffff, 1, 1, 0.75);
		bg.setSize(110, 96);
	}

	override function draw(ctx:RenderContext) {
		super.draw(ctx);
		
		emitTile(ctx, bg); // this occurs before children (text) are rendered
		updateMeter(ctx.elapsedTime);
	}

	function updateMeter(dt:Float) {
		
		// maybe text update is on updater (eg at 4 fps) while internal updating is faster
		
		numbers.text =
			Std.string(Math.round(1 / dt)) + "\n" +
			Std.string(Math.ceil(Engine.getCurrent().mem.usedMemory / 1024)) + "\n" +
			Std.string(Math.ceil(Engine.getCurrent().mem.texMemory / 1024)) + "\n" +
			Std.string(Engine.getCurrent().drawCalls + 2) + "\n" + // I think I need to update after everything has been set, or use prev frame's values
			Std.string(Engine.getCurrent().mem.bufferCount)
		;
		
		// average fps?
		// dropping frames? (ie accumulator maxed out within past few sec)
		// i'd love a plot but nice to have rn
	}
}