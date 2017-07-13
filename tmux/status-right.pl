#!/usr/bin/env perl

use strict;
use warnings;

# initialize the $first scalar for checking wether we should add the arrow for the section {{{
#my($lsd, $gsd);
# }}}

# set the directory containing the scripts {{{
my $scriptdir = "$ENV{HOME}/.scripts/";
chomp(my $os = lc(`uname`));
# }}}

# define the subroutine for creating sections easely {{{
sub section
{
	my($color, $data) = @_;

	if ($data eq '') {
		return;
	}

	print "#[fg=colour$color] $data";
	print "#[fg=colour8] ║";
}
# }}}

# define the subroutines that generate the data
sub battery
{
	chomp(my $output = `$scriptdir/$os/battery`);
	return $output;
}

sub inet
{
	my $device;
	if (-f $ENV{HOME}.'/.config/tmux/inet-device') {
		open(my $file, '<', $ENV{HOME}.'/.config/tmux/inet-device');
		chomp($device = <$file>);
		close($file);
	} else {
		$device = 'eth0';
	}

	chomp(my $output = `$scriptdir/$os/inet $device`);
	return $output;
}

sub load
{
	chomp(my $output = `$scriptdir/$os/load`);
	return $output;
}

sub mem
{
	chomp(my $output = `free -h | grep "Mem:" | awk '{print \$3}'`);
	return $output;
}

# set the sections {{{
&section(12, &inet);
&section(2, &load);
&section(2, &mem);
&section(11, &battery);
# }}}

