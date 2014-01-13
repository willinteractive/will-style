# Place all the behaviors and hooks related to DataTables and other Table functionality here.

#= require dataTables/jquery.dataTables
#= require dataTables/jquery.dataTables.bootstrap3
#= require dataTables/extras/ColVis
#= require dataTables/extras/ZeroClipboard.js
#= require dataTables/extras/TableTools

jQuery ->
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
  	}
    {
      "sExtends": "collection",
      "sButtonText": "",
      "aButtons": [ "csv", "xls", "pdf" ]
    }
  ];
  
  # Specific DataTable constructs
  # HAVE to be here because the other code needs to be executed AFTER the construction
  exampleTable = $('#datatable_example').dataTable( {
    "oColVis": {
      "buttonText": "",
      "sAlign": "right"
    },
    "oTableTools": {
      "sRowSelect": "multi"
    },
    "oLanguage": {
     	"sSearch": ""
     }
  });
  
  # After tables have been initialized, add some content and/or classes to added DOM
  $('.dataTables_filter input').attr("placeholder", "type to filter..."); 
  $('.ColVis_MasterButton').addClass("btn btn-default dropdown-toggle pull-right").prepend('<i class="fa fa-columns"></i> ').append('&ensp; <b class="caret"></b>').attr('title', 'Change Columns');  
  $('.DTTT_button_collection').addClass("btn btn-default dropdown-toggle pull-right").prepend('<i class="fa fa-save"></i> ').append('&ensp; <b class="caret"></b>').attr('title', 'Save Table as…');  
  $('.DTTT_button_print').prepend('<i class="fa fa-print"></i> ').addClass("btn btn-default dropdown-toggle pull-right").attr('title', 'Print Table');

      
  ## --- OTHER TABLE FUNCTIONALITY
  
  # toggle all subsequent checkboxes when the header checkbox is checked
  $(".table-selectable .checkAll").change ->
    $(this).closest("table").find("input:checkbox").attr("checked", this.checked).change()
    
  # make table rows selectable by checking the checkbox
  $(".table-selectable input:checkbox").change ->
    $(this).closest('tr').toggleClass("selected", this.checked)
    
  # RESPONSIVE
  $(window).resize ->
    if($(window).width() > 978)
      exampleTable.fnSetColumnVis( 1, true );
      exampleTable.fnSetColumnVis( 3, true );
    if($(window).width() <= 978)
      exampleTable.fnSetColumnVis( 1, false );
      exampleTable.fnSetColumnVis( 3, false );
    if($(window).width() > 480)
      exampleTable.fnSetColumnVis( 4, true );
    if($(window).width() <= 480)
      exampleTable.fnSetColumnVis( 4, false );

  if($(window).width() > 978)
    exampleTable.fnSetColumnVis( 1, true );
    exampleTable.fnSetColumnVis( 3, true );
    exampleTable.fnSetColumnVis( 4, true );
  if($(window).width() <= 978)
    exampleTable.fnSetColumnVis( 1, false );
    exampleTable.fnSetColumnVis( 3, false );
  if($(window).width() > 480)
    exampleTable.fnSetColumnVis( 4, true );
  if($(window).width() <= 480)
    exampleTable.fnSetColumnVis( 4, false );
