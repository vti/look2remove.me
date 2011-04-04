package Look2RemoveMe::Image;

use strict;
use warnings;

use base 'Look2RemoveMe::File';

use Look2RemoveMe::Exception;

sub new_from_upload {
    my $class = shift;
    my ($upload) = @_;

    Look2RemoveMe::Exception->throw("Doesn't look like an image to me")
      unless $upload->content_type =~ m{^image/};

    my $max_size_in_megs = 1;
    if ($upload->size > $max_size_in_megs * 1024 * 1024) {
        Look2RemoveMe::Exception->throw("File size is too big (max $max_size_in_megs Mb)");
    }

    return $class->SUPER::new_from_path($upload->path);
}

1;
