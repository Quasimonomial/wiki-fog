Wikifog
=======

The Project
---------------------
[See Wikifog Online](https://desolate-island-84231.herokuapp.com)

This is Wikifog, a word cloud generator for Wikipedia articles.  The app reads the text of a Wikipedia page, then the pages it links to.  It concatenates this text and builds a word cloud from the result.

It can also generate word clouds from a random page.

(Psst... try clicking on a word after the word cloud has rendered.)

System Dependencies
---------------------
This project uses the follow libraries:

### Back End
* the [Wikipedia-Clint gem](https://github.com/kenpratt/wikipedia-client) - it gets us the initial text extract.
* the [HTTParty gem](https://github.com/jnunemaker/httparty) - this one allows us to party hard and also do HTTP requests

### Front End
* [Seleton](http://getskeleton.com/) for styling
* [JQCloud](http://mistic100.github.io/jQCloud/) for generating the word cloud
* [spin.js](http://fgnass.github.io/spin.js/) for showing a spinner

Implementation
---------------


Testing
-------

### Back End

There are tests on the back-end written in [Rspec](http://rspec.info/).  To run them, download and navigate to the Wikifog repo and run

`http://rspec.info/`

into the console.

### Front End

The front end tests are written in [Jasmine](http://jasmine.github.io/).  To run them, download and navigate to the Wikifog repo and run

`rake jasmine`

into the console.

Navigate to `localhost:8888` in your browser.
