package Look2RemoveMe::Action::View;

use strict;
use warnings;

use base 'Lamework::Action';

use Lamework::Registry;
use Look2RemoveMe::File;

sub run {
    my $self = shift;

    my $id = $self->captures->{id};

    my $image = Look2RemoveMe::File->new(id => $id);

    return $self->render_not_found unless $image->exists;

    my $path = $self->_path_to_www($image->path);

    $self->set_var(image => {src => $path});
}

sub _path_to_www {
    my $self = shift;
    my ($path) = @_;

    my $home = Lamework::Registry->get('home');
    $home = File::Spec->catfile($home, 'htdocs');
    $path =~ s{^$home}{};

    return $path;
}

1;
