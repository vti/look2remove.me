#!/usr/bin/env perl

use strict;
use warnings;

use Plack::Loader;

my $root;

BEGIN {
    use Cwd            ();
    use File::Spec     ();
    use File::Basename ();

    $root = File::Spec->rel2abs(File::Basename::dirname(Cwd::realpath(__FILE__)));
}

my $app = Plack::Util::load_psgi("$root/look2remove.me.psgi");
Plack::Loader->auto->run($app);
