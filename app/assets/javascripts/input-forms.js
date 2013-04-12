/**
 * Created with JetBrains RubyMine.
 * User: Oleksa
 * Date: 12.04.13
 * Time: 8:58
 * To change this template use File | Settings | File Templates.
 */
$(function() {
    $( "#genre-slider" ).slider({
        range: "min",
        min: 1,
        orientation: "vertical",
        max: 7,
        value: $( "#genre-field" ).val(),
        step: 0.1,
        slide: function( event, ui ) {
            $( "#genre-field" ).val( ui.value );
        }
    });
    $( "#genre-field" ).val( $( "#genre-slider" ).slider( "value" ) );
    $( "#genre-field").change(function(){ $( "#genre-slider" ).slider('value', $( "#genre-field").val()) })
});
