package Look2RemoveMe::Action::SubmitText;

use strict;
use warnings;

use base 'Look2RemoveMe::Action';

use Try::Tiny;

use Look2RemoveMe::Text;

sub run {
    my $self = shift;

    return unless $self->req->method eq 'POST';

    $self->set_var(type => 'text');
    $self->set_template('upload');

    my $text = $self->req->param('text');

    return $self->set_var('errors' => {text => 'Required'})
      unless defined $text && $text ne '' && $text !~ m/^\s+$/;

    try {
        my $text = Look2RemoveMe::Text->new_from_string($text);

        $self->set_template('upload_success');
        $self->set_var(url => $self->url_for('view', id => $text->id));
    }
    catch {
        my $e = $_;

        die $e unless $e->isa('Look2RemoveMe::Exception');

        $self->set_var('errors' => {text => $e->error});
    };
}

1;
