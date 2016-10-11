$(document).ready(function () {
    search = function (ev, url) {
        $('.cui__input__label').text('');
        var query = $('#search_field').val();
        url = url || "/search?query=" + encodeURIComponent(query)
        $("#search_results").load(url, function (responseTxt, statusTxt, xhr) {
            if (statusTxt == "error")
                alert("Error: " + xhr.status + ": " + xhr.statusText);
        });
    }
    $("#search_button").click(search);
    $('#search_field').keypress(function (e) {
        if (e.which == 13 && this.value.length > 0) {
            $("#search_button").click();
            return false;
        }
    });
});