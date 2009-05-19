package Project::Dragn::Catalyst::Controller::API;

use strict;
use warnings;

use parent 'Catalyst::Controller::REST';

use Carp;

my @item = qw/apple banana cherry grape/;
#my @collection = qw/Favorites Shiny Pretty Ugly/;

sub fresh :Path('fresh') {
    my ( $self, $ctx ) = @_;

    my @item = map { $_->name } $ctx->model( 'Dragn' )->model->lookup( "dragn" )->item->members;

    $self->status_ok( 
        $ctx,
        entity => {
            list => [ @item ],
        },
    );
}

sub collection_list :Path('collection/list') {
    my ( $self, $ctx ) = @_;

    my @collection = map { $_->name } $ctx->model( 'Dragn' )->model->lookup( "dragn" )->collection->members;

    $self->status_ok( 
        $ctx,
        entity => {
            list => [ @collection ],
        },
    );
}

sub collection :Chained('/') :PathPart('api/collection') :CaptureArgs(1) {
    my ( $self, $ctx ) = @_;

    my $name = $ctx->request->captures->[0];
    my $collection = $ctx->model( 'Dragn' )->model->lookup( "collection-$name" ) or croak "Couldn't find collection \"$name\"";

    $ctx->stash(
        collection => $collection,
    );
}

sub collection_item_list :Chained('collection') :PathPart('item/list') {
    my ( $self, $ctx ) = @_;

    $self->status_ok( 
        $ctx,
        entity => {
            list => [ map { $_->name } $ctx->stash->{collection}->children->members ], # TODO Should be TO_JSON or sumptin
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
