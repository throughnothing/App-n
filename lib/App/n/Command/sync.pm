package App::n::Command::sync;
use App::n -command;

# ABSTRACT: Sync your notes

sub abstract { 'Sync your notes' }
sub usage_desc { 'sync' }
sub description { 'Sync your notes with the origin remote.' }

sub execute {
    my ($self, $opt, $args) = @_;
    $self->app->git->run( 'pull' );
    $self->app->git->run( 'push' );
}

1;

