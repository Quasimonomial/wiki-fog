
window.onload = function(){
  $('.article-form').submit(function(event) {
    event.preventDefault();

    data = $(this).serialize();
    $.ajax({
      type: "POST",
      url: "/wikipedia",
      data: data,
      success: function(response){
        $('.word-cloud').jQCloud(response);
      },
      dataType: "json"
    });
  });
}
