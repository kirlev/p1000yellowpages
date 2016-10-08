/**
 * Created by nir on 10/8/16.
 */
$(function () {
    $(".pagination a").click(function (ev) {
        search(ev, this.href);
        return false;
    });
})
