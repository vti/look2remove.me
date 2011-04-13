#!/usr/bin/perl

use Plack::Loader;

my $app = Plack::Util::load_psgi("look2remove.me.psgi");
Plack::Loader->auto->run($app);
