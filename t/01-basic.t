#!/usr/bin/perl -w

use strict;
use warnings;

use Test::Most;

plan qw/no_plan/;

use Project::Dragn;

ok( my $dragn = Project::Dragn->new );

$dragn->populate;

my $tag;
$tag = $dragn->model->tag( 'Favorite' );
ok( $tag );
is( $tag->name, "Favorite" );
is( $tag->count, 0 );

my $_dragn = $dragn->model->lookup( "dragn" );
ok( $_dragn->tags->has( $tag ) );

$tag = $dragn->model->tag( 'All' );
ok( $tag );
is( $tag->name, "All" );
cmp_ok( $tag->count, '>', 4 );

#1;
#my $collection = $dragn->model->lookup( "collection-Favorites" );
#ok( $collection );
#is( $collection->name, "Favorites" );

#my $_dragn = $dragn->model->lookup( "dragn" );
#ok( $_dragn->collection->has( $collection ) );

#1;
