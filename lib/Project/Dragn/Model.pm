package Project::Dragn::Model;

use strict;
use warnings;

our @item = qw/apple banana cherry grape/;
sub ITEM() { @item }
our @collection = qw/Favorites Shiny Pretty Ugly/;
sub COLLECTION() { @collection }

sub populate {
    my $self = shift;
    my $dragn = shift;

    for my $name ('All', @collection) {
        my $key = "collection-$name";
        my $object = $dragn->model->lookup( $key );
        unless ($object) {
            $object = Project::Dragn::Model::Collection->new( name => $name );
            $dragn->model->store( $key => $object );
        }
    }

    for my $name (@item) {
        my $key = "item-$name";
        my $object = $dragn->model->lookup( $key );
        unless ($object) {
            $object = Project::Dragn::Model::Item->new( name => $name );
            $dragn->model->store( $key => $object );
        }
    }

    my $all_collection = $dragn->model->lookup( "collection-All" );
    unless ($all_collection) {
        $all_collection = Project::Dragn::Model::Collection->new( name => 'All' );
        $dragn->model->store( $all_collection->key => $all_collection );
    };

    {
        my $object = $dragn->model->lookup( 'dragn' );
        unless ($object) {
            $object = Project::Dragn::Model::Dragn->new();
            $dragn->model->store( 'dragn' => $object );
        }
        for my $name (@collection) {
            my $collection = $dragn->model->lookup( "collection-$name" );
            $object->collection->insert( $collection );
        }
        for my $name (@item) {
            my $item = $dragn->model->lookup( "item-$name" );
            $object->item->insert( $item );
            $all_collection->children->insert( $item );
        }
        $dragn->model->store( $object );
        $dragn->model->store( $all_collection );
    }
}

package Project::Dragn::Model::Dragn;

use Moose;

use KiokuDB::Util qw/set/;

has collection => qw/is rw does KiokuDB::Set lazy_build 1/;
sub _build_collection {
    return set;
}

has item => qw/is rw does KiokuDB::Set lazy_build 1/;
sub _build_item {
    return set;
}

package Project::Dragn::Model::Collection;

use Moose;

use KiokuDB::Util qw/set/;

has key => qw/is ro required 1 lazy 1/, default => sub { join '-', 'collection', shift->name };
has name => qw/is ro required 1 isa Str/;

has children => qw/is rw does KiokuDB::Set lazy_build 1/;
sub _build_children {
    return set;
}

package Project::Dragn::Model::Item;

use Moose;

has key => qw/is ro required 1 lazy 1/, default => sub { join '-', 'item', shift->name };
has name => qw/is ro required 1 isa Str/;

1;
