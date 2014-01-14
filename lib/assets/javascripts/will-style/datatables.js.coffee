# Place all the behaviors and hooks related to DataTables and other Table functionality here.

#= require dataTables/jquery.dataTables
#= require dataTables/jquery.dataTables.bootstrap3
#= require dataTables/extras/ColVis
#= require dataTables/extras/ZeroClipboard.js
#= require dataTables/extras/TableTools

# DataTable defaults
$.extend ( $.fn.dataTable.defaults, {
  "sDom": "<'dataTables_buttons'CT><'dataTables_extras_top'fl>rt<'dataTables_extras_bottom'ip>",
  "sPaginationType": "bootstrap",

  "fnInitComplete": (oSettings, json)->
    $(this).siblings('.dataTables_extras_top').find(".dataTables_filter input").attr("placeholder", "type to filter..."); 
    $(this).siblings('.dataTables_buttons').find('.ColVis_MasterButton').addClass("btn btn-default dropdown-toggle pull-right").prepend('<i class="fa fa-columns"></i> ').append('&ensp; <b class="caret"></b>').attr('title', 'Change Columns');  
    $(this).siblings('.dataTables_buttons').find('.DTTT_button_collection').addClass("btn btn-default dropdown-toggle pull-right").prepend('<i class="fa fa-save"></i> ').append('&ensp; <b class="caret"></b>').attr('title', 'Save Table as…');  
    $(this).siblings('.dataTables_buttons').find('.DTTT_button_print').prepend('<i class="fa fa-print"></i> ').addClass("btn btn-default dropdown-toggle pull-right").attr('title', 'Print Table');
} );

# TableTools defaults
TableTools.DEFAULTS.aButtons = [
  {
    "sExtends": "print",
    "sButtonText": ""
  },
  {
    "sExtends": "collection",
    "sButtonText": "",
    "aButtons": [ "csv", "xls", "pdf" ]
  }
];

# toggle all subsequent checkboxes when the header checkbox is checked
$(document).on "change", ".table-selectable .checkAll", (event)->
  $(event.currentTarget).closest("table").find("input:checkbox").attr("checked", event.currentTarget.checked)
    
# make table rows selectable by checking the checkbox
$(document).on "change", ".table-selectable input:checkbox", (event)->
  $(event.currentTarget).closest('tr').toggleClass("selected", event.currentTarget.checked)

# RESPONSIVE
resizeDataTables = ->
  allDataTables = $($.fn.dataTable.fnTables(true))

  return if allDataTables.length == 0

  if($(window).width() > 978)
    allDataTables.dataTable().fnSetColumnVis( 1, true );
    allDataTables.dataTable().fnSetColumnVis( 3, true );
  if($(window).width() <= 978)
    allDataTables.dataTable().fnSetColumnVis( 1, false );
    allDataTables.dataTable().fnSetColumnVis( 3, false );
  if($(window).width() > 480)
    allDataTables.dataTable().fnSetColumnVis( 4, true );
  if($(window).width() <= 480)
    allDataTables.dataTable().fnSetColumnVis( 4, false );

$(window).resize resizeDataTables

$ ->
  resizeDataTables();
