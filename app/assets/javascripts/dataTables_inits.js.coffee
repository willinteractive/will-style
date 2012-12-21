# Place all the behaviors and hooks related to DataTables and other Table functionality here.

#= require dataTables/jquery.dataTables
#= require dataTables/jquery.dataTables.bootstrap
#= require dataTables/extras/ColVis
#= require dataTables/extras/ZeroClipboard.js
#= require dataTables/extras/TableTools

jQuery ->
  # DataTable defaults
  $.extend( $.fn.dataTable.defaults, {
    "sDom": "<'dataTables_buttons'TC><'dataTables_extras_top'fl>rt<'dataTables_extras_bottom clearfix'ip>",
    "sPaginationType": "bootstrap",
  } );
  
  # TableTools defaults
  TableTools.DEFAULTS.aButtons = [
    "print",
    {
      "sExtends": "collection",
      "sButtonText": "Save Table as…",
      "aButtons": [ "csv", "xls", "pdf" ]
    }
  ];
  
  # Specific DataTable constructs
  # HAVE to be here because the other code needs to be executed AFTER the construction
  $('#datatable_example').dataTable( {
    "oColVis": {
      "buttonText": "Change Columns",
      "sAlign": "right"
    },
    "oTableTools": {
      "sRowSelect": "multi"
    }
  });
  
  # After tables have been initialized, add some content and/or classes to added DOM
  $('.dataTables_filter input').attr("placeholder", "type to filter..."); 
  $('.ColVis_MasterButton').addClass("btn").prepend('<i class="icon-columns"></i> &ensp;').append('&ensp; <b class="caret"></b>').attr('title', 'Change Columns');  
  $('.DTTT_button_collection').addClass("btn").prepend('<i class="icon-save"></i> &ensp;').append('&ensp; <b class="caret"></b>').attr('title', 'Save Table as…');  
  $('.DTTT_button_print').prepend('<i class="icon-print"></i> &ensp;').addClass("btn").attr('title', 'Print Table');

      
  ## --- OTHER TABLE FUNCTIONALITY
  
  # toggle all subsequent checkboxes when the header checkbox is checked
  $(".table-selectable .checkAll").change ->
    $(this).closest("table").find("input:checkbox").attr("checked", this.checked).change()
    
  # make table rows selectable by checking the checkbox
  $(".table-selectable input:checkbox").change ->
    $(this).closest('tr').toggleClass("selected", this.checked)
    
  # make placeholder attributes work in IE
  $(document).ready($('input[placeholder]').placeholder())