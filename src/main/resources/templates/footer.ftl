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

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
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
const ctx = document.getElementById('myChart').getContext('2d');
<#if monthCountMap?has_content>
    new Chart(ctx, {
type: '${chartType?if_exists}',
data: {
labels: [
<#list monthCountMap?keys as k>
"${k}"<#if k?has_next>,</#if>
</#list>
],
datasets: [{
label: 'Students Count',
data: [
<#list monthCountMap?values as v>
${v}<#if v?has_next>,</#if>
</#list>
],
borderWidth: 1
}]
        },
        options: {
responsive: true,
maintainAspectRatio: false
}
    });
    </#if>





    const ctx1 = document.getElementById('myChart1').getContext('2d');
    <#if monthCountMap?has_content>
    new Chart(ctx1, {
type: '${atChartType?if_exists}',
data: {
labels: [
<#list atMonthCountMap?keys as k>
"${k}"<#if k?has_next>,</#if>
</#list>
],
datasets: [{
label: 'Students Attendance',
data: [
<#list atMonthCountMap?values as v>
${v}<#if v?has_next>,</#if>
</#list>
],
borderWidth: 1
}]
},
options: {
responsive: true,
maintainAspectRatio: false
}
});
</#if>
</script>
<footer class="bg-dark text-white text-center py-3 fixed-bottom">
    © ${.now?string('yyyy')} <#assign titleList = util.getConfigs("title", "name")>
<#if titleList?has_content>
    ${titleList?first.configValue?if_exists}
</#if>
</footer>
</body>
</html>