$(document).ready(function() {
    $('.planview').on('click', function () {
        var $data = $('#openPopup span').text();
        // var url = '/mycompany/login/'+$data;
        $.ajax({
            type: 'GET',
            // url: url,
            success: function (output) {
                $('#login_for_review').html(output).modal('show');// I tried to show this response as modal popup
            },
            error: function(output){
                alert("fail");
            }
        });
    });
});