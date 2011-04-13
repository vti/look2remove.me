package Look2RemoveMe::Action;

use strict;
use warnings;

use base 'Lamework::Action';

sub new {
    my $self = shift->SUPER::new(@_);

    $self->set_layout('layout');

    return $self;
}

1;
