# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
jQuery ->
  # DataTable defaults
  $.extend( $.fn.dataTable.defaults, {
    "sDom": "TC<'dataTables_extras_top'fl>rt<'dataTables_extras_bottom clearfix'ip>",
    "sPaginationType": "bootstrap",
  } );
  # TableTool defaults
  TableTools.DEFAULTS.aButtons = [
    "print",
    {
      "sExtends": "collection",
      "sButtonText": "Save Table as…",
      "aButtons": [ "csv", "xls", "pdf" ]
    }
  ];

  $('#datatable_example').dataTable( {
    "oColVis": {
      "buttonText": "Change Columns",
      "sAlign": "right"
    },
    "oTableTools": {
      "sRowSelect": "multi"
    }
  });
  
  $('.dataTables_filter input').attr("placeholder", "type to filter..."); 
  $('.ColVis_MasterButton').addClass("btn").append('&ensp;<b class="caret"></b>').attr('title', 'Change Columns');  
  $('.DTTT_button_collection').addClass("btn").append('&ensp;<b class="caret"></b>').attr('title', 'Save Table as…');  
  $('.DTTT_button_print').addClass("btn").attr('title', 'Print Table');

      
  $('.carousel').carousel({
    interval: 3000
  })
  $('.popover-bottom').popover({
    placement: "bottom"
  })
  $('.popover-right').popover({
    placement: "right",
    html: true;
  })
  $('#myModal').modal({
    show: false
  })
  
  # tooltips 
  $('.tooltips').tooltip();

  $('.actions .btn').tooltip();
  
  # toggle all subsequent checkboxes when the header checkbox is checked
  $(".table-selectable .checkAll").change ->
    $(this).closest("table").find("input:checkbox").attr("checked", this.checked).change()
    
  # make table rows selectable by checking the checkbox
  $(".table-selectable input:checkbox").change ->
    $(this).closest('tr').toggleClass("selected", this.checked)
    
  



