var baseURI;
var Context = {};

var model = {};

(function() {

model.ListItemDD = function(id) {
    model.ListItemDD.superclass.constructor.apply( this, arguments );
//    this.initPlayer(id, sGroup, config);
};

YAHOO.extend( model.ListItemDD, YAHOO.util.DDProxy, {

    TYPE: "ListItemDD",

    startDrag: function() {
        $( "#tag-list li" ).addClass( "highlight" );
        $( "#tag-list--All" ).removeClass( "highlight" );
    },

    endDrag: function() {
        YAHOO.util.Dom.setXY( this.getEl(), [ this.startPageX, this.startPageY ] );
        $( "#tag-list li" ).removeClass( "highlight" );
        $( "#tag-list li" ).removeClass( "highlight-over" );
    },

    onDragEnter: function( event, target ) {
        $( "#tag-list li" ).removeClass( "highlight-over" );
        YAHOO.util.Dom.addClass( target, "highlight-over" );
    },

    onDragExit: function( event, target ) {
        $( "#tag-list li" ).removeClass( "highlight-over" );
    },

    onDragDrop: function( event, target ) {
        var match, tag, item;

        match = /tag-list--(\w+)/.exec( target );
        if (match)
            tag = match[1];

        match = /item-list--(\w+)/.exec( this.getEl().id );
        if (match) {
            item = match[1];
        }

        $.getJSON( baseURI + "/item/" + item + "/add-tag", { tag: tag }, function( data ) {
            refresh();
        } );
    },

} ); 

} ());

function applet( uri ) {
    baseURI = uri;
    $( "#applet" ).html( Jemplate.process( "applet" ) );

    Context.tag = "All";

    refresh();

    $( "#nuke" ).livequery( 'click', function(event) {
        $.getJSON( baseURI + "/nuke", function( data ) {
            refresh();
        } );
    } );

    $( ".tag-list-item" ).livequery( 'click', function(event) {
        var match = /tag-list-a--(\w+)/.exec( event.target.id );
        if (match)
            selectTag( match[1] );
    } );

}

function updateTagList( select ) {
    var name = Context.tag;
    $.getJSON( baseURI + "/tag/list", function( data ) {
//        $( "#copy-into" ).html( Jemplate.process( "toolbar_select", { id: "copy-into-select", name: "Copy into", options: data.list } ) );
//        $( "#move-into" ).html( Jemplate.process( "toolbar_select", { id: "move-into-select", name: "Move into", options: data.list } ) );

        $( "#tag-list" ).html( "" );
        $( "#tag-list" ).append( Jemplate.process( "tag_list_item", { tag: { name: "All", count: '-' } } ) );
        $.each( data.list, function() {
            $( "#tag-list" ).append( Jemplate.process( "tag_list_item", { tag: this } ) );
            new YAHOO.util.DDTarget( "tag-list--" + this.name );
        } );

        selectTag( select );
    } );
}

function selectTag( name ) {
    $( ".tag-list-item" ).removeClass( "selected" );
    $( "#tag-list--" + name ).addClass( "selected" );
    Context.tag = name;

    $.getJSON( baseURI + "/tag/" + name + "/item/list", function( data ) {
        $( "#item-list li" ).remove();
        $.each( data.list, function() {
            $( "#item-list" ).append( Jemplate.process( "item_list_item", { uri: baseURI, name: this } ) );
            var dd = new model.ListItemDD( "item-list--" + this );
//            var dd = new YAHOO.util.DD( "item-list-item-" + this );
//            var dd = new YAHOO.util.DDProxy( "item-list-item-" + this );
//            console.log( dd );
        } );
    } );
}

function refresh() {
    var name = Context.tag;

    updateTagList( Context.tag );
}
