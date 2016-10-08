$(document).ready(function () {
    search = function (ev, url) {
        $('.cui__input__label').text('');
        var query = $('#search_query').val();
        url = url || "/search?query=" + encodeURIComponent(query)
        $("#search_results").load(url, function (responseTxt, statusTxt, xhr) {
            if (statusTxt == "error")
                alert("Error: " + xhr.status + ": " + xhr.statusText);
        });
    }
    $("#search_button").click(search);
    $('#search_query').keypress(function (e) {
        if (e.which == 13) {
            $("#search_button").click();
            return false;
        }
    });
});