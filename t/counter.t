use strict;
use warnings;

use Test::More tests => 5;

use_ok('Look2RemoveMe::Counter');

use lib 'contrib/lamework/lib';

use Lamework::Home;
use Lamework::Registry;

Lamework::Registry->set(home => Lamework::Home->new('t/counter'));

my $counter = Look2RemoveMe::Counter->new;

is $counter->total => 0;

$counter->increment;

is $counter->total => 1;
