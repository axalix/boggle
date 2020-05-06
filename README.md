
# Boggle  
Boggle - a word game invented by Allan Turoff.      
    
## How to install TODO    
     
## Game rules and assumptions  
  
One cube is printed with "Qu". This is because "q" is nearly always followed by "u" in English words.  
 
[There are some exceptional rare words without "u" after "q"](https://en.wiktionary.org/wiki/Appendix:English_words_containing_Q_not_followed_by_U)   
  
### How to play     
    
 ![rules](http://mmillerasuprep.weebly.com/uploads/3/2/3/1/32311691/boggle-rules-jpeg-900x1271_orig.jpg)    
    
    
### Board      
 There are 2 possible board types "4x4" (a default one) and "5x5" (optional).    
         
### Dice There is a number of variations of chars distributions among dice.      
The most common ones are names as "classic" and "new" were created for 4x4 games.      
      
http://www.bananagrammer.com/2013/10/the-boggle-cube-redesign-and-its-effect.html      
      
Another custom one "fancy" was added for 5x5 boards and it has next chars distribution:    
  
 AACIO   CELRS   NOSWD   NTVEH   GNABB   WCIMO    TABIL   ADENV   KNOTU   INPSE   JOOAC   TUDEI    
    TYABJ   ZAHMO   EEFHI   LPSTU   HOPSA   LRXDE    
    MOQAC   RSBIF   YEGKL   GILRU   FFKPS   LRVYD    
    DEMPA   ORXDE   UYEGI   WAAEE   AOOTT   ISTTY  
  
  ## Requirements    
 ### Functional:    
 The system should be able to validate words which are present on the board, diagonally, vertically or horizontally, and also validate them against some basic dictionary (doesn’t have to be exhaustive, you can use open API)    
    
- When game starts, new 4x4 board is generated.    
- User can type the words which they think they found.    
- System does validation and adds valid words into a list.    
- Systems keeps track of scores, the score is total number of characters in the word.    
- If word is invalid an error is displayed.    
- When timer runs out user can no longer enter new words, but should see results.    
      
    
### Non-functional:    
 - Must use React for front end client application and Ruby on Rails for backend server application    
- Must include tests    
- Extra credit, optional: add an additional feature you think is interesting    
    
    
## System design    
 There 4 services were created to cover the game logic and design:      
- api      
- api_redis    
- dictionary_redis    
- react    
    
### "dictionary" service TODO    
    
### "api" service TODO    
    
### "api_redis" service TODO    
    
### "react" service TODO    
  
## API  
TODO    
  
## Tests and Code quality  
- "api" service is covered by Rspec tests which are available in `services/api/spec`  
- "api" code quality is monitored and covered by Rubocop with standard Rails rules, enforced with a help of`rubocop-rails_config` gem.  
  
  
    
## Some useful commands      
- `rubocop` - to be sure the code follows the styling.       
   (RuboCop configuration which has the same code style checking as official Ruby on Rails.      
   see *rubocop-rails_config*)      
       
- `bundle exec guard` - live coding quality assessment.