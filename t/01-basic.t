#!/usr/bin/perl -w

use strict;
use warnings;

use Test::Most;

plan qw/no_plan/;

use Project::Dragn;

ok( my $dragn = Project::Dragn->new );

$dragn->populate;

my $collection = $dragn->model->lookup( "collection-Favorites" );
ok( $collection );
is( $collection->name, "Favorites" );

my $_dragn = $dragn->model->lookup( "dragn" );
ok( $_dragn->collection->has( $collection ) );

1;
