package Look2RemoveMe::Action;

use strict;
use warnings;

use base 'Lamework::Action';

sub new {
    my $self = shift->SUPER::new(@_);

    $self->set_layout('layout');

    $self->set_var(
        loc => sub { $self->{env}->{'lamework.i18n.maketext'}->loc($_[1]) });
    $self->set_var(language  => $self->{env}->{'lamework.i18n.language'});
    $self->set_var(languages => $self->{env}->{'lamework.i18n.languages'});

    return $self;
}

sub set_template {
    my $self = shift;
    my ($template) = @_;

    $self->{env}->{'lamework.displayer.template'} = $template;
}

sub set_layout {
    my $self = shift;
    my ($layout) = @_;

    $self->{env}->{'lamework.displayer.layout'} = $layout;
}

1;
