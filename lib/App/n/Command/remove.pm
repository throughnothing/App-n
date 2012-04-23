package App::n::Command::remove;
use App::n -command;

# ABSTRACT: Remove a note

sub abstract { 'Remove a note' }
sub usage_desc { 'remove' }
sub description { 'Remove a note by name or by filter.' }

sub execute {
    my ($self, $opt, $args) = @_;

    my $search = join ' ', @$args;
    die "Specify note to remove!" unless $search;

    my $notes = $self->app->get_notes( search => $search );
    my $to_rm = $notes->[0];
    print join( ' ', "Remove", $to_rm->basename, "?" ) . "\n";
    my $res = <STDIN>;

    if( $res ~~ /^y(es)?$/i ) {
        $git->run( rm => $to_rm->stringify );
        my $msg = "Removed " . $to_rm->basename . ".";
        $git->run( commit => -m => $msg );
        print "$msg\n";
    } else {
        print "Not Removing.\n";
    }
}

1;

