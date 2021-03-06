package Look2RemoveMe::Action::Upload;

use strict;
use warnings;

use base 'Look2RemoveMe::Action';

use Try::Tiny;
use Turnaround::Exception;

use Look2RemoveMe::File;

sub run {
    my $self = shift;

    $self->set_var(type => 'image');
    $self->set_template('index');

    my $upload = $self->req->upload('image');

    return $self->set_var('errors' => {image => 'Required'}) unless $upload;

    my $max_size_in_megs = $self->service('config')->{max_upload_size} || 10;

    try {
        raise 'Turnaround::Exception::Base' => "Doesn't look like an image to me"
          unless $upload->content_type =~ m{^image/};

        if ($upload->size > $max_size_in_megs * 1024 * 1024) {
            Turnaround::Exception->throw(
                "File size is too big (max $max_size_in_megs Mb)");
        }

        my $image = Look2RemoveMe::File->create_from_path($upload->path);

        $self->set_var(url => $self->url_for('view', id => $image->id));
        $self->set_template('upload_success');
    }
    catch {
        my $e = $_;

        $e->rethrow unless $e->does('Turnaround::Exception');

        $self->set_var('errors' => {image => $e->message});
    };
}

1;
