package Look2RemoveMe::Action::UploadImage;

use strict;
use warnings;

use base 'Look2RemoveMe::Action';

use Try::Tiny;

use Look2RemoveMe::Image;

sub run {
    my $self = shift;

    return unless $self->req->method eq 'POST';

    $self->set_var(type => 'image');
    $self->set_template('upload');

    my $upload = $self->req->upload('image');

    return $self->set_var('errors' => {image => 'Required'}) unless $upload;

    try {
        my $image = Look2RemoveMe::Image->new_from_upload($upload);

        $self->set_var(url => $self->url_for('view', id => $image->id));
        $self->set_template('upload_success');
    }
    catch {
        my $e = $_;

        die $e unless $e->isa('Look2RemoveMe::Exception');

        $self->set_var('errors' => {image => $e->error});
    };
}

1;
