class_name Log

enum LogLevel { ERROR, WARN, INFO, DEBUG }

static var enabled: bool = true
static var log_level: LogLevel = LogLevel.DEBUG


static func error(msg: String, multiplayer_api: MultiplayerAPI) -> void:
	if enabled and log_level >= LogLevel.ERROR:
		print_rich("[color=red][ERROR] %s: %s[/color]" % \
			[format_peer_id(multiplayer_api.get_unique_id()), get_timestamp(), msg])


static func warn(msg: String, multiplayer_api: MultiplayerAPI) -> void:
	if enabled and log_level >= LogLevel.WARN:
		print_rich("[color=yellow][WARN] %s: %s[/color]" % \
			[format_peer_id(multiplayer_api.get_unique_id()), get_timestamp(), msg])


static func info(msg: String, multiplayer_api: MultiplayerAPI) -> void:
	if enabled and log_level >= LogLevel.INFO:
		print_rich("[color=white][%s][INFO] %s: %s[/color]" % \
			[format_peer_id(multiplayer_api.get_unique_id()), get_timestamp(), msg])


static func debug(msg: String, multiplayer_api: MultiplayerAPI) -> void:
	if enabled and log_level >= LogLevel.DEBUG:
		print_rich("[color=gray][%s][DEBUG] %s: %s[/color]" % \
			[format_peer_id(multiplayer_api.get_unique_id()), get_timestamp(), msg])


static func format_peer_id(peer_id: int) -> String:
	return "HOST" if peer_id == Constants.HOST_ID else "%04d" % (peer_id % 10000)


static func get_timestamp() -> String:
	var tick: int = Time.get_ticks_msec()
	var ms: String = str(tick).erase(str(tick).length() - 1, 1)
	var timestamp: String = str(int(tick/60000.0)).pad_zeros(2) + ":" + \
		str(int(tick/1000.0)).pad_zeros(2) + "." + ms + "\t"
	return timestamp
