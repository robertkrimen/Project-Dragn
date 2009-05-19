var baseURI;
var Context = {};

function applet( uri ) {
    baseURI = uri;
    $( "#applet" ).html( Jemplate.process( "applet" ) );

    Context.collection = "All";

    refresh();

    $( ".collection-list-item" ).livequery( 'click', function(event) {
        var match = /collection-list-item-(\w+)/.exec( event.target.id );
        if (match)
            selectCollection( match[1] );
    } );

}

function updateCollectionList( select ) {
    var name = Context.collection;
    $.getJSON( baseURI + "/collection/list", function( data ) {
        $( "#copy-into" ).html( Jemplate.process( "toolbar_select", { id: "copy-into-select", name: "Copy into", options: data.list } ) );
        $( "#move-into" ).html( Jemplate.process( "toolbar_select", { id: "move-into-select", name: "Move into", options: data.list } ) );

        $( "#collection-list" ).append( Jemplate.process( "collection_list_item", { name: "All" } ) );
        $.each( data.list, function() {
            $( "#collection-list" ).append( Jemplate.process( "collection_list_item", { name: this } ) );
        } );

        selectCollection( select );
    } );
}

function selectCollection( name ) {
    $( ".collection-list-item" ).removeClass( "selected" );
    $( "#collection-list-item-" + name ).addClass( "selected" );

    $.getJSON( baseURI + "/collection/" + name + "/item/list", function( data ) {
        $( "#item-list li" ).remove();
        $.each( data.list, function() {
            $( "#item-list" ).append( Jemplate.process( "item_list_item", { uri: baseURI, name: this } ) );
        } );
    } );
}

function refresh() {
    var name = Context.collection;

    updateCollectionList( Context.collection );
}
