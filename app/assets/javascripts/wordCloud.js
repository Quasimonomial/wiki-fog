
window.onload = function(){
  cloudInitialized = false;

  spinnerOpts = {
    lines: 13,
    length: 68,
    width: 22,
    radius: 54,
    scale: 1,
    color: ["#0cf", "#0cf", "#0cf", "#39d", "#90c5f0", "#90a0dd", "#90c5f0", "#a0ddff", "#99ccee", "#aab5f0"], // colors that the word cloud uses by default
    opacity: 0.3,
    speed: 0.5,
    trail: 70,
    className: 'spinner',
    shadow: true
  }

  spinner = new Spinner(spinnerOpts)

  getFormData = function(){
    return $('.article-form').serialize();
  }

  var requestCloudData = function(data){
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
      },
      complete: function(){
        $('.article-form :input').prop("disabled", false)
        spinner.stop()
      },

      dataType: "json"
    });
  }


  $('.article-form').submit(function(event) {
    event.preventDefault();

    data = getFormData();

    $('.article-form :input').prop("disabled", true);
    spinner.spin($('.word-cloud')[0]);

    requestCloudData(data);
  });
}
