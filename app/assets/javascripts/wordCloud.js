
window.onload = function(){
  cloudInitialized = false;

  $('.article-form').submit(function(event) {
    event.preventDefault();

    data = $(this).serialize();

    $('.article-form :input').prop("disabled", true)

    $.ajax({
      type: "POST",
      url: "/wikipedia",
      data: data,
      success: function(response){
        if(!cloudInitialized){
          $('.word-cloud').jQCloud(response,{
            autoResize: true
          });
          cloudInitialized = true;
        } else {
          $('.word-cloud').jQCloud('update', response);
        }

        $('.article-form :input').prop("disabled", false)
      },
      dataType: "json"
    });
  });
}
