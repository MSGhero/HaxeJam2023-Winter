package;

import h2d.filter.Nothing;
import mono.input.MouseInput;
import io.newgrounds.NG;
import IDs.SheetID;
import states.DebugState;
import mono.input.PadInput;
import input.DefaultMappings;
import haxe.Timer;
import hxd.Window;
import IDs.InputID;
import IDs.LayerID;
import IDs.BatchID;
import IDs.ParentID;
import IDs.StateID;
import mono.animation.Spritesheet;
import mono.input.KeyboardInput;
import mono.input.InputCommand;
import mono.input.Input;
import mono.command.Command;
import mono.graphics.Sprite;
import mono.timing.Timing;
import ecs.Universe;
import ecs.Phase;
import hxd.Res;
import hxd.App;
import mono.animation.AnimSystem;
import mono.graphics.RenderSystem;
import mono.command.CommandSystem;
import mono.timing.TimingSystem;
import mono.input.InputSystem;
import mono.audio.AudioSystem;
import pause.PauseSystem;
import mono.timing.Updater;
import mono.graphics.RenderCommand;
import mono.graphics.DisplayListCommand;
import mono.animation.AnimCommand;
import states.StateSystem;
import states.StateCommand;
import ui.UISystem;
import mono.interactive.InteractiveSystem;
import mono.input.MouseSystem;

#if js
import mono.utils.ResTools;
#end

class Main extends App {
	
	public static var ecs(default, null):Universe;
	
	var updateLoop:Updater;
	var renderLoop:Updater;
	
	var fixedUpdate:Bool = false;
	var fixedRender:Bool = false;
	var updateFPS:Int = 60;
	var renderFPS:Int = 60;
	var maxAccumulatedTime:Float;
	
	var updatePhase:Phase;
	
	var lastStamp:Float;
	
	var loadedIn:Bool;
	
	static function main() {
		//#if !js
		Res.initEmbed();
		//#end
		new Main();
	}
	
	override function init() {
		
		loadedIn = false; // some stuff is null at the beginning on JS
		@:privateAccess haxe.MainLoop.add(() -> {}); // bug that prevents sound from playing past 1 sec
		
		//#if !js
		realInit();
		/*
		#else
		ResTools.initPakAuto("assets", () -> { // i need to write a multi use preloader
			realInit();
		}, p -> { });
		#end
		*/
	}
	
	function realInit() {
		
		// ng login
		// login info is in pak file to obfuscate a bit
		var login = ["test", "123"]; //Res.data.login.entry.getText().split("\n");
		var appid = StringTools.trim(login[0]);
		var key = StringTools.trim(login[1]);
		
		/*
		NG.createAndCheckSession(appid);
		NG.core.setupEncryption(key);
		
		if (!NG.core.loggedIn) {
			NG.core.requestLogin(
				out -> {
					if (out.match(SUCCESS)) postLogin();
					else NG.core.onLogin.addOnce(postLogin);
				}
			);
		}
		*/
		
		engine.backgroundColor = 0xfff3ecd9;
		
		ecs = Universe.create({
			entities : 400,
			phases : [
				{
					name : "update",
					enabled : false,
					systems : [
						InputSystem,
						MouseSystem,
						StateSystem,
						RenderSystem,
						AnimSystem,
						InteractiveSystem,
						UISystem,
						PauseSystem, // needed here?
						TimingSystem,
						AudioSystem,
						CommandSystem // we usually want this to be the final system
					]
				}
			]
		});
		
		// manually managing main phase, may change later
		updatePhase = ecs.getPhase("update");
		updatePhase.enable();
		
		lastStamp = haxe.Timer.stamp();
		
		updateLoop = Timing.every(1 / updateFPS, onUpdate); // prepUpdate?
		
		renderLoop = Timing.every(1 / renderFPS, onRender);
		s2d.setElapsedTime(1 / renderFPS);
		maxAccumulatedTime = 2 / renderFPS - 0.001; // don't update two or more frames at a time in fixed-time loops
		
		#if !js
		Window.getInstance().vsync = fixedUpdate = false; // no vsync, framerate equals real FPS
		#else
		fixedUpdate = true;
		#end
		
		#if js
		//hxd.Window.getInstance().useScreenPixels = false;
		#end
		
		onResize();
		
		postInit();
	}
	
