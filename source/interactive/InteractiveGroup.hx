package interactive;

enum abstract InteractiveGroup(Int) from Int to Int {
	var DISABLED = 0x01;
	var SELECT_SEED = 0x02;
}