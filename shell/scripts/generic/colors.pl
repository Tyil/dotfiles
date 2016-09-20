#!/usr/bin/env perl

$i = 0;

for ($color = 1; $color < 256; $color++) {
	print "\x1b[38;5;${color}m";
	printf("%03s:", $color);
	print "\x1b[48;5;${color}m     ";
	print "\x1b[0m";

	if ($i == 7) {
		print "\n";
		$i = 0;
		next;
	}

	print "  ";
	$i++;
}

# reset
print "\n";
exit;

