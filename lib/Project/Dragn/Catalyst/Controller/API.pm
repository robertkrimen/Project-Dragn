package Project::Dragn::Catalyst::Controller::API;

use strict;
use warnings;

use parent 'Catalyst::Controller::REST';

use Carp;

my @item = qw/apple banana cherry grape/;
#my @tag = qw/Favorites Shiny Pretty Ugly/;

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

sub tag_list :Path('tag/list') {
    my ( $self, $ctx ) = @_;

    my @tag = $ctx->model( 'Dragn' )->model->lookup( "dragn" )->tags->members;

    $self->status_ok( 
        $ctx,
        entity => {
            list => [ map { { name => $_->name, count => $_->count } } @tag ],
        },
    );
}

sub tag :Chained('/') :PathPart('api/tag') :CaptureArgs(1) {
    my ( $self, $ctx ) = @_;

    my $name = $ctx->request->captures->[0];
    my $tag = $ctx->model( 'Dragn' )->model->lookup( "tag-$name" ) or croak "Couldn't find tag \"$name\"";

    $ctx->stash(
        tag => $tag,
    );
}

sub tag_item_list :Chained('tag') :PathPart('item/list') {
    my ( $self, $ctx ) = @_;

    $self->status_ok( 
        $ctx,
        entity => {
            list => [ map { $_->name } $ctx->stash->{tag}->tagged->members ], # TODO Should be TO_JSON or sumptin
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

sub item_add_tag :Chained('item') :PathPart('add-tag') :Args(0) {
    my ( $self, $ctx ) = @_;
    my $name = $ctx->request->captures->[0];
    my $item = $ctx->model( 'Dragn' )->model->item( $name );
    my $tag = $ctx->model( 'Dragn' )->model->tag( $ctx->request->param( 'tag' ) );
    $item->add_tag( $tag );

    $self->status_ok( 
        $ctx,
        entity => {},
    );
}


1;
