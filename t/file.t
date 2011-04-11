use strict;
use warnings;

use Test::More tests => 10;

use_ok('Look2RemoveMe::File');

my $file = Look2RemoveMe::File->new(id => 'unknown');
ok !$file->exists;
eval { $file->remove; };
ok $@;

Look2RemoveMe::File->set_root('t/file');

$file = Look2RemoveMe::File->new(id => 'abfoo.jpg');
is $file->slurp => "hello\n";
ok $file->exists;

$file = Look2RemoveMe::File->new_from_path('t/file/ab/foo.jpg');
is $file->slurp => "hello\n";
ok $file->exists;

$file = Look2RemoveMe::File->create_from_path($file->path);
is $file->slurp => "hello\n";
ok $file->exists;
$file->remove;
ok !$file->exists;
