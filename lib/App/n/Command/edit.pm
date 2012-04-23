package App::n::Command::edit;
use App::n -command;
use Path::Class qw( dir file );

# ABSTRACT: Edit your notes

sub abstract { 'Edit (or create, if not found) a note' }
sub usage_desc { 'edit [title / partial title]' }
sub description {
q!
Edit (or create, if no match found) a note.

This will search all your notes for a match,
and return the most recently modified match
if anything is found.

If no matches are found, a new note will be
created.
!
}

sub execute {
    my ($self, $opt, $args) = @_;

    die "Need a title!" unless @$args > 0;

    my $git = $self->app->git;
    my $cmd = [ $self->app->editor ];
    my $file = $self->_get_file( $args );
    my $new = ( -e $file );

    push @$cmd, $file;
    system join( ' ', @$cmd );

    if( -e $file ) {
        # When they are done editing, commit
        my $verb = $new ? "Created " : "Updated ";
        $git->run( add => $file->stringify );
        $git->run( commit, '-m', $verb . $file->basename );
    }
}

sub _get_file {
    my ($self, $args) = @_;

    my ($title, $file) = ( join( ' ', @{ $args } ) );
    my $existing_file = $self->_find_existing( $title );

    if( !$existing_file ) {
        ( my $title_file = $title ) =~ s/ /-/g;
        $file = file($self->app->notes_dir, $title_file);
        if( ! ( $file->basename ~~ /\./ ) ) {
            # Add file ext if no . found
            $file = file( join( '.', $file, $self->app->file_ext ) );
        }
    } else {
        $file = $existing_file;
    }

    $file;
}

sub _find_existing {
    my ( $self, $search ) = @_;
    my $notes = $self->app->get_notes( search => $search );
    # Return most recent match
    return $notes->[0];
}

1;
