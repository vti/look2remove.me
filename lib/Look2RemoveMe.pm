package Look2RemoveMe;

use strict;
use warnings;

use base 'Lamework';

use Plack::Builder;

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
          qr{\.(?:js|css|jpe?g|gif|png|html?|js|css|swf|ico)$},
          root => "htdocs";

        enable 'SimpleLogger', level => 'debug';

        enable '+Lamework::Middleware::RoutesDispatcher';

        enable '+Lamework::Middleware::ActionBuilder';

        enable '+Lamework::Middleware::ViewDisplayer';

        $app;
    };
}

sub setup {
    my $self = shift;

    my $routes = $self->routes;

    $routes->add_route('/', name => 'root');
    $routes->add_route('/messages', defaults => {action => 'Message'});
    $routes->add_route('/messages/:id', defaults => {action => 'MessageShow'});
    $routes->add_route('/images',     defaults => {action => 'Image'});
    $routes->add_route('/images/:id', defaults => {action => 'ImageShow'});

    return $routes;
}

1;
