#!/usr/bin/env perl

# Play and clock an external MIDI device, like a drum machine or sequencer.
# Examples:
#   perl clocked-euclidean-drum-fills.pl fluid 90
#   perl clocked-euclidean-drum-fills.pl usb 100 -1

use v5.36;

use Math::Prime::XS qw(primes);
use Music::CreatingRhythms ();
use Music::SimpleDrumMachine ();

my $dm = Music::SimpleDrumMachine->new(
    port => shift || 'usb',
    bpm  => shift || 120,
    chan => shift // 9,
);

my %primes = ( # for computing patterns
    all  => [ primes($dm->beats) ],
    to_5 => [ primes(5) ],
    to_7 => [ primes(7) ],
);

my $mcr = Music::CreatingRhythms->new;

sub part_A($dm, $mcr, $primes) {
    say 'part A';
    # choose random primes to use by the hihat, kick, and snare
    my ($p, $q, $r) = primes_list($primes);
    my %patterns = (
        hihat => $mcr->euclid($p, $dm->beats),
        kick  => $mcr->euclid($q, $dm->beats),
        snare => $mcr->rotate_n($r, $mcr->euclid(2, $dm->beats)),
    );
    return %patterns;
}

sub part_B($dm, $mcr, $primes) {
    say 'part B';
    # choose a random prime to use by the hihat
    my ($p) = primes_list($primes);
    my %patterns = (
        hihat => $mcr->euclid($p, $dm->beats),
        kick  => [qw(1 0 0 0 0 0 0 0 1 0 0 0 0 0 0 1)],
        snare => [qw(0 0 0 0 1 0 0 0 0 0 0 0 1 0 1 0)],
    );
    return %patterns;
}

sub part_C($dm, $mcr, $primes) {
    say 'part C';
    # choose a random prime to use by the hihat
    my ($p) = primes_list($primes);
    my %patterns = (
        hihat => $mcr->euclid($p, $dm->beats),
        kick  => [qw(1 0 0 0 0 0 0 0 1 0 1 0 0 0 0 0)],
        snare => [qw(0 0 0 0 1 0 0 0 0 0 0 0 1 0 0 0)],
    );
    return %patterns;
}

sub primes_list($primes) {
    return map { $primes->{$_}[ int rand $primes->{$_}->@* ] } sort keys %$primes;
}