package Project::Dragn::Catalyst::Controller::Root;

use strict;
use warnings;

use parent 'Catalyst::Controller';

__PACKAGE__->config->{namespace} = '';

use File::Assets;

sub auto :Private {
    my ( $self, $ctx ) = @_;

    my $stash = $ctx->stash;
    my $assets = $stash->{assets} = File::Assets->new( base => { dir =>  $ctx->path_to, uri => $ctx->uri_for, } );

    return 1;
}

sub default :Path {
    my ( $self, $ctx ) = @_;

    $ctx->stash(
        template => 'index.tt.html',
    );
#    $ctx->response->body( 'Page not found' );
#    $ctx->response->status( 404 );
}

sub end : ActionClass('RenderView') {}

1;