	function postInit() {
		
		loadedIn = true;
		
		// set up globally required things
		
		var sheet = new Spritesheet();
		// load sprites in
		sheet.loadTexturePackerData(Res.sheets.sprites, Res.data.sprites.entry.getText());
		ecs.setResources(sheet, s2d);
		
		var input = new Input();
		
		var kmap = DefaultMappings.getDefaultKB();
		input.addDevice(new KeyboardInput(kmap));
		
		var pmap = DefaultMappings.getDefaultPad();
		input.addDevice(new PadInput(pmap));
		
		var mmap = DefaultMappings.getDefaultMouse();
		input.addDevice(new MouseInput(mmap));
		
		var debug = new states.DebugState(ecs);
		var game = new states.GameState(ecs);
		
		Command.queueMany(
			ADD_PARENT(s2d, S2D),
			ADD_SHEET(sheet, SPRITES),
			CREATE_BATCH(MAIN_BATCH, S2D, S2D_GAME),
			ADD_INPUT(input, P1),
			REGISTER_STATE(game, GAME_STATE),
			ENTER(GAME_STATE),
			REGISTER_STATE(debug, DEBUG_STATE),
			ENTER(DEBUG_STATE)
		);
	}
	
	override function mainLoop() {
		
		if (!Window.getInstance().vsync) {
			final targetDT = 1 / updateFPS;
			final safeTime = 1 / 1000;
			while (Timer.stamp() - lastStamp < targetDT - safeTime) {
				// limit !vsync to around the updateFPS
				// if not, the framerate will go into the thousands
				// @trethaller at Shiro Games
			}
		}
		
		final newTime = Timer.stamp();
		final dt = newTime - lastStamp;
		lastStamp = newTime;
		
		if (isDisposed || !loadedIn) return;
		
		update(dt);
	}
	
	override function update(dt:Float) {
		
		hxd.Timer.update(); // is this necessary?
		
		if (fixedUpdate) {
			// update at the desired FPS
			@:privateAccess
			if (updateLoop.counter + dt > maxAccumulatedTime) {
				// limit the effect of lag causing multiple "catch-up" updates at once
				updateLoop.counter = maxAccumulatedTime;
				updateLoop.update(0);
			}
			
			else updateLoop.update(dt);
		}
		
		else {
			// force update using whatever the real FPS ends up being
			s2d.setElapsedTime(dt);
			sevents.checkEvents();
			updatePhase.update(dt);
		}
		
		if (fixedRender) {
			// render at desired FPS
			renderLoop.update(dt);
		}
		
		else {
			// render as often as possible
			onRender();
		}
	}
	
	function onUpdate() {
		s2d.setElapsedTime(1 / updateFPS);
		sevents.checkEvents();
		updatePhase.update(1 / updateFPS);
	}
	
	override function onResize() {
		super.onResize();
		
		var window = Window.getInstance();
		
		// scale pixel art using NN instead of something smarter
		if ((window.width > 960 || window.height > 540)) {
			if (s2d.filter == null) s2d.filter = new Nothing();
		}
		
		else if (s2d.filter != null) s2d.filter = null;
		
		s2d.scaleMode = ScaleMode.LetterBox(960, 540); // is this correct?
	}
	
	function onRender() {
		if (!engine.begin()) return;
		s2d.render(engine);
		engine.end();
	}
	
	function postLogin() {
		trace("logged in");
		NG.core.requestMedals(out2 -> {
			if (out2.match(SUCCESS)) {
				trace("got medals");
				ecs.setResources(NG.core); // add ng once loaded
			}
		});
	}
}