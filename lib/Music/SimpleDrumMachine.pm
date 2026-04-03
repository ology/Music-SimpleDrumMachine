package Music::SimpleDrumMachine;

# ABSTRACT: Simple 16th-note Phrase Drummer

our $VERSION = '0.0100';

use Moo;
use strictures 2;
use Carp qw(croak);
use namespace::clean;

=head1 SYNOPSIS

  use Music::SimpleDrumMachine ();

  my $x = Music::SimpleDrumMachine->new(verbose => 1);

=head1 DESCRIPTION

C<Music::SimpleDrumMachine> is a Simple 16th-note Phrase Drummer.

=head1 ATTRIBUTES

=head2 verbose

  $verbose = $x->verbose;

Show progress.

=cut

has verbose => (
    is      => 'ro',
    isa     => sub { croak "$_[0] is not a boolean" unless $_[0] =~ /^[01]$/ },
    default => sub { 0 },
);

=head1 METHODS

=head2 new

  $x = Music::SimpleDrumMachine->new(verbose => 1);

Create a new C<Music::SimpleDrumMachine> object.

=for Pod::Coverage BUILD

=cut

1;
__END__

=head1 SEE ALSO

L<Moo>

L<http://somewhere.el.se>

=cut
