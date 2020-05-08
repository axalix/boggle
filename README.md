
  
# Boggle
Boggle - a word game invented by Allan Turoff.        
      
## How to install TODO      
1. docker-compose build  
2. docker-compose up -d  
3. the game should be available in a browser here: http://localhost:3001/  
       
## Game rules and assumptions    
 One cube is printed with "Qu". This is because "q" is nearly always followed by "u" in English words.    
   
[There are some exceptional rare words without "u" after "q"](https://en.wiktionary.org/wiki/Appendix:English_words_containing_Q_not_followed_by_U)     
  
Boggle allows words of 2 chars, but won't give points for that. One-character words are not allowed.   
  
    
### How to play       
      
 ![rules](http://mmillerasuprep.weebly.com/uploads/3/2/3/1/32311691/boggle-rules-jpeg-900x1271_orig.jpg)      
      
      
### Board        

 There are 2 possible board types "4x4" (a default one) and "5x5" (optional).      
           

### Dice

There is a number of variations of chars distributions among dice. The most common ones are names as "classic" and "new" were created for 4x4 games.        
        
http://www.bananagrammer.com/2013/10/the-boggle-cube-redesign-and-its-effect.html        
        
Another custom one "fancy" was added for 5x5 boards and it has next chars distribution:      

	AACIOT   ADENVZ   EEFHIY   GILRUW   AOOTTW  
	ABILTY   AHMORS   EGKLUY   AAEEGN   CIMOTU  
	ABJMOQ   BIFORX   EGINTV   ABBJOO   DEILRX  
	ACDEMP   DENOSW   EHINPS   ACHOPS   DELRVY  
	ACELRS   DKNOTU   ELPSTU   AFFKPS   DISTTY
    
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
      
### "dictionary" service  
Simple Redis service, populated with `"SADD", "dict", <word>` command. See `services/dictionary/entrypoint.sh`
*370k* English words were taken from `words_alpha.txt` that was taken from
[https://github.com/dwyl/english-words/blob/master/words_alpha.txt](https://github.com/dwyl/english-words/blob/master/words_alpha.txt)

### "api" service

It is a backend service, built as [API-only Rails app](https://guides.rubyonrails.org/api_app.html)
with this command `rails new boggle --api -O --skip-test --skip-action-mailer --skip-active-record` 

Testing tool `Rspec` was installed separately.

Approximately 100 tests cover the backend logic.

### "api_redis"

"api" service doesn't use ActiveRecord and any relational DB, however it relies on Redis.
"api" service connected to "api_redis" to store games tokens and found words for a certain period of time. This allows to refresh and continue the game from where it was stopped. Also it is possible to previous games within 24 hours.

### "react" service

It is a frontend to run the game. Please note, that 80% of time and main focus was given to backend ("api" service).

    
## API  

Postman file with API is available under
`services/api/Boggle.postman_collection.json`

| Description |Method| Path  | Header | Params |
|--|--|--|--|--|
| Create a new game |POST|/game|-|{dice_type: 'classic_16'}|
| Show Game |GET|/game|Game-Token|-|
| Add a word to a list|POST| /game/word |Game-Token|{word: 'apple'}
| Get game results |GET| /game/results |Game-Token|-|

### Examples

**GET /game**

    {
       "id":"SbItuNy2o_J-u0lb8PA1-Q",
       "board":{
          "size":4,
          "dice_string":"onhiliutauiuiqhp"
       },
       "dice_type":"classic_16",
       "seconds_left":173,
       "words":["apple"]
    }

**GET /game/results**

    {
       "id":"SbItuNy2o_J-u0lb8PA1-Q",
       "board":{
          "size":4,
          "dice_string":"onhiliutauiuiqhp"
       },
       "dice_type":"classic_16",
       "seconds_left":0,
       "results":{
          "total_score":2,
          "words_with_scores":[
             ["tup", 1],
             ["pit", 1]
          ]
       }
    }
    

## Tests and code quality  
  
- "api" service is covered by Rspec tests which are available in `services/api/spec`    
- "api" code quality is monitored and covered by Rubocop with standard Rails rules, enforced with a help of`rubocop-rails_config` gem.    
    
    
      
## Some useful commands

 - `docker exec -it boggle_api bundle exec rubocop` - to be sure the code follows the styling.         
   (RuboCop configuration which has the same code style checking as official Ruby on Rails.        
   see *rubocop-rails_config*)        

 - `docker exec -it boggle_api bundle exec rspec -fd` - to run tests
 
## Dev notes

 - as per requirements, the main focus was given to backend
 - ability to change dice type and refresh / continue a game after a fail over are optional
