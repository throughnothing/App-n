package App::n::Command::init;
use App::n -command;
use Git::Repository;

# ABSTRACT: Initialize your notes

sub abstract { 'Initialize your notes directory' }
sub usage_desc { "init [git_repo]" }
sub description {
q!Initialize your Notes directory.

You can optionally pass a remote git repo to
clone from for initialization.!
}

sub execute {
    my ($self, $opt, $args) = @_;

    die "Notes directory (" . $self->app->notes_dir . ") already exists!"
        if ( -d $self->app->notes_dir );

    if( $args->[0] ) {
        print "Initializing notes from $args->[0]...\n";
        Git::Repository->run(
            clone => $args->[0], $self->app->notes_dir->stringify );
    } else {
        print "Initializing notes (" . $self->app->notes_dir . ")...\n";
        print "TEST\n";
        print Git::Repository->run( init => $self->app->notes_dir->stringify );
        print "\n\nDONE\n";
    }
}

1;
