# LingoWord

## Description
An application to find words for the Dutch TV show Lingo.

<img alt="Screenshot" src="https://user-images.githubusercontent.com/5128166/104509116-81e5e400-55e9-11eb-9e18-fb828fa927cb.png" width=512>

## Usage
Enter letters using the keyboard; lowercase letters add yellow letters, uppercase letters add red letters. Tap on a letter to cycle through it's states.

## Rules

### Regular words
* Red indicates that letter is correct
* Yellow indicates that letter is present in the word, but not in that location
* Blue indicates that letter is not present in the word, except for same letters that are already marked red or yellow

### Puzzle words
* Red indicates a letter is correct
* Yellow indicates a letter is present anywhere in the word, including that location

## How it works

The app preloads wordlists for all the occurring lengths of words in the show.

On each entered letter and when a word is of elligible size each known word is checked against the rules of the game, returning a list of possible answers. 
