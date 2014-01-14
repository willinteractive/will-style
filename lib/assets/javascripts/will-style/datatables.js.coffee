# Place all the behaviors and hooks related to DataTables and other Table functionality here.

#= require dataTables/jquery.dataTables
#= require dataTables/jquery.dataTables.bootstrap3
#= require dataTables/extras/ColVis
#= require dataTables/extras/ZeroClipboard.js
#= require dataTables/extras/TableTools

$ ->
  # DataTable defaults
  $.extend( $.fn.dataTable.defaults, {
    "sDom": "<'dataTables_buttons'CT><'dataTables_extras_top'fl>rt<'dataTables_extras_bottom'ip>",
    "sPaginationType": "bootstrap",
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