;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-advanced-reader.ss" "lang")((modname finalprojectweek15) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #t #t none #f () #f)))
;5580893 Jeremy Reuwer
;5741181 Sun Kang
; Typing Tutor
; Final Project CISC 106 Fall 2018
; Authors: The class of CISC 106 Fall 2018 and the professor

(require 2htdp/image)
(require 2htdp/universe)

;Constants
(define screen-size 500);width and height of screen
(define half-screen (/ screen-size 2));midpoint of screen
(define background (rectangle screen-size screen-size "solid" "black")) ;static background image
(define letter-size 30) ;size of letters used for game
(define counter-size 25) ;size of the counter numbers
(define start-letter-speed 2) ;velocity of letters falling from top
(define frame-rate 1/60) ;desired frame rate
(define letter-colors (vector "red" "orange" "yellow" "green" "blue" "violet")) ;the colors of the falling letters

;type definition character number number string
(define-struct letter-position (letter x y color))
; Type definition: ListOfletterposition Number Number Number Number
(define-struct World (letters time letters-correct score speed key-counter)) ;creates a struct called World with letter, time, and position as parameters
(define start-world  (make-World (list (make-letter-position #\D half-screen 0 "red"))
                                 10 0 0 start-letter-speed 0)) ;world that has a letter D at time 0, at the midpoint of screen

;Purpose: convert number to alphabetic letter
;Signature: Number -> Character
;Examples:
(check-expect (converter 0) #\A)
(check-expect (converter 4) #\E)
;Stub:
;Code:
(define (converter num)
  (integer->char ;case where we change an integer to a character ...
   (+ ;where the integer is the addition of...
    (char->integer #\A) ;the character of A changed to an integer which means that this turns 0 into A                     
    num); and num
   )
  )


(define alphabet ; define alphabet to be a
  (build-vector 26 converter)); vector containing all of the letters of the alphabet

;Purpose: To have 3 letters displayed on the background
;Signature: List Image -> Image
;Examples:
(check-expect (draw-letters (list) background) background)
(check-expect (draw-letters (list (make-letter-position #\D half-screen 0 "red")) background)
              (overlay/xy
               (text (string #\D) letter-size "red")
               (* -1 half-screen)
               0
               background))
; Stub :
;(define (draw-letters lst img) "A")
;Code:
(define (draw-letters lst img) 
  (cond ;a set of conditions of...
    ((empty? lst) img) ;where it lst is empty, then output img
    (else ;otherwise...
     (overlay/xy ;the overlaying of...
      (text (string (letter-position-letter (first lst))) letter-size (letter-position-color (first lst)))  ;a text, which is the first character of letter-position-letter turned into a string
      (* -1 (letter-position-x (first lst))) ;x position is the first letter-position-x of lst  multiplied by -1
      (* -1 (letter-position-y (first lst))) ;y position is the first letter-position-y of lst  multiplied by -1
      (draw-letters (rest lst) img) ;and the text is on top of the recursion of draw-letters with the rest of lst
      )
     )
    )
  )


;Purpose: Show background
;Signature: World -> Image
;Examples:
(check-expect (draw-scene start-world)
              (draw-letters (World-letters start-world)            
                            (overlay/align "left" "top"
                                           (text (string-append (number->string (floor (* frame-rate (World-time start-world)))) " seconds") counter-size "gray")
                                           (overlay/align "right" "top"
                                                          (text (string-append (number->string (World-letters-correct start-world)) " letters correct") counter-size "gray")
                                                          (overlay/align "center" "top"
                                                                         (text (string-append (number->string (World-score start-world)) " points") counter-size "gray")                                                      
                                                                         background) ;overlaying background
                                                          )
                                           )
                            )
              )

;Stub:
;(define (draw-background wrld) -1)
;Code:
(define (draw-scene wrld); define draw-scene to be...
  (draw-letters (World-letters wrld) ;the case where draw-letters takes in the letters of wrld                                   
                (if ;the condition where...
                 (and ;both conditions must apply where...
                  (= 0 (remainder (World-letters-correct wrld) 10)) ;remainder of number of letters correct divided by 10 equals 0
                  (not (= 0 (World-letters-correct wrld)))) ;and number of letters correct does not equal 0
                 (overlay/align "center" "center" ;if the condition is true, output the overlay of... 
                                (text "You Rock~!" (* counter-size 2) "gray") ;the text "You Rock~!"
                                (overlay/align "left" "top"; the position of the timer
                                               (text (string-append (number->string (floor (* frame-rate (World-time wrld))))  " seconds") counter-size "gray") ;image of timer
                                               (overlay/align "right" "top" ;the position of the counter that keeps track of the number of letters correct
                                                              (text (string-append (number->string (World-letters-correct wrld)) " letters correct") counter-size "gray") ;image of the counter
                                                              (overlay/align "center" "top" ;the position of the score
                                                                             (text (string-append (number->string (World-score wrld)) " points") counter-size "gray") ;image of the score                  
                                                                             background)))) ;overlaying background
                 
                 (overlay/align "center" "center" ;else, overlay the text...
                                (text " " (* counter-size 2) "gray") ;with an empty string         
                                (overlay/align "left" "top"; the position of the timer
                                               (text (string-append (number->string (floor (* frame-rate (World-time wrld))))  " seconds") counter-size "gray") ;image of timer
                                               (overlay/align "right" "top" ;the position of the counter that keeps track of the number of letters correct
                                                              (text (string-append (number->string (World-letters-correct wrld)) " letters correct") counter-size "gray") ;image of the counter
                                                              (overlay/align "center" "top" ;the position of the score
                                                                             (text (string-append (number->string (World-score wrld)) " points") counter-size "gray") ;image of the score                  
                                                                             background) ;overlaying background
                                                              )
                                               )
                                )
                 )
                )
  )

;purpose: animating the image of a letter with the changed y coordinate
;signature: letter-position->letter-position
;examples
(check-expect (animate-letter (make-letter-position #\D half-screen 0 "red") 42)
              (make-letter-position #\D half-screen 42 "red")
              )
;stub:
;(define (animate-letter letter-psn) -1)

;code:
(define (animate-letter letter-psn speed)
  (make-letter-position ;making a letter position where...
   (letter-position-letter letter-psn) ;animate-letter takes in the letter of letter-psn
   (letter-position-x letter-psn) ;and the x of letter-psn
   (+ (letter-position-y letter-psn) speed)  ;and the y of letter-psn, which the y is added to start-letter-speed
   (letter-position-color letter-psn) ;and the color of letter-psn
   )
  )

;Purpose: create a random letter-position
;Signature: -> letter-position
;Examples:
(check-expect (letter-position-y (make-random-letter-position start-world)) 0)
;Stub:
;Template:
;Code:
(define (make-random-letter-position wrld)
  (make-letter-position ;making a letter position where...
   (random-letter (World-letters wrld)) ;the letter is a random letter
   (new-x (World-letters wrld)) ;the x is a random position
   0 ;the y is 0 
   (vector-ref letter-colors (random (vector-length letter-colors))) ;and the color is a random color
   )
  )

;Purpose: Animate image of letter
;Signature: World -> World
;Examples:
(check-expect (tick-handler start-world)
              (make-World
               (list (make-letter-position #\D half-screen start-letter-speed "red")) 11 0 0 start-letter-speed 0))
;Stub
;(define (tick-handler wrld) -1)
;Code:
(define (tick-handler wrld)
  (cond ;set of conditions where...
    ((empty? (World-letters wrld)) ;if the list of letters in wrld is empty, then...
     (make-World ;create a world where...
      (list (make-random-letter-position wrld)) ;the list of letters of the world is of random letter positions
      (+ 1 (World-time wrld))  ;the timer of the wrld is added by 1 (time advancement)
      (World-letters-correct wrld) ;the number of letters correct is the same as wrld
      (World-score wrld) ;the score of wrld is the same
      (World-speed wrld) ;and the speed of the letters in the world is the same
      (World-key-counter wrld) ;number of keys hit total starts at zero
      )
     )
    ((and ;if it's true that both...
      (integer? (* frame-rate (World-time wrld))) (< (length (World-letters wrld)) 3))  ;wrld's time multiplied by frame-rate is an integer and
     (make-World ;create a world where...
      (append ;append new letter at end of list
       (World-letters wrld) ;wrld's letters
       (list (make-random-letter-position wrld))) ;and the list of random letter positions
      (+ 1 (World-time wrld)) ;time advancements
      (World-letters-correct wrld) ;the number of letters correct is the same as wrld
      (World-score wrld) ;the score of wrld is the same
      (World-speed wrld) ;and the speed of the letters in the world is the same
      (World-key-counter wrld) ;number of keys hit total 
      )
     )
    (else ;otherwise...
     (make-World ;makes a whole new world
      (map ;apply operation to every element on list
       (λ(letter-posn)(animate-letter letter-posn (World-speed wrld))) ;where we apply animate-letter to all the letters in wrld
       (World-letters wrld) ;lambda applies operation to each letter position
       )
      (+ 1 (World-time wrld)) ;time advancements
      (World-letters-correct wrld) ;the number of letters correct is the same as wrld
      (World-score wrld) ;the score of wrld is the same
      (World-speed wrld) ;and the speed of the letters in the world is the same
      (World-key-counter wrld) ;number of total keys hit
      )
     )
    )
  )


;Purpose: Given a x value, return a x value that doesn't overlap eachother.
;Signature: Number Letter-position -> Boolean
;Examples:
(check-expect (overlap? half-screen (make-letter-position #\D (+ 31 half-screen) 0 "red")) false)
(check-expect (overlap? half-screen (make-letter-position #\D half-screen 31 "red")) false)
(check-expect (overlap? half-screen (make-letter-position #\D (+ 30 half-screen) 0 "red")) true)
(check-expect (overlap? half-screen (make-letter-position #\D (- half-screen 31) 0 "red")) false)
;stub
;(define (overlap? x letter-psn) -1)
;code
(define (overlap? x letter-posn)
  (cond ;set of conditions where...
    ((< (letter-position-x letter-posn) (- x letter-size)) false) ;if the x of letter-posn is less than the inputted x minus letter-size, output false
    ((> (letter-position-x letter-posn) (+ x letter-size)) false) ;if the x of letter-posn is greater than the inputted x plus letter-size, output false
    ((> (letter-position-y letter-posn) letter-size) false) ;if the y of letter-posn is greater than the letter-size, output false
    (else ;otherwise...
     true) ;output true
    )
  )


;Purpose: Check if the list of letters overlap
; Signature: number list of letter positions -> Boolean
;Examples:
(check-expect
 (list-overlap? half-screen
                (list
                 (make-letter-position #\D (/ screen-size 2) 0 "red")
                 (make-letter-position #\C (/ screen-size 3) 0 "green")
                 (make-letter-position #\E (/ screen-size 4) 0 "blue")
                 )
                )
 true)
(check-expect
 (list-overlap? half-screen
                (list                 
                 (make-letter-position #\C (/ screen-size 3) 0 "green")
                 (make-letter-position #\E (/ screen-size 4) 0 "blue")
                 (make-letter-position #\D (/ screen-size 2) 0 "red")
                 )
                )
 true)
(check-expect (list-overlap? half-screen '()) false)

;Stub: (define (list-overlap? x lst) -1)
;Template:
;(define (list-overlap? x lst)
;(cond
;((...) ...)
;((...) ...)
;((...) ...)
;((...) ...)
;(else ...)))
;Code:
(define (list-overlap? x lst)
  (cond ;set of conditions where...
    ((empty? lst) false) ;if the lst is empty, output false
    ((overlap? x (first lst)) true) ;if it's true that a letter overlaps the first letter of lst, output true
    (else ;otherwise...
     (list-overlap? x (rest lst)) ;recursively see if this applies to the rest of the lst
     )
    )
  )

;Purpose: Return a random x-coordinate that doesn't overlap
;Signature: ListofLetterPositions -> Number
;Examples:

(check-expect
 (or
  (< (new-x
      (list                 
       (make-letter-position #\E (/ screen-size 4) 0 "blue")
       )
      )
     (- (/ screen-size 4) letter-size)
     )
  (> (new-x
      (list                 
       (make-letter-position #\E (/ screen-size 4) 0 "blue")
       )
      )
     (+ (/ screen-size 4) letter-size)
     )
  )
 true)
;Stub:
;(define (new-x lst) "Program")
;Code:
(define (new-x lst)
  (let ;equivalent to define inside of a function
      (
       (random-x ;let random-x be...
        (random (- screen-size letter-size))) ;a random number between 0 and up to screen-size minus letter-size
       )
    (if (list-overlap? random-x lst) ;if the letters in the lst overlap...
        (new-x lst) ;then output a new x
        random-x ;otherwise, output random-x
        )
    )
  )


;Purpose: Return Boolean to indicate game is over
;Signature: World -> Boolean
;Examples:
(check-expect (game-over? (make-World (list
                                       (make-letter-position #\D half-screen (+ screen-size letter-size) "red"))
                                      0 0 0 start-letter-speed 0)) #t)
;Stub
;(define (game-over? wrld) -1)
;Code
(define (game-over? wrld)
  (cond ;set of conditions where...
    ((empty? (World-letters wrld)) #false) ;if the list of letters of wrld is empty, it's false
    (else ;otherwise...
     (<= screen-size ;comparing screen size to bottom of letter
         (+ ;addition of
          (letter-position-y (first (World-letters wrld))) ;y posn of the world      
          letter-size);and letter size
         ) ;and if screen size is less than or equal to the sum, then is is true, otherwise false
     )
    )
  ); when the letter meets the bottom of the screen then its game over


;Purpose: show the ending screen of a finished game
;Signature: world -> image
;Example:
(check-expect (game-over (make-World (list
                                      (make-letter-position #\D half-screen (- screen-size letter-size) "red"))
                                     0 0 0 start-letter-speed 0))
              (overlay (text "GAME OVER" 80 "red")
                       (overlay/align "center" "bottom"
                                      (text (string-append (number->string 0) " % correct") (* counter-size 2) "gray")
                                      (draw-scene
                                       (make-World (list
                                                    (make-letter-position #\D half-screen (- screen-size letter-size) "red"))
                                                   0 0 0 start-letter-speed 0)
                                       )
                                      )
                       )
              )


;Stub:
;(define (game-over wrld) -1)
;Code:
(define (game-over wrld)
  (if (= 0 (World-letters-correct wrld)) ;if number of letters correct is zero
      (overlay/align "center" "bottom" ;overlay and place ...
                     (text (string-append (number->string 0) " % correct") (* counter-size 2) "gray") ;0 percent
                     (overlay; this overlaying the text on top the old world
                      (text "GAME OVER" 80 "red") ;creating the game over text
                      (draw-scene wrld) ;old world
                      )
                     )      
      (overlay/align "center" "bottom" ;otherwise overlay and place ...
                     (text (string-append ;append strings
                            (number->string (round (* 100 (* 1 (/ (World-letters-correct wrld) (World-key-counter wrld)))))) ;percentage calculations cinverted to string                    
                            " % correct") ;append text
                           (* counter-size 2) "gray")   
                     (overlay; this overlaying the text on top the old world
                      (text "GAME OVER" 80 "red") ;creating the game over text
                      (draw-scene wrld) ;old world
                      )
                     )
      )
  )

; Purpose: to determine if a letter-position contains a certain character
; Signature: letter-position character -> boolean
; Examples:
(check-expect (character-in-position? (make-letter-position #\E 0 0 "cyan") "E") #true)
(check-expect (character-in-position? (make-letter-position #\E 0 0 "cyan") "D") #false)

; Stub:
;(define (character-in-position? letter-psn char) -1)
;code:

(define (character-in-position? letter-psn str)
  (char=? ;comparing if two characters are the same
   (letter-position-letter letter-psn) ;the first character being the letter from letter-psn
   (char-upcase (string-ref str 0)) ;and the second character being str turned into a character
   )
  )


(define (character-not-in-position? letter-psn str)
  (not(char=? ;comparing if two characters are not the same
       (letter-position-letter letter-psn) ;the first character being the letter from letter-psn
       (char-upcase (string-ref str 0)) ;and the second character being str turned into a character
       )
      )
  )

;Purpose: when a letter on screen is typed, a random new letter appears
;Signature: World Key -> World
;Examples:
(check-expect (empty? (World-letters (key-handler start-world "D"))) #true)
(check-expect (key-handler start-world "X") (make-World (list (make-letter-position #\D half-screen 0 "red")) 10 0 0 1.9 1))

;Stub:
;(define (key-handler wrld key) -1)
;Template:
;(define (key-handler wrld key)
;  (cond
;    ((...) ... ...)
;    (else
;     ...)
;    )
;  )

;Code:
(define (key-handler wrld key)
  (if 
   (not(empty? ;if list is not empty
     (filter 
      ;function that returns boolean depending on letter position
      ;whether the key is equal to the letter of letter position
      (λ(letter-psn) ;a list where the characters are verified whether the key is equal to the letter of letter position
        (character-in-position? letter-psn key)) ;lambda applies operation to each letter position
      (World-letters wrld)) ;lambda applies operation to each letter position
     )
    )
   (make-World ;if it is true new world
    (filter (λ(letter-psn) ;a list where the characters are verified whether the key is not equal to the letter of letter position
              (character-not-in-position? letter-psn key)) ;by using a function that returns a boolean depending on letter position 
            (World-letters wrld)) ;list
    (World-time wrld) ;time
    (+ (World-letters-correct wrld) 1) ;correct
    (+ (letter-score (char-upcase (string-ref key 0))) (World-score wrld));score
    (* 1.05 (World-speed wrld)) ;speed
    (+ (World-key-counter wrld) 1) ;add one to key counter
    )
   (make-World ;if false old-world with slower speed
    (World-letters wrld) ;list
    (World-time wrld) ;time
    (World-letters-correct wrld) ;correct
    (World-score wrld) ;score
    (* .95 (World-speed wrld)) ;speed
    (+ (World-key-counter wrld) 1) ;update key counter
    )
   )
  )




;Purpose: create a randomized letter
;signature:listofletter-positions -> character
(check-expect (char>=? (random-letter (list)) #\A) #true)
(check-expect (char<=? (random-letter (list)) #\Z) #true)
;Stub:
;(define (random-letter) 3)
;Code:
(define (random-letter lst)
  (let ; equivalent to define inside of a function
      (
       (random-char (vector-ref alphabet ;picking an element from alphabet
                                (random (vector-length alphabet)) ;which the reference is a random number between 0 to 25
                                )
                    )
       )
    (cond ;set of conditions where...
      ((empty? lst ) random-char) ;if lst is empty, output random-char
      ((char=? (letter-position-letter (list-ref lst (- (length lst) 1))) random-char) (random-letter lst)) ;if the last letter of lst is equal to random-char, output a random letter
      (else random-char) ;otherwise output random character
      )
    )
  )



;Purpose: create a randomized position of the letter between the width of the frame
;signature:->number
;examples:
(check-expect (> (random-position) 0) #true)
(check-expect (< (random-position) (- screen-size letter-size)) #true)
;Stub:
;(define (random-position) "s")
;Code:
(define (random-position)
  (random (- screen-size letter-size)) ;creating a random location so that the letter fits within the screen size
  )


;Purpose: For each standard finger letter position, those are worth 1 point; the others are worth 3 points
;Signature: Char -> Number
;Examples:
(check-expect (letter-score #\A) 1)
(check-expect (letter-score #\S) 1)
(check-expect (letter-score #\D) 1)
(check-expect (letter-score #\F) 1)
(check-expect (letter-score #\J) 1)
(check-expect (letter-score #\K) 1)
(check-expect (letter-score #\L) 1)
(check-expect (letter-score #\Q) 3)

;Stub:(define (letter-score char) -1)

;Template:
;(define (letter-score char)
;  (cond
;    ((...)...)
;    (else
;     ...)
;    )
;  )
(define 1-point
  (make-hash ;creates a hash table where...
   (list (list #\A 1) ;the standard finger keyboard positions...
         (list #\S 1) ;are worth 1 point
         (list #\D 1)
         (list #\F 1)
         (list #\J 1)
         (list #\K 1)
         (list #\L 1)
         )
   )
  )
;Code:
(define (letter-score char)
  (cond ;set of conditions where...
    ((hash-has-key? 1-point char) 1) ;if chara has a key in 1-point, output 1
    (else ;otherwise
     3) ;output 3
    )
  )


(big-bang (make-World;creating a world
           (list)
           0 ;world's time
           0 ;number of letters correct in the world
           0 ;world's score
           start-letter-speed ;world's speed
           0) ;worlds total keys correct
          (on-draw draw-scene) ;generates an image
          (on-tick tick-handler frame-rate) ;animates the falling letters and timer
          (stop-when game-over? game-over) ;tells the animation when to stop
          (on-key key-handler) ;allows the user to use the keyboard
          )