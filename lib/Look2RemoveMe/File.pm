package Look2RemoveMe::File;

use strict;
use warnings;

use Digest::MD5 ();
use File::Spec;
use File::Basename ();
use File::Copy     ();
use File::Path     ();

our $ROOT;

sub set_root {
    my $class = shift;

    $ROOT = File::Spec->catfile(@_);
}

sub new {
    my $class = shift;

    my $self = {@_};
    bless $self, $class;

    die 'id is required' unless defined $self->{id};

    $self->{root} = $ROOT;

    return $self;
}

sub new_from_path {
    my $class = shift;
    my ($path) = @_;

    open my $file, '<', $path or die $!;

    my $ctx = Digest::MD5->new;

    $ctx->addfile($file);
    $ctx->add(time);

    my $id = $ctx->hexdigest;

    my $self = $class->new(id => $id);

    $self->_prepare_path;

    File::Copy::copy($path, $self->realpath) or die $!;

    return $self;
}

sub new_from_string {
    my $class = shift;
    my ($string) = @_;

    my $ctx = Digest::MD5->new;

    $ctx->add($string);
    $ctx->add(time);

    my $id = $ctx->hexdigest;

    my $self = $class->new(id => $id);

    $self->_prepare_path;

    open my $file, '>', $self->realpath or die $!;

    print $file $string;

    return $self;
}

sub id { shift->{id} }

sub realpath {
    my $self = shift;

    my $id = $self->{id};

    my $prefix = substr($id, 0, 2);
    my $path = substr($id, 2);

    return File::Spec->catfile($self->{root}, $prefix, $path);
}

sub exists {
    my $self = shift;

    return -e $self->realpath;
}

sub slurp {
    my $self = shift;

    open my $file, '<', $self->realpath or die $!;

    local $/;

    return <$file>;
}

sub remove {
    my $self = shift;

    unlink $self->realpath;
}

sub _prepare_path {
    my $self = shift;

    my $directory = File::Basename::dirname($self->realpath);
    File::Path::make_path($directory);
}

1;
