package Look2RemoveMe::Action;

use strict;
use warnings;

use base 'Lamework::Action';

sub new {
    my $self = shift->SUPER::new(@_);

    $self->set_layout('layout');

    $self->set_var(
        loc => sub { $self->{env}->{'lamework.i18n.maketext'}->($_[1]) });
    $self->set_var(language  => $self->{env}->{'lamework.i18n.language'});
    $self->set_var(languages => $self->{env}->{'lamework.i18n.languages'});

    return $self;
}

1;
