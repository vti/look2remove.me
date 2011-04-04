package Look2RemoveMe::Action::View;

use strict;
use warnings;

use base 'Look2RemoveMe::Action';

use Look2RemoveMe::Registry;
use Look2RemoveMe::File;
use Look2RemoveMe::Image;

sub run {
    my $self = shift;

    my $id = $self->captures->{id};

    $self->_view_text($id);
}

sub _view_text {
    my $self = shift;
    my ($id) = @_;

    my $text = Look2RemoveMe::Text->new(id => $id);

    return $self->render_not_found unless $text->exists;

    my $content = $text->slurp;
    $text->remove;

    $self->set_var(text => $content);
}

sub _view_image {
    my $self = shift;
    my ($id) = @_;

    my $image = Look2RemoveMe::Image->new(id => $id);

    return $self->render_not_found unless $image->exists;

    my $path = $self->_realpath_to_www($image->realpath);

    $self->set_var(image => {src => $path});
}

sub _realpath_to_www {
    my $self = shift;
    my ($path) = @_;

    my $home = Look2RemoveMe::Registry->get('home');
    $home = File::Spec->catfile($home, 'htdocs');
    $path =~ s{^$home}{};

    return $path;
}

1;
