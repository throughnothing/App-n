# NAME

App::n - Simple. Git-based. Note-taking.

# VERSION

version 0.001

# SYNOPSIS

[App::n](http://search.cpan.org/perldoc?App::n) Allows you to easily create and edit notes whose every
change gets tracked in git. This is especially useful for storing
your notes in a `gist` on [GitHub](http://github.com).

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

Your notes are stored in a git repo at `~/.notes`, and `vim`
is the default editor but can be overwritten with the `EDITOR`
environment variable.

# NAME

App::n - Simple. Git-based. Note-taking.

# AUTHOR

William Wolf <throughnothing@gmail.com>

# COPYRIGHT AND LICENSE



William Wolf has dedicated the work to the Commons by waiving all of his
or her rights to the work worldwide under copyright law and all related or
neighboring legal rights he or she had in the work, to the extent allowable by
law.

Works under CC0 do not require attribution. When citing the work, you should
not imply endorsement by the author.