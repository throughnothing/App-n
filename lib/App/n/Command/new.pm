package App::n::Command::new;
use App::n -command;
use Path::Class qw( dir file );

# ABSTRACT: Edit your notes

sub abstract { 'Create a note' }
sub usage_desc { 'new [title]' }
sub description { 'Create a note by title.'  }

sub execute {
    my ($self, $opt, $args) = @_;

    my $title = join ' ', @$args;
    die "Need a title!" unless $title;

    my $cmd = [ $self->app->editor ];
    ( my $title_file = $title ) =~ s/ /-/g;
    $title_file = file( $self->app->notes_dir,
        join( '.', $title_file, $self->app->file_ext ) );

    push @$cmd, $title_file;
    system  join( ' ', @$cmd );

    if( -e $file ) {
        # When they are done editing, commit
        $self->app->git->run( add => $file->stringify );
        $self->app->git->run( commit, '-m', "Created " . $file->basename );
    }
}

1;
