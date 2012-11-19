# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
jQuery ->
	$.extend( $.fn.dataTable.defaults, {
		"sPaginationType": "bootstrap",
		"oColVis": {
			"buttonText": "Change columns",
			"sAlign": "right"
		}
	} );
	$('#datatable_example').dataTable( {
		"sDom": "<'dataTables_extras_top'fCl>rt<'dataTables_extras_bottom clearfix'ip>",
		"oColVis": { "sAlign": "right" }
	} );
	
	$('.dataTables_filter input').attr("placeholder", "type to filter...");	
	$('.ColVis_MasterButton').addClass("btn");
	$('.ColVis_MasterButton').append('&ensp;<b class="caret"></b>');	
			
	$('.carousel').carousel({
		interval: 3000
	})
	$('.popover-bottom').popover({
		placement: "bottom"
	})
	$('.popover-right').popover({
		placement: "right"
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
