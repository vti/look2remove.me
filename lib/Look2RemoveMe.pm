package Look2RemoveMe;

use strict;
use warnings;

use base 'Lamework';

use Lamework::ActionFactory;
use Lamework::Config;
use Lamework::Dispatcher::Routes;
use Lamework::Displayer;
use Lamework::I18N;
use Lamework::Renderer::Caml;
use Lamework::Routes;

use Look2RemoveMe::File;

sub startup {
    my $self = shift;

    $self->{config} = {};

    my $config =
      Lamework::Config->new(home => $self->{home}->to_string)
      ->load('config.yml');
    $self->{config} = $config;

    $self->services->register(home   => $self->{home});
    $self->services->register(config => $self->{config});

    Look2RemoveMe::File->set_root($self->{home}->catfile('htdocs', 'uploads'));

    my $displayer =
      Lamework::Displayer->new(
        renderer => Lamework::Renderer::Caml->new(home => $self->{home}));

    my $i18n = Lamework::I18N->new(app_class => __PACKAGE__);

    $self->add_middleware(
        'Static',
        path => qr{^/(images|js|css)/},
        root => $self->{home}->catfile('htdocs')
    );

    $self->add_middleware(
        'ErrorDocument',
        404        => '/not_found',
        subrequest => 1
    );

    $self->add_middleware('HTTPExceptions');

    $self->add_middleware(
        '+Look2RemoveMe::Middleware::StaticWithRTL',
        path => qr{^/uploads/},
        root => $self->{home}->catfile('htdocs')
    );

    $self->add_middleware(
        'Session::Cookie',
        secret  => $self->{config}->{session}->{secret},
        expires => $self->{config}->{session}->{expires}
    );
    $self->add_middleware('CSRFBlock');

    $self->add_middleware('I18N', i18n => $i18n);

    $self->add_middleware('RequestDispatcher',
        dispatcher =>
          Lamework::Dispatcher::Routes->new(routes => $self->_build_routes));

    $self->add_middleware(
        'ActionDispatcher',
        action_factory => Lamework::ActionFactory->new(
            namespace => ref($self) . '::Action::'
        )
    );

    $self->add_middleware('ViewDisplayer', displayer => $displayer);

    return $self;
}

sub _build_routes {
    my $self = shift;

    my $routes = Lamework::Routes->new;

    $routes->add_route('/', name => 'index',  method => 'get');
    $routes->add_route('/', name => 'upload', method => 'post');
    $routes->add_route('/not_found', name => 'not_found');
    $routes->add_route('/:id',       name => 'view');

    return $routes;
}

1;
