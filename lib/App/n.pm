use strict;
use warnings;
package App::n;

# ABSTRACT: Simple. Git-based. Note-taking.

use App::Cmd::Setup -app;
use Moose;
use File::HomeDir qw( home );
use Git::Repository;
use Path::Class qw( dir file );

extends qw(MooseX::App::Cmd);

has notes_dir => ( is => 'rw', default => sub { dir( home . '/.notes' ) } );
has file_ext => ( is => 'rw', default => sub { 'md' } );
has editor => ( is => 'rw', default => sub { $ENV{EDITOR} || 'vim' } );
has git => (
    is => 'ro',
    lazy => 1,
    default => sub {
        my ( $self ) = @_;
        if( -d $self->notes_repo ) {
            return Git::Repository->new( git_dir => $self->notes_repo );
        } else {
            my ($cmd) = $self->prepare_command( qw( init ) );
            $self->execute_command( $cmd );
            return Git::Repository->new( git_dir => $self->notes_repo );
        }
    },
);

sub default_command { 'list' }
sub allow_any_unambiguous_abbrev { 1 };

sub notes_repo { dir( $_[0]->notes_dir, '/.git' ) }

sub get_notes {
    my ( $self, %args ) = @_;
    my $sort = $args{sort} // 1;

    opendir my $dh, $self->notes_dir;
    my @notes = map {
        file( $self->notes_dir, $_ )
    } grep { !/^\./ } readdir( $dh );

    # Sort only if requested
    @notes = sort { -M $a <=> -M $b } @notes if( $sort );
    # Filter if needed
    @notes = grep { /$args{search}/ } @notes if $args{search};

    # Return most recent match
    return \@notes;
};


=head1 NAME

App::n - Simple. Git-based. Note-taking.

=head1 SYNOPSIS

L<App::n> Allows you to easily create and edit notes whose every
change gets tracked in git. This is especially useful for storing
your notes in a C<gist> on L<GitHub|http://github.com>.

    $ n new todo # auto-initialize an empty git-repo and create todo note
    $ n init # Initialize an empty git repo for notes
    $ n init git@gist.github.com:12345 # Initialize notes from a gist
    $ n edit todo # Edit note (or create if it doesnt exist)
    $ n remove todo # Removo todo (will be prompted for verification)
    $ n sync # Do a pull && push of the git repo
    $ n list [filter] # List all your notes [filtered]

Abbreviations also work for every command, such as:

    $ n n todo # Create todo note
    $ n e todo # Edit todo note
    $ n r todo # Remove todo note
    $ n l to # List all notes that match "to"
    $ n s # Sync

Your notes are stored in a git repo at C<~/.notes>, and C<vim>
is the default editor but can be overwritten with the C<EDITOR>
environment variable.

=cut

1;

