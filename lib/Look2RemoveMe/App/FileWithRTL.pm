package Look2RemoveMe::App::FileWithRTL;

use strict;
use warnings;

use base 'Plack::App::File';

use Look2RemoveMe::File;

use File::MimeInfo::Magic ();
use HTTP::Date;
use Plack::MIME;
use Plack::Util;

sub serve_path {
    my($self, $env, $file) = @_;

    my $content_type = File::MimeInfo::Magic::mimetype($file) || 'text/plain';

    if ($content_type =~ m!^text/!) {
        $content_type .= "; charset=" . ($self->encoding || "utf-8");
    }

    open my $fh, "<:raw", $file
        or return $self->return_403;

    my $home = $env->{'turnaround.services'}->service('home');

    my @stat = stat $file;
    Plack::Util::set_io_path($fh, Cwd::realpath($file));

    my $file_to_remove = Look2RemoveMe::File->new_from_path($file);
    $file_to_remove->remove;

    return [
        200,
        [
            'Content-Type'   => $content_type,
            'Content-Length' => $stat[7],
            'Last-Modified'  => HTTP::Date::time2str( $stat[9] )
        ],
        $fh
    ];
}

1;
