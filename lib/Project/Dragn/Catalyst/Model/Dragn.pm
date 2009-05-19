package Project::Dragn::Catalyst::Model::Dragn;

use strict;
use warnings;

use base qw/Catalyst::Model/;

use Moose;

has dragn => qw/is rw/;
sub ACCEPT_CONTEXT {
    require URI::PathAbstract;
    require Project::Dragn;
    my ( $self, $ctx ) = @_;
    return $self->dragn || do {
        my $dragn = Project::Dragn->new( home => $ENV{PROJECT_DRAGN_HOME}, uri => URI::PathAbstract->new( $ctx->request->base ) );
        $dragn->populate;
        $self->dragn( $dragn );
    };    
}

1;
