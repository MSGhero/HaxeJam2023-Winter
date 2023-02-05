enum abstract BatchID(String) to String {
	var MAIN_BATCH;
}

enum abstract LayerID(Int) to Int {
	// most rear to most front
	var BG;
	var S2D_GAME;
	var DEBUG;
}

enum abstract SheetID(String) to String {
	var SPRITES;
}

enum abstract ParentID(String) to String {
	var S2D;
	var GAME;
}

enum abstract InputID(String) to String {
	var DEBUG;
	var MENU;
	var P1;
	var P2;
	var P3;
	var P4;
}

enum abstract StateID(Int) to Int {
	var GAME_STATE;
	var DEBUG_STATE;
}