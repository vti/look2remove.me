package Look2RemoveMe;

use strict;
use warnings;

use base 'Lamework';

use Plack::Builder;
use Look2RemoveMe::File;

sub compile_psgi_app {
    my $self = shift;

    my $app = sub {
        my $env = shift;

        return [404, [], ['404 Not Found']];
    };

    builder {
        enable '+Look2RemoveMe::Middleware::StaticWithRTL' => path =>
          qr{^/uploads/},
          root => "htdocs";

        enable 'Static' => path =>
          qr{\.(?:js|css|jpe?g|gif|png|html?|swf|ico)$},
          root => "htdocs";

        enable 'SimpleLogger', level => 'debug';

        enable '+Lamework::Middleware::RoutesDispatcher';

        enable '+Lamework::Middleware::ActionBuilder';

        enable '+Lamework::Middleware::ViewDisplayer';

        $app;
    };
}

sub startup {
    my $self = shift;

    my $routes = $self->routes;

    $routes->add_route(
        '/',
        name   => 'index',
        defaults => {action => 'Index'},
        method => 'get'
    );
    $routes->add_route(
        '/',
        name     => 'index',
        defaults => {action => 'Upload'},
        method   => 'post'
    );
    $routes->add_route(
        '/:id',
        name     => 'view',
        defaults => {action => 'View'}
    );

    Look2RemoveMe::File->set_root($self->home->catfile('htdocs', 'uploads'));

    return $self;
}

1;
