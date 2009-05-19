var baseURI;

function applet( uri ) {
    baseURI = uri;
    $( "#applet" ).html( Jemplate.process( "applet" ) );

    updateCollectionList();

    $.getJSON( baseURI + "/fresh", function( data ) {
        $.each( data.list, function() {
            $( "#item-list" ).append( Jemplate.process( "item_list_item", { uri: baseURI, name: this } ) );
        } );
    } );
}

function updateCollectionList( uri ) {
    $.getJSON( baseURI + "/collection/list", function( data ) {
        console.log( data );
        $( "#copy-into" ).html( Jemplate.process( "toolbar_select", { id: "copy-into-select", name: "Copy into", options: data.list } ) );
        $( "#move-into" ).html( Jemplate.process( "toolbar_select", { id: "move-into-select", name: "Move into", options: data.list } ) );
    } );
}
