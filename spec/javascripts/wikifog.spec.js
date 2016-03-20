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

  describe("toggleMenu", function(){
    it("opens and closes the menu", function(){
      expect($('.dropdown-menu-content')).not.toHaveClass('hidden');
      $('.dropdown-menu-button').click();
      expect($('.dropdown-menu-content')).toHaveClass('hidden');
      $('.dropdown-menu-button').click();
      expect($('.dropdown-menu-content')).not.toHaveClass('hidden');
    });
  });
});
