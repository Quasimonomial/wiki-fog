describe("Wikifog", function() {
  beforeEach(function(){
    loadFixtures("index.html");
  });

  describe("displaying errors", function(){

    it("should display an error message when the ajax returns errors", function(){
      spyOn($, "ajax").and.callFake(function(error) {
        error.error({});
      });

      Wikifog.requestCloudData();

      expect($('.notice-container')).not.toHaveClass('hidden');
      expect($('.notice')).not.toBeEmpty()
    });

    it("should remove error message on next submit", function(){
      spyOn($, "ajax");

      $('.notice-container').removeClass('hidden');
      $('.notice').html('<p>An Error Message</p>');

      expect($('.notice-container')).not.toHaveClass('hidden');
      expect($('.notice')).not.toBeEmpty()

      Wikifog.requestCloudData();

      expect($('.notice-container')).toHaveClass('hidden');
      expect($('.notice')).toBeEmpty()
    });
  });

  describe("The Spinner", function(){
    beforeEach(function() {
      jasmine.Ajax.install();
    });
    afterEach(function() {
      jasmine.Ajax.uninstall();
    });

    it("A spinner appears when an ajax request begins, and disappears after", function(){
      expect($('.spinner').length).toEqual(0);

      Wikifog.requestCloudData();

      expect($('.spinner').length).toEqual(1);

      jasmine.Ajax.requests.mostRecent().respondWith({
        "status": 200
      });

      expect($('.spinner').length).toEqual(0);
    });

    it("Form is disabled while request is being made", function(){

      expect($('.article-form :input')[0]).not.toBeDisabled();
      expect($('.article-form :input')[1]).not.toBeDisabled();

      Wikifog.requestCloudData();

      expect($('.article-form :input')[0]).toBeDisabled();
      expect($('.article-form :input')[1]).toBeDisabled();

      jasmine.Ajax.requests.mostRecent().respondWith({
        "status": 200
      });

      expect($('.article-form :input')[0]).not.toBeDisabled();
      expect($('.article-form :input')[1]).not.toBeDisabled();
    });
  });

  describe("toggleMenu()", function(){
    it("opens and closes the menu", function(){
      expect($('.dropdown-menu-content')).not.toHaveClass('hidden');
      $('.dropdown-menu-button').click();
      expect($('.dropdown-menu-content')).toHaveClass('hidden');
      $('.dropdown-menu-button').click();
      expect($('.dropdown-menu-content')).not.toHaveClass('hidden');
    });
  });

  describe("Menu", function(){
    beforeEach(function() {
      jasmine.Ajax.install();
      Wikifog.initListeners();
    });
    afterEach(function() {
      jasmine.Ajax.uninstall();
    });

    it("sends a request", function(){
      var requestSpy = spyOn(Wikifog, "requestCloudData");

      $('.title').val("cat")

      $('.submit-word').click()


      expect(requestSpy).toHaveBeenCalledWith('wikipedia%5Barticle_title%5D=cat&wikipedia%5Bword_count%5D=');
    });

    it("sends a request for a random page", function(){
      var requestSpy = spyOn(Wikifog, "requestCloudData");

      $('.random_page').click()

      expect(requestSpy).toHaveBeenCalledWith({
        wikipedia: {
          random_page: true
        }
      });
    });
  });
});
