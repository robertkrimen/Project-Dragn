package Project::Dragn;

use warnings;
use strict;

=head1 NAME

Project::Dragn -

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';

use Moose;

use Project::Dragn::Model;

use Path::Class;

has bdb_file => qw/is ro lazy_build 1/;
sub _build_bdb_file {
    return shift->path_mapper->file( 'run/dragn.bdb' );
}

has model_scope => qw/is rw/;

has model => qw/is ro lazy_build 1/;
sub _build_model {
    require KiokuDB;
    my $self = shift;
    my $bdb_file = $self->bdb_file;
    $bdb_file->parent->mkpath unless -d $bdb_file;
    my $model = Project::Dragn::Model->connect( "bdb:dir=$bdb_file", create => 1 );
    $self->model_scope( $model->new_scope );
    $model;
}

has path_mapper => qw/is ro lazy_build 1/, handles => [qw/ dir file /];
sub _build_path_mapper {
    require Path::Mapper;
    my $self = shift;
    return Path::Mapper->new( base => '.' );
}

has uri => qw/is rw lazy_build 1/;
sub _build_uri {
    require URI::PathAbstract;
    return URI::PathAbstract->new( 'http://example.com' );
}

sub home {
    return shift->home_dir( @_ );
}

sub home_dir {
    return shift->path_mapper->dir( '/' );
}

sub populate {
    my $self = shift;
    $self->model->populate( $self );
}

=head1 AUTHOR

Robert Krimen, C<< <rkrimen at cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-project-dragn at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Project-Dragn>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Project::Dragn


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Project-Dragn>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Project-Dragn>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Project-Dragn>

=item * Search CPAN

L<http://search.cpan.org/dist/Project-Dragn/>

=back


=head1 ACKNOWLEDGEMENTS


=head1 COPYRIGHT & LICENSE

Copyright 2009 Robert Krimen, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.


=cut

1; # End of Project::Dragn
