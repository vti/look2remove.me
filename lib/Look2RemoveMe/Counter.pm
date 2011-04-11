package Look2RemoveMe::Counter;

use strict;
use warnings;

use Lamework::Registry;

sub new {
    my $class = shift;

    my $self = {};
    bless $self, $class;

    return $self;
}

sub total {
    my $self = shift;

    return int $self->_slurp;
}

sub increment {
    my $self = shift;

    my $total = $self->total;
    open my $file, '>', $self->_path or die $!;
    print $file $total + 1;

    return $self;
}

sub _slurp {
    my $self = shift;

    open my $file, '<', $self->_path or return '0';
    return do {local $/; <$file>};
}

sub _path {
    my $self = shift;

    my $home = Lamework::Registry->get('home');

    return $home->catfile('counter.txt');
}

1;
