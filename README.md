# Team BI Demo Bingo
*Created: December 2020*

This is a simple Bingo style application customized for playing during BI group demos.  The board is randomly created from a set of about 50 choices.

# Build and run
This app is built using [Elm](https://elm-lang.org/), a really nice pure functional and front-end focused language based on Haskell. To build and run:

1. [Install Elm](https://guide.elm-lang.org/install/elm.html)
2. Download this repo.
3. `cd bingo`
4. `elm make src/Bingo.elm --output bingo.js`

This last step will generate JS that will then be read by the provided `index.html` file in this directory.  Open the `index.html` file from this directory with your favorite browser.

