</div>
<script src="${baseUrl}/css/jquery-3.6.0.min.js"></script>
<script src="${baseUrl}/css/bootstrap.min.js"></script>
<script src="${baseUrl}/css/jquery-ui.js"></script>
<script src="${baseUrl}/css/jquery.dataTables.min.js"></script>
<!-- Buttons extension JS -->
<script src="${baseUrl}/css/dataTables.buttons.min.js"></script>
<script src="${baseUrl}/css/jszip.min.js"></script>
<script src="${baseUrl}/css/pdfmake.min.js"></script>
<script src="${baseUrl}/css/vfs_fonts.js"></script>
<script src="${baseUrl}/css/buttons.html5.min.js"></script>
<script src="${baseUrl}/css/buttons.print.min.js"></script>

<script src="${baseUrl}/css/chart.js"></script>
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
var mychart = document.getElementById('myChart')
if(mychart!=null){
        const ctx = mychart.getContext('2d');
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
<#if monthCountMap?has_content>
        <#list monthCountMap?values as v>
        ${v}<#if v?has_next>,</#if>
        </#list>
</#if>
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
}



var mychart1 = document.getElementById('myChart1')
if(mychart1!=null){
    const ctx1 = mychart1.getContext('2d');
    <#if atMonthCountMap?has_content>
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
}
function createStar() {
const star = document.createElement("div");
    star.classList.add("star");
    star.innerHTML = "✦";

    // Random horizontal position
    star.style.left = Math.random() * 100 + "vw";

    // Random size
    star.style.fontSize = (10 + Math.random() * 20) + "px";

    // Random color
    const colors = ["#ffeb3b", "#ff9800", "#ff4081", "#00e676", "#40c4ff", "#e040fb"];
    star.style.color = colors[Math.floor(Math.random() * colors.length)];

    document.getElementById("star-container").appendChild(star);

    // Remove star after the fall
    setTimeout(() => star.remove(), 3000);
}

// Sprinkle stars for 5 seconds
let interval = setInterval(createStar, 40);

setTimeout(() => {
clearInterval(interval);
}, 30000);
</script>
<footer class="bg-dark text-white text-center py-3 fixed-bottom">
    © ${.now?string('yyyy')} <#assign titleList = util.getConfigs("title", "name")>
<#if titleList?has_content>
    ${titleList?first.configValue?if_exists}
</#if>
</footer>
</body>
</html>