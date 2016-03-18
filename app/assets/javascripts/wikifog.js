var Wikifog = {
  cloudInitialized: false,

  addEventHandlers: function(response){
    var size = _.size(response);
    for(var word in response){
      response[word].handlers = {
        click: function(){
          Wikifog.requestCloudData({
            "wikipedia": {
              "article_title": this.textContent,
              "word_count": size
            }
          });
        }
      }
    }
  },

  clearPageAndDisplaySpinner: function(){
    var notice = $('.notice');
    notice.html("");

    $('.article-form :input').prop("disabled", true);
    $('.word-cloud').html('');
    $('.notice-container').addClass('hidden');
    this.spinner.spin($('.word-cloud')[0]);
  },

  displayCloud: function(response){
    if(!Wikifog.cloudInitialized){
      $('.word-cloud').jQCloud(response,{
        autoResize: true
      });
      Wikifog.cloudInitialized = true;
    } else {
      $('.word-cloud').jQCloud('update', response);
    }
  },

  displayError: function(){
    $('.notice-container').removeClass('hidden');
    $('.notice').html("<p>The requested article was not found.</p>");
  },

  enableForm: function(){
    $('.article-form :input').prop("disabled", false)
    Wikifog.spinner.stop()
  },

  getFormData: function(){
    return $('.article-form').serialize();
  },

  requestCloudData: function(data){
    this.clearPageAndDisplaySpinner();

    $.ajax({
      type: "POST",
      url: "/wikipedia",
      data: data,
      success: Wikifog.requestSuccess,

      error: Wikifog.displayError,

      complete: Wikifog.enableForm,

      dataType: "json"
    });
  },

  requestSuccess: function(response){
    Wikifog.addEventHandlers(response);
    Wikifog.displayCloud(response);
  },

  spinner: new Spinner({
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
  })
}


window.onload = function(){
  $('.article-form').submit(function(event) {
    event.preventDefault();

    data = Wikifog.getFormData();

    Wikifog.requestCloudData(data);
  });
}
