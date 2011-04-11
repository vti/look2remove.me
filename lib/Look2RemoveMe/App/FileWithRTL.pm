package Look2RemoveMe::App::FileWithRTL;

use strict;
use warnings;

use base 'Plack::App::File';

use Lamework::Registry;
use Look2RemoveMe::File;

use Plack::Util;
use Plack::MIME;
use HTTP::Date;

sub serve_path {
    my($self, $env, $file) = @_;

    my $content_type = Plack::MIME->mime_type($file) || 'text/plain';

    if ($content_type =~ m!^text/!) {
        $content_type .= "; charset=" . ($self->encoding || "utf-8");
    }

    open my $fh, "<:raw", $file
        or return $self->return_403;

    my $home = Lamework::Registry->get('home');

    my $file_to_remove = Look2RemoveMe::File->new_from_path($home->catfile($file));
    $file_to_remove->remove;

    my @stat = stat $file;

    Plack::Util::set_io_path($fh, Cwd::realpath($file));

    return [
        200,
        [
            'Content-Type'   => $content_type,
            'Content-Length' => $stat[7],
            'Last-Modified'  => HTTP::Date::time2str( $stat[9] )
        ],
        $fh,
    ];
}

1;
