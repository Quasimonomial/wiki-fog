console.log("what")

window.onload = function(){
  $('.article-form').submit(function(event) {
    event.preventDefault();
    console.log("button click")

    data = $(this).serialize();
    $.ajax({
      type: "POST",
      url: "/wikipedia",
      data: data,
      success: function(response){
        debugger
        console.log("success")
      },
      dataType: "json"
    });

  });
}
