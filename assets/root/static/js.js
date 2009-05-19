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

    endDrag: function() {
        YAHOO.util.Dom.setXY( this.getEl(), [ this.startPageX, this.startPageY ] );
    },

/*
    initPlayer: function(id, sGroup, config) {
        if (!id) { 
            return; 
        }

        var el = this.getDragEl()
        YAHOO.util.Dom.setStyle(el, "borderColor", "transparent");
        YAHOO.util.Dom.setStyle(el, "opacity", 0.76);

        // specify that this is not currently a drop target
        this.isTarget = false;

        this.originalStyles = [];

        this.type = YAHOO.example.DDPlayer.TYPE;
        this.slot = null;

        this.startPos = YAHOO.util.Dom.getXY( this.getEl() );
        YAHOO.log(id + " startpos: " + this.startPos, "info", "example");
    },

    startDrag: function(x, y) {
        YAHOO.log(this.id + " startDrag", "info", "example");
        var Dom = YAHOO.util.Dom;

        var dragEl = this.getDragEl();
        var clickEl = this.getEl();

        dragEl.innerHTML = clickEl.innerHTML;
        dragEl.className = clickEl.className;

        Dom.setStyle(dragEl, "color",  Dom.getStyle(clickEl, "color"));
        Dom.setStyle(dragEl, "backgroundColor", Dom.getStyle(clickEl, "backgroundColor"));

        Dom.setStyle(clickEl, "opacity", 0.1);

        var targets = YAHOO.util.DDM.getRelated(this, true);
        YAHOO.log(targets.length + " targets", "info", "example");
        for (var i=0; i<targets.length; i++) {
            
            var targetEl = this.getTargetDomRef(targets[i]);

            if (!this.originalStyles[targetEl.id]) {
                this.originalStyles[targetEl.id] = targetEl.className;
            }

            targetEl.className = "target";
        }
    },

    getTargetDomRef: function(oDD) {
        if (oDD.player) {
            return oDD.player.getEl();
        } else {
            return oDD.getEl();
        }
    },

    endDrag: function(e) {
        // reset the linked element styles
        YAHOO.util.Dom.setStyle(this.getEl(), "opacity", 1);

        this.resetTargets();
    },

    resetTargets: function() {

        // reset the target styles
        var targets = YAHOO.util.DDM.getRelated(this, true);
        for (var i=0; i<targets.length; i++) {
            var targetEl = this.getTargetDomRef(targets[i]);
            var oldStyle = this.originalStyles[targetEl.id];
            if (oldStyle) {
                targetEl.className = oldStyle;
            }
        }
    },

    onDragDrop: function(e, id) {
        // get the drag and drop object that was targeted
        var oDD;
        
        if ("string" == typeof id) {
            oDD = YAHOO.util.DDM.getDDById(id);
        } else {
            oDD = YAHOO.util.DDM.getBestMatch(id);
        }

        var el = this.getEl();

        // check if the slot has a player in it already
        if (oDD.player) {
            // check if the dragged player was already in a slot
            if (this.slot) {
                // check to see if the player that is already in the
                // slot can go to the slot the dragged player is in
                // YAHOO.util.DDM.isLegalTarget is a new method
                if ( YAHOO.util.DDM.isLegalTarget(oDD.player, this.slot) ) {
                    YAHOO.log("swapping player positions", "info", "example");
                    YAHOO.util.DDM.moveToEl(oDD.player.getEl(), el);
                    this.slot.player = oDD.player;
                    oDD.player.slot = this.slot;
                } else {
                    YAHOO.log("moving player in slot back to start", "info", "example");
                    YAHOO.util.Dom.setXY(oDD.player.getEl(), oDD.player.startPos);
                    this.slot.player = null;
                    oDD.player.slot = null
                }
            } else {
                // the player in the slot will be moved to the dragged
                // players start position
                oDD.player.slot = null;
                YAHOO.util.DDM.moveToEl(oDD.player.getEl(), el);
            }
        } else {
            // Move the player into the emply slot
            // I may be moving off a slot so I need to clear the player ref
            if (this.slot) {
                this.slot.player = null;
            }
        }

        YAHOO.util.DDM.moveToEl(el, oDD.getEl());
        this.resetTargets();

        this.slot = oDD;
        this.slot.player = this;
    },

    swap: function(el1, el2) {
        var Dom = YAHOO.util.Dom;
        var pos1 = Dom.getXY(el1);
        var pos2 = Dom.getXY(el2);
        Dom.setXY(el1, pos2);
        Dom.setXY(el2, pos1);
    },

    onDragOver: function(e, id) {
    },

    onDrag: function(e, id) {
    }
*/

});

} ());

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
            var dd = new model.ListItemDD( "item-list-item-" + this );
//            var dd = new YAHOO.util.DD( "item-list-item-" + this );
//            var dd = new YAHOO.util.DDProxy( "item-list-item-" + this );
            console.log( dd );
        } );
    } );
}

function refresh() {
    var name = Context.collection;

    updateCollectionList( Context.collection );
}
