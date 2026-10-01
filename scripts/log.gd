class_name Log

enum LogLevel {
	ERROR,
	WARN,
	INFO,
	DEBUG,
}

static var enabled: bool = true
static var log_level: LogLevel = LogLevel.DEBUG

## Cache of formatted peer id (e.g. "0042" or "HOST") -> assigned bg Color,
## so repeated lookups for the same id skip the HSV math.
static var _peer_bg_colors: Dictionary = { }

## Stepping hue by the golden ratio conjugate (a Weyl sequence) spreads
## colors evenly around the wheel. The hue is derived from the peer id
## itself (not the order ids first appear), so a given id always gets the
## same color, and two ids that happen to be "first seen" in different
## processes (e.g. host vs. a client, each with their own static state)
## won't both land on the same color by coincidence of ordering.
const _HUE_STEP: float = 0.618033988749895
const _BG_SATURATION: float = 0.65
const _BG_VALUE: float = 0.55


static func error(msg: String, multiplayer_api: MultiplayerAPI) -> void:
	if enabled and log_level >= LogLevel.ERROR:
		_print("ERROR", msg, multiplayer_api)


static func warn(msg: String, multiplayer_api: MultiplayerAPI) -> void:
	if enabled and log_level >= LogLevel.WARN:
		_print("WARN", msg, multiplayer_api)


static func info(msg: String, multiplayer_api: MultiplayerAPI) -> void:
	if enabled and log_level >= LogLevel.INFO:
		_print("INFO", msg, multiplayer_api)


static func debug(msg: String, multiplayer_api: MultiplayerAPI) -> void:
	if enabled and log_level >= LogLevel.DEBUG:
		_print("DEBUG", msg, multiplayer_api)


## Shared by all four levels: highlights the whole line's background with
## a color unique to the peer id, and swaps the whole line's text to
## black/white (whichever contrasts more) so it stays readable regardless
## of how light or dark that id's assigned color turns out to be.
static func _print(level_name: String, msg: String, multiplayer_api: MultiplayerAPI) -> void:
	var peer_id: int = multiplayer_api.get_unique_id()
	var peer_str: String = format_peer_id(peer_id)
	var bg: Color = _get_peer_bg_color(peer_id, peer_str)
	var text_color: String = "black" if bg.get_luminance() > 0.5 else "white"

	print_rich(
		"[bgcolor=#%s][color=%s][%s][%s] %s: %s[/color][/bgcolor]" % \
				[bg.to_html(false), text_color, peer_str, level_name, get_timestamp(), msg]
	)


static func format_peer_id(peer_id: int) -> String:
	return "HOST" if peer_id == Constants.HOST_ID else "%04d" % (peer_id % 10000)


static func _get_peer_bg_color(peer_id: int, peer_str: String) -> Color:
	if not _peer_bg_colors.has(peer_str):
		var hue: float = fmod(float(peer_id) * _HUE_STEP, 1.0)
		_peer_bg_colors[peer_str] = Color.from_hsv(hue, _BG_SATURATION, _BG_VALUE)
	return _peer_bg_colors[peer_str]


static func get_timestamp() -> String:
	var tick: int = Time.get_ticks_msec()
	var ms: String = str(tick).erase(str(tick).length() - 1, 1)
	var timestamp: String = str(int(tick / 60000.0)).pad_zeros(2) + ":" + \
			str(int(tick / 1000.0)).pad_zeros(2) + "." + ms + "\t"
	return timestamp
