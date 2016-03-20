describe("Wikifog", function() {
  describe("toggleMenu", function(){
    it("opens and closes the menu", function(){
      loadFixtures("index.html");
      expect($('.dropdown-menu-content')).not.toHaveClass('hidden');
      $('.dropdown-menu-button').click();
      expect($('.dropdown-menu-content')).toHaveClass('hidden');
      $('.dropdown-menu-button').click();
      expect($('.dropdown-menu-content')).not.toHaveClass('hidden');
    });
  });
});
