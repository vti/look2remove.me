package Look2RemoveMe::Middleware::StaticWithRTL;

use strict;
use warnings;

use base 'Plack::Middleware::Static';

use Look2RemoveMe::App::FileWithRTL;

sub _handle_static {
    my($self, $env) = @_;

    my $path_match = $self->path or return;
    my $path = $env->{PATH_INFO};

    for ($path) {
        my $matched = 'CODE' eq ref $path_match ? $path_match->($_) : $_ =~ $path_match;
        return unless $matched;
    }

    $self->{file} ||= Look2RemoveMe::App::FileWithRTL->new({ root => $self->root || '.', encoding => $self->encoding });
    local $env->{PATH_INFO} = $path; # rewrite PATH
    return $self->{file}->call($env);
}

1;
