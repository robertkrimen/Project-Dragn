var baseURI;
var Context = {};

function applet( uri ) {
    baseURI = uri;
    $( "#applet" ).html( Jemplate.process( "applet" ) );

    Context.collection = "All";

    refresh();

}

function updateCollectionList( uri ) {
    var name = Context.collection;
    $.getJSON( baseURI + "/collection/list", function( data ) {
        $( "#copy-into" ).html( Jemplate.process( "toolbar_select", { id: "copy-into-select", name: "Copy into", options: data.list } ) );
        $( "#move-into" ).html( Jemplate.process( "toolbar_select", { id: "move-into-select", name: "Move into", options: data.list } ) );

        $( "#collection-list" ).append( Jemplate.process( "collection_list_item", { name: "All" } ) );
        $.each( data.list, function() {
            $( "#collection-list" ).append( Jemplate.process( "collection_list_item", { name: this } ) );
        } );
        $( ".collection-list-item" ).removeClass( "selected" );
        $( "#collection-list-item-" + name ).addClass( "selected" );
    } );
}

function refresh() {
    var name = Context.collection;

    updateCollectionList();

    $.getJSON( baseURI + "/collection/" + name + "/item/list", function( data ) {
        $.each( data.list, function() {
            $( "#item-list" ).append( Jemplate.process( "item_list_item", { uri: baseURI, name: this } ) );
        } );
    } );
}
