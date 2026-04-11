//Modify this file to change what commands output to your statusbar, and recompile using the make command.
static const Block blocks[] = {
	/*Icon*/	/*Command*/		/*Update Interval*/	/*Update Signal*/
	{"", "cat /proc/loadavg | awk '{print $1}'",	30,		0},
	{"", "free -h | awk '/^Mem/ { print $3\"/\"$2 }' | sed s/i//g",	30,		0},
	{"", "cat /sys/class/power_supply/BAT1/capacity",	60,		0},
	{"", "amixer sget Master | awk -F'[][]' 'END{print $2}'",	0,		1},
	{"", "date '+%b %d %I:%M%p'",					5,		0},
};

//sets delimiter between status commands. NULL character ('\0') means no delimiter.
static char delim[] = " | ";
static unsigned int delimLen = 5;
