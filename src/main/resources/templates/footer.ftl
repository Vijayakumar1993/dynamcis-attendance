</div>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>
<script src="https://code.jquery.com/ui/1.13.2/jquery-ui.js"></script>
<script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
<!-- Buttons extension JS -->
<script src="https://cdn.datatables.net/buttons/2.4.1/js/dataTables.buttons.min.js"></script>
<script src="https://cdn.datatables.net/buttons/2.4.1/js/buttons.flash.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jszip/3.10.1/jszip.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.2.7/pdfmake.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.2.7/vfs_fonts.js"></script>
<script src="https://cdn.datatables.net/buttons/2.4.1/js/buttons.html5.min.js"></script>
<script src="https://cdn.datatables.net/buttons/2.4.1/js/buttons.print.min.js"></script>
<script>
// Build autocomplete list as label + value
var names = [
        <#if customers?has_content>
            <#list customers as c>
                { label: "${c.name?if_exists}(${c.phone?if_exists})", value: "${c.id?if_exists}" }<#if c?has_next>,</#if>
            </#list>
        </#if>
    ];

    $("#studentNames").autocomplete({
source: names,
select: function(event, ui) {
$("#studentNames").val(ui.item.label);   // Show name in textbox
$("#studentId").val(ui.item.value);      // Put ID into hidden field
return false;
}
    });
 $("#studentNames").on("input", function () {
if ($(this).val().trim() === "") {
$("#studentId").val(""); // clear id
}
    });
</script>
<script>
    $(document).ready(function () {
$.fn.dataTable.ext.errMode = 'console';
$('.table').DataTable({
"pageLength": 5,
"lengthMenu": [5, 10, 25, 50, 100],
"ordering": true,
"searching": true,
dom: 'Blfrtip',
buttons: [
'copy', 'csv', 'excel', 'pdf', 'print'
]
});
    });
</script>

</body>
</html>