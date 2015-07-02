# HANGMAN - Strickingly test

##Stack
For this small project I used the following stack :
* [Jade](https://github.com/jadejs/jade)
* [CoffeeScript](https://github.com/jashkenas/coffeescript)
* [Gulp](https://github.com/gulpjs/gulp)
* [JQuery](https://github.com/jquery/jquery)
* [RequireJS](https://github.com/jrburke/requirejs)

##Let's get down the '_algo_'

### Initialisation
I'm loading 2 dictionnaries of different sizes.
one around 160K words and the other one with more than 400K words
After that I start the game.

### For each guess
I check all the word that match the guessing pattern. (ex: "\*\*\*E\*PP\*")

First i check inside the small dictionnary, if I can't find any word matching the pattern, il will search inside the big dictionnary.

After I found the matched words, i calculate the frequencies of each letter inside all these words.

Finally I pick the most frequent letter to make the next guess.

But if I can't find anymore word in the big dictionnary, i will look at all the letters of the alphabet I didn't try.

##Improvements
For each guess, if i m finally searching inside all the last letters of the alphabet, i think i can calculate the probability of the next guessed letter is a voyel or consonant.


But I didn t have enough time to make these optimizations. :(

##Want a try
Install all the packages needed for the workflow
```
> npm install
```

After that you just need to load the workflow with this command:
```
> gulp
```
and your favorite browser will open automatically.

Open your browser web dev tool and check the console. you will see some information during the game.


## Notes
It took me some time at the beginning to think about the process and algo. It was very fun to work on this little game.
Thank you