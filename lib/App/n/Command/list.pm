package App::n::Command::list;
use App::n -command;

# ABSTRACT: List your notes

sub abstract { 'List your notes' }
sub usage_desc { 'list [filter]' }
sub description {
q!List your notes.

You can pass an optional filter string to filter
the titles of all your notes.
!
}

sub execute {
    my ($self, $opt, $args) = @_;
    my $notes = $self->app->get_notes( search => $search );
    # Return most recent match
    print $_->basename . "\n" for( @$notes );
}

1;

