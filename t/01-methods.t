use Test2::V0;

ok lives { require Music::SimpleDrumMachine }, 'Music::SimpleDrumMachine loads'
    or bail_out('cannot load Music::SimpleDrumMachine');

{
    package Test::FakeLoop;
    sub new { bless {}, shift }
    sub add { 1 }
    sub run { 1 } # return immediately instead of blocking forever
}

# typeglob, symbol-table entry for the name _loop in the package
no warnings 'redefine';
local *Music::SimpleDrumMachine::_loop = sub { Test::FakeLoop->new };

sub new_obj {
    my (%args) = @_;
    my $obj;
    ok lives { $obj = Music::SimpleDrumMachine->new(%args) }, 'new() lives'
        or diag $@;
    isa_ok $obj, ['Music::SimpleDrumMachine'], 'object';
    return $obj;
}

subtest defaults => sub {
    my $obj = new_obj( port_name => 'test' );
    is $obj->beats,      16,              'beats';
    is $obj->bpm,        120,             'bpm';
    is $obj->chan,       9,               'chan';
    is $obj->divisions,  4,               'divisions';
    is $obj->fill_crash, 1,               'fill_crash';
    is $obj->filling,    1,               'filling';
    is $obj->next_fill,  '_default_fill', 'next_fill';
    is $obj->next_part,  '_default_part', 'next_part';
    is $obj->port_name,  'test',          'port_name';
    is $obj->ppqn,       24,              'ppqn';
    is $obj->velo_max,   10,              'velo_max';
    is $obj->velo_min,   -10,             'velo_min';
    is $obj->velo_off,   110,             'velo_off';
    is $obj->verbose,    0,               'verbose';
    is $obj->add_drums,  [],              'add_drums';

    ref_ok $obj->drums, 'HASH', 'drums';
    ref_ok $obj->parts, 'HASH', 'parts';
    ref_ok $obj->fills, 'HASH', 'fills';

    is $obj->parts, hash { field _default_part => D(); etc }, 'default parts exist';
    is $obj->fills, hash { field _default_fill => D(); etc }, 'default fills exist';
};

subtest drums => sub {
    my $obj   = new_obj( port_name => 'test' );
    my $drums = $obj->drums;
    is $drums->{kick}{num},   36, 'kick num';
    is $drums->{snare}{num},  38, 'snare num';
    is $drums->{closed}{num}, 42, 'closed num';
    is $drums->{kick}{chan},  9,  'kick chan uses the shared chan by default';
    is $drums->{snare}{chan}, 9,  'snare chan uses the shared chan by default';

    $obj = new_obj( port_name => 'test', chan => -1 );
    isnt $obj->drums->{kick}{chan}, $obj->drums->{snare}{chan},
        'multi-timbral mode (chan => -1) assigns distinct channels';
};

subtest add_drums => sub {
    my $obj = new_obj(
        port_name => 'test',
        add_drums => [ { drum => 'gong', num => 99 } ],
    );
    is $obj->drums, hash { field gong => D(); etc }, 'added drum exists';
    is $obj->drums->{gong}{num},  99, 'added drum num';
    is $obj->drums->{gong}{chan}, 9,  'added drum uses the shared chan by default';

    $obj = new_obj(
        port_name => 'test',
        chan      => -1,
        add_drums => [ { drum => 'gong', num => 99, chan => 5 } ],
    );
    is $obj->drums->{gong}{chan}, 5, 'added drum honors an explicit chan';
};

subtest velocity => sub {
    my $obj = new_obj(
        port_name => 'test',
        velo_min  => 0,
        velo_max  => 0,
        velo_off  => 127,
    );
    is $obj->velocity, 127, 'fixed velocity when min == max == 0';

    $obj = new_obj(
        port_name => 'test',
        velo_min  => -10,
        velo_max  => 10,
        velo_off  => 110,
    );
    my $got = $obj->velocity;
    ok $got >= 100 && $got <= 120, "velocity in range: $got";
};

subtest parts_and_fills => sub {
    my $obj = new_obj(port_name => 'test');

    my ($next, $patterns) = $obj->_default_part;
    is $next, '_default_part', '_default_part next';
    is $patterns, hash {
        field kick   => D();
        field snare  => D();
        field closed => D();
        etc;
    }, '_default_part has kick, snare and closed patterns';

    my ($fnext, $fpatterns);
    for (1 .. 20) {
        last if lives { ($fnext, $fpatterns) = $obj->_default_fill };
    }
    is $fnext, '_default_fill', '_default_fill next';
    is $fpatterns, hash { field snare => D(); etc },
        '_default_fill has a snare pattern';
};

done_testing;