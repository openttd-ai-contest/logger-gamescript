require("version.nut");

class LoggerGSRegister extends GSInfo {
	function GetAuthor()		{ return "Ivan Fefer <fefer.ivan@gmail.com>"; }
	function GetName()			{ return "Logger"; }
	function GetDescription() 	{ return "Simple game script that logs company performance each quarter"; }
	function GetVersion()		{ return SELF_VERSION; }
	function GetDate()			{ return "2024-02-19"; }
	function CreateInstance()	{ return "LoggerGS"; }
	function GetShortName()		{ return "LOGS"; }
	function GetAPIVersion()	{ return "1.3"; }
	function GetURL()			{ return "https://github.com/openttd-ai-contest/logger-gamescript"; }

	function GetSettings() {
		AddSetting({
			name = "debug_level",
			description = "Debug Log level (higher = print more)",
			easy_value = 1, medium_value = 1, hard_value = 1, custom_value = 1,
			flags = CONFIG_INGAME,
			min_value = 0,
			max_value = 1});
		AddSetting({
			name = "end_year",
			description = "Year when the game ends",
			easy_value = 1985, medium_value = 1985, hard_value = 1985, custom_value = 1985,
			flags = CONFIG_INGAME,
			min_value = 1950,
			max_value = 2050});
	}
}

RegisterGS(LoggerGSRegister());
