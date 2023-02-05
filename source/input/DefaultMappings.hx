package input;

import mono.input.PadInput.PadButtons;
import hxd.Key;
import mono.input.Input.InputMapping;

class DefaultMappings {
	
	public static function getDefaultKB() {
		
		var mapping = new InputMapping();
		
		mapping[Action.L] = [Key.LEFT, Key.A];
		mapping[Action.R] = [Key.RIGHT, Key.D];
		mapping[Action.U] = [Key.UP, Key.W];
		mapping[Action.D] = [Key.DOWN, Key.S];
		
		mapping[Action.SELECT] = [Key.Z, Key.SPACE, Key.ENTER];
		mapping[Action.BACK] = [Key.ESCAPE, Key.B, Key.X];
		
		mapping[Action.MUTE] = [Key.M];
		
		return mapping;
	}
	
	public static function getDefaultPad() {
		
		var mapping = new InputMapping();
		
		mapping[Action.L] = [PadButtons.LEFT_DPAD, PadButtons.LEFT_L_VIRTUAL];
		mapping[Action.R] = [PadButtons.RIGHT_DPAD, PadButtons.RIGHT_L_VIRTUAL];
		mapping[Action.U] = [PadButtons.UP_DPAD, PadButtons.UP_L_VIRTUAL];
		mapping[Action.D] = [PadButtons.DOWN_DPAD, PadButtons.DOWN_L_VIRTUAL];
		
		mapping[Action.SELECT] = [PadButtons.A];
		mapping[Action.BACK] = [PadButtons.B];
		
		return mapping;
	}
}