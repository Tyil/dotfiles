#!/usr/bin/env perl

sub color
{
	my($text, $foreground, $background) = @_;
	return "\x1b[38;5;${foreground}m\x1b[48;5;${background}m${text}\x1b[0m";
}

print ' ';
print &color(' #393939 ', 15, 0).'  ';
print &color(' #ca674a ', 15, 1).'  ';
print &color(' #96a967 ', 15, 2).'  ';
print &color(' #d3a94a ', 15, 3).'  ';
print &color(' #5778c1 ', 15, 4).'  ';
print &color(' #9c35ac ', 15, 5).'  ';
print &color(' #6eb5f3 ', 15, 6).'  ';
print &color(' #a9a9a9 ', 15, 7).'  ';
print "\n ";

print &color(' #535551 ', 0, 8).'  ';
print &color(' #ea2828 ', 0, 9).'  ';
print &color(' #87dd32 ', 0, 10).'  ';
print &color(' #f7e44d ', 0, 11).'  ';
print &color(' #6f9bca ', 0, 12).'  ';
print &color(' #a97ca4 ', 0, 13).'  ';
print &color(' #32dddd ', 0, 14).'  ';
print &color(' #e9e9e7 ', 0, 15).'  ';
print "\n";

exit;

