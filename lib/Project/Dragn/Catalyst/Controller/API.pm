package Project::Dragn::Catalyst::Controller::API;

use strict;
use warnings;

use parent 'Catalyst::Controller::REST';

my @item = qw/apple banana cherry grape/;
my @collection = qw/Favorites Shiny Pretty Ugly/;

sub fresh :Local :ActionClass('REST') {}

sub fresh_GET {
    my ( $self, $ctx ) = @_;

    $self->status_ok( 
        $ctx,
        entity => {
            list => [ @item ],
        },
    );
}

sub collection_list :Path('collection/list') {
    my ( $self, $ctx ) = @_;

    $self->status_ok( 
        $ctx,
        entity => {
            list => [ @collection ],
        },
    );
}

sub default :Private {
    my ( $self, $ctx ) = @_;

    $ctx->response->body( 'Page not found' );
    $ctx->response->status( 404 );
}

sub item :Chained('/') :PathPart('api/item') :CaptureArgs(1) {
    my ( $self, $ctx ) = @_;
}

sub item_thumbnail :Chained('item') :PathPart('thumbnail.jpg') :Args(0) {
    my ( $self, $ctx ) = @_;
    my $name = $ctx->request->captures->[0];
    $ctx->serve_static_file( $ctx->path_to( qw/assets data/, $name, qw/thumbnail.jpg/ ) );
}


1;
