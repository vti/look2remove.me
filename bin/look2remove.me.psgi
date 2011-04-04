#!/usr/bin/env perl

use strict;
use warnings;

BEGIN {
    use Cwd            ();
    use File::Spec     ();
    use File::Basename ();

    my $root =
      File::Spec->rel2abs(File::Basename::dirname(Cwd::realpath(__FILE__)));

    unshift @INC, "$root/../lib";
    unshift @INC, "$root/../contrib/lamework/lib";
}

use Look2RemoveMe;

Look2RemoveMe->new;
