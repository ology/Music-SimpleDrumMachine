#!/usr/bin/env perl

use v5.36;

use Data::Dumper::Compact qw(ddc);
use Music::SimpleDrumMachine ();

my $port_name = shift || 'usb';
my $bpm       = shift || 120;
my $chan      = shift // 9;

my $dm = Music::SimpleDrumMachine->new(
    port_name => $port_name,
    bpm       => $bpm,
    chan      => $chan,
    add_drums => [ { drum => 'tom', num => 47 } ],
    next_part => 'part_A',
    parts     => { part_A => \&part_A },
    fills     => { fill_A => \&fill_A },
    next_fill => 'fill_A',
    verbose   => 1,
);

sub part_A {
    say 'part A';
    my %patterns = (
        hihat => [qw(1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0)],
        open  => [qw(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1)],
        kick  => [qw(1 0 0 0 0 0 0 0 1 0 1 0 0 0 0 0)],
        snare => [qw(0 0 0 0 1 0 0 0 0 0 0 0 1 0 0 0)],
        tom   => [qw(0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 0)],
    );
    my $next = 'part_A';
    return $next, \%patterns;
}
sub fill_A {
    say 'fill_A';
    my %patterns = (
        snare => [qw(1 0 1 0 1 1 1 1 0 1 0 1 1 0 0 0)],
        tom   => [qw(0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1)],
        hihat => [ (0) x 16 ],
        open  => [ (0) x 16 ],
        kick  => [ (0) x 16 ],
    );
    my $next = 'fill_A';
    return $next, \%patterns;
}