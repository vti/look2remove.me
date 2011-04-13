package Look2RemoveMe::Action::View;

use strict;
use warnings;

use base 'Look2RemoveMe::Action';

use Lamework::Registry;
use Look2RemoveMe::File;

sub run {
    my $self = shift;

    my $id = $self->captures->{id};

    my $image = Look2RemoveMe::File->new(id => $id);

    return $self->render_not_found unless $image->exists;

    my $url = $self->_path_to_url($image->path);

    $self->set_layout(undef);
    $self->set_var(image => {src => $url});
}

sub _path_to_url {
    my $self = shift;
    my ($path) = @_;

    my $home = Lamework::Registry->get('home');
    $home = File::Spec->catfile($home, 'htdocs');
    $path =~ s{^$home}{};

    return $path;
}

1;
