</div>
<link rel="stylesheet"
      href="${baseUrl}/css/bootstrap.min.css">

<link rel="stylesheet"
      href="${baseUrl}/css/jquery.dataTables.min.css">
<link rel="stylesheet" href="${baseUrl}/css/animate.min.css"/>

<link rel="stylesheet"
      href="${baseUrl}/css/jquery-ui.css">
<link rel="stylesheet" href="${baseUrl}/css/custom.css">

<!-- JS Libraries -->
<script src="${baseUrl}/css/jquery-3.6.0.min.js"></script>
<script src="${baseUrl}/css/bootstrap.min.js"></script>
<script src="${baseUrl}/css/jquery-ui.js"></script>
<script src="${baseUrl}/css/jquery.dataTables.min.js"></script>

<!-- DataTables Buttons -->
<script src="${baseUrl}/css/dataTables.buttons.min.js"></script>
<script src="${baseUrl}/css/jszip.min.js"></script>
<script src="${baseUrl}/css/pdfmake.min.js"></script>
<script src="${baseUrl}/css/vfs_fonts.js"></script>
<script src="${baseUrl}/css/buttons.html5.min.js"></script>
<script src="${baseUrl}/css/buttons.print.min.js"></script>

<script src="${baseUrl}/css/chart.js"></script>

<script>
/* ---------------------------------------------------------
   Autocomplete Setup
--------------------------------------------------------- */

var names = [
    <#if customers?has_content>
        <#list customers as c>
            {
label: "${c.name?if_exists}(${c.phone?if_exists})",
value: "${c.id?if_exists}"
}<#if c?has_next>,</#if>
        </#list>
    </#if>
];

$("#studentNames").autocomplete({
source: names,
select: function(event, ui) {
$("#studentNames").val(ui.item.label);
$("#studentId").val(ui.item.value);
return false;
}
});

$("#studentNames").on("input", function () {
if ($(this).val().trim() === "") {
$("#studentId").val("");
}
});
</script>

<script>
/* ---------------------------------------------------------
   DataTables Setup + Page Restore Fix
--------------------------------------------------------- */

$(document).ready(function () {

$.fn.dataTable.ext.errMode = 'console';

    $('.table').DataTable({
pageLength: 5,
lengthMenu: [5, 10, 25, 50, 100,150,200],
ordering: true,
searching: true,
dom: 'Blfrtip',
buttons: ['copy', 'csv', 'excel', 'pdf', 'print']
});

    var matchTable = $('#matchTable').DataTable({
pageLength: 6,
lengthMenu: [6, 12, 18, 24, 30, 36, 42, 48, 54, 60, 66, 100],
ordering: false,
searching: true,
dom: 'Blfrtip',
buttons: ['copy', 'csv', 'excel', 'pdf', 'print']
});

    // Save Page Function
    window.savepos = function () {
var page = matchTable.page();
sessionStorage.setItem("matchTablePage", page);
}

    // Restore Page
    var savedPage = sessionStorage.getItem("matchTablePage");
    if (savedPage !== null) {
matchTable.page(parseInt(savedPage)).draw(false);
}
});
</script>

<script>
/* ---------------------------------------------------------
   Chart 1
--------------------------------------------------------- */

var mychart = document.getElementById('myChart');

if (mychart != null) {
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
}
</script>

<script>
/* ---------------------------------------------------------
   Chart 2
--------------------------------------------------------- */

var mychart1 = document.getElementById('myChart1');

if (mychart1 != null) {
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
</script>

<script>

function openCustomerLookupWithRole(role) {
var  lookupWindow = window.open(
'${baseUrl?if_exists}/lookup/viewCustomers/'+role,
'CutomerLookup',
'width=800,height=600,scrollbars=yes'
        );

    window.addEventListener('beforeunload', function() {
if (lookupWindow && !lookupWindow.closed) {
lookupWindow.close();
}
    });
    }

function openCustomerLookup() {
var  lookupWindow = window.open(
'${baseUrl?if_exists}/lookup/viewCustomers',
'CutomerLookup',
'width=800,height=600,scrollbars=yes'
        );

    window.addEventListener('beforeunload', function() {
if (lookupWindow && !lookupWindow.closed) {
lookupWindow.close();
}
    });
    }

function selectCustomer(id, value){
window.opener.document.getElementById('customerId').value = id;
    window.opener.document.getElementById('customerIdInput').value = value;
    window.close();
}
function getCategories(categoryId) {
$("#category").empty();
$("#category").append("<option value=''>--Select Category--</option>")
fetch('/api/categories/' + categoryId.value)
.then(response => response.json())
.then(data => {
data.forEach(item => {
$("#category").append(
"<option value='" + item.configId + "'>" + item.configValue.charAt(0).toUpperCase() + item.configValue.slice(1) + "</option>"
);
});
        })
.catch(err => console.error(err));
}
function saveTeamCompetition(teamId, customerId, comp) {
const formData = new URLSearchParams();
    formData.append("teamId", teamId);
    formData.append("customer", customerId);
    formData.append("compId", comp.value);
    if(!comp.checked){
formData.append("remove", true);
}

    fetch('${baseUrl?if_exists}/api/createTeamCompCustomer', {
method: "POST",
headers: {
"Content-Type": "application/x-www-form-urlencoded"
},
        body: formData.toString()
    }).catch(err => console.error(err)); // only catch errors
}

</script>

<footer class="bg-dark text-white text-center py-3 fixed-bottom">
    © ${.now?string('yyyy')}
    <#assign titleList = util.getConfigs("title", "name")>
    <#if titleList?has_content>
        ${titleList?first.configValue?if_exists}
    </#if>
</footer>

</body>
</html>
