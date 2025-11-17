</div>
<script>
// Build autocomplete list as label + value
var names = [
        <#if customers?has_content>
            <#list customers as c>
                { label: "${c.name}", value: "${c.id}" }<#if c?has_next>,</#if>
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

</body>
</html>