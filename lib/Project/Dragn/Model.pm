package Project::Dragn::Model;

use strict;
use warnings;

use Moose;

extends qw/KiokuDB/;

our @item = qw/apple banana cherry grape mango watermelon/;
our @tag = qw/Favorite Shiny Pretty Ugly/;

sub tag {
    my $self = shift;
    my $name = shift;
    return Project::Dragn::Model::Tag->lookup( $self, $name );
}

sub item {
    my $self = shift;
    my $name = shift;
    return Project::Dragn::Model::Item->lookup( $self, $name );
}

sub populate {
    my $self = shift;
    my $dragn = shift;

    my $all = $self->tag( 'All' );
    $all->locked( 1 );
#    $self->store( $all );

    for my $name (@item) {
        my $item = $self->item( $name );
        $item->add_tag( $all );
    }
    
    {
        my $object = $self->lookup( 'dragn' );
        unless ($object) {
            $object = Project::Dragn::Model::Dragn->new();
            $dragn->model->store( 'dragn' => $object );
        }
        for my $tag (@tag) {
            $object->tags->insert( $self->tag( $tag ) );
        }
    }

}

sub nuke {
    my $self = shift;
    my $object = $self->lookup( 'dragn' );
    for my $tag ($object->tags->members) {
        $tag->nuke;
    }
}

package Project::Dragn::Model::Dragn;

use Moose;

use KiokuDB::Util qw/set/;

has tags => qw/is rw does KiokuDB::Set lazy_build 1/;
sub _build_tags {
    return set;
}

package Project::Dragn::Model::Tag;

use Moose;

use Carp;
use KiokuDB::Util qw/set/;

sub key {
    my $self = shift;
    my $name = @_ ? shift : blessed $self ? $self->name : croak "Can't call ->key on $self (without object)";
    return join '-', 'tag', $name;
}

sub lookup {
    my $self = shift;
    my $model = shift;
    my $name = shift;
    my $object = $model->lookup( $self->key( $name ) );
    unless ($object) {
        $object = $self->new( name => $name );
        $model->store( $object->key => $object );
    }
    return $object;
}

has name => qw/is ro required 1 isa Str/;
has locked => qw/is rw isa Bool default 0/;

sub count {
    return shift->tagged->size;
}

has tagged => qw/is rw does KiokuDB::Set lazy_build 1/;
sub _build_tagged {
    return set;
}

sub nuke {
    my $self = shift;
    for my $tagged ($self->tagged->members) {
        $tagged->remove_tag( $self );
    }
}

package Project::Dragn::Model::Item;

use Moose;

use Carp;
use KiokuDB::Util qw/set/;

sub key {
    my $self = shift;
    my $name = @_ ? shift : blessed $self ? $self->name : croak "Can't call ->key on $self (without object)";
    return join '-', 'item', $name;
}

sub lookup {
    my $self = shift;
    my $model = shift;
    my $name = shift;
    my $object = $model->lookup( $self->key( $name ) );
    unless ($object) {
        $object = $self->new( name => $name );
        $model->store( $object->key => $object );
    }
    return $object;
}

has name => qw/is ro required 1 isa Str/;

has tags => qw/is rw does KiokuDB::Set lazy_build 1/;
sub _build_tags {
    return set;
}

sub add_tag {
    my $self = shift;
    my $tag = shift;
    $self->tags->insert( $tag );
    $tag->tagged->insert( $self );
}

sub remove_tag {
    my $self = shift;
    my $tag = shift;
    $self->tags->remove( $tag );
    $tag->tagged->remove( $self );
}

1;

__END__

#our @item = qw/apple banana cherry grape/;
#sub ITEM() { @item }
#our @collection = qw/Favorites Shiny Pretty Ugly/;
#sub COLLECTION() { @collection }

#sub populate {
#    my $self = shift;
#    my $dragn = shift;

#    for my $name ('All', @collection) {
#        my $key = "collection-$name";
#        my $object = $dragn->model->lookup( $key );
#        unless ($object) {
#            $object = Project::Dragn::Model::Collection->new( name => $name );
#            $dragn->model->store( $key => $object );
#        }
#    }

#    for my $name (@item) {
#        my $key = "item-$name";
#        my $object = $dragn->model->lookup( $key );
#        unless ($object) {
#            $object = Project::Dragn::Model::Item->new( name => $name );
#            $dragn->model->store( $key => $object );
#        }
#    }

#    my $all_collection = $dragn->model->lookup( "collection-All" );
#    unless ($all_collection) {
#        $all_collection = Project::Dragn::Model::Collection->new( name => 'All' );
#        $dragn->model->store( $all_collection->key => $all_collection );
#    };

#    {
#        my $object = $dragn->model->lookup( 'dragn' );
#        unless ($object) {
#            $object = Project::Dragn::Model::Dragn->new();
#            $dragn->model->store( 'dragn' => $object );
#        }
#        for my $name (@collection) {
#            my $collection = $dragn->model->lookup( "collection-$name" );
#            $object->collection->insert( $collection );
#        }
#        for my $name (@item) {
#            my $item = $dragn->model->lookup( "item-$name" );
#            $object->item->insert( $item );
#            $all_collection->children->insert( $item );
#        }
#        $dragn->model->store( $object );
#        $dragn->model->store( $all_collection );
#    }
#}

#    for my $name ('All', @collection) {
#        my $key = "collection-$name";
#        my $object = $dragn->model->lookup( $key );
#        unless ($object) {
#            $object = Project::Dragn::Model::Collection->new( name => $name );
#            $dragn->model->store( $key => $object );
#        }
#    }

#    for my $name (@item) {
#        my $key = "item-$name";
#        my $object = $dragn->model->lookup( $key );
#        unless ($object) {
#            $object = Project::Dragn::Model::Item->new( name => $name );
#            $dragn->model->store( $key => $object );
#        }
#    }

#    my $all_collection = $dragn->model->lookup( "collection-All" );
#    unless ($all_collection) {
#        $all_collection = Project::Dragn::Model::Collection->new( name => 'All' );
#        $dragn->model->store( $all_collection->key => $all_collection );
#    };

#    {
#        my $object = $dragn->model->lookup( 'dragn' );
#        unless ($object) {
#            $object = Project::Dragn::Model::Dragn->new();
#            $dragn->model->store( 'dragn' => $object );
#        }
#        for my $name (@collection) {
#            my $collection = $dragn->model->lookup( "collection-$name" );
#            $object->collection->insert( $collection );
#        }
#        for my $name (@item) {
#            my $item = $dragn->model->lookup( "item-$name" );
#            $object->item->insert( $item );
#            $all_collection->children->insert( $item );
#        }
#        $dragn->model->store( $object );
#        $dragn->model->store( $all_collection );
#    }
