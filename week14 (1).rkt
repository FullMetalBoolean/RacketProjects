;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-advanced-reader.ss" "lang")((modname |week14 (1)|) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #t #t none #f () #f)))
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
(define counter-size 50) ;size of the counter numbers
(define start-letter-speed 2) ;the starting velocity of letters falling from top
(define frame-rate 1/60) ;desired frame rate
(define letter-colors (vector "red" "orange" "yellow" "green" "blue" "violet")) ;the colors of the falling letters

;--------------------------------------------------------------------------------------------------------------------

; Type definition: Character Number Number String
(define-struct letter-position (letter x y color))
; Type definition: ListOfletterposition Number Number Number Number
(define-struct World (letters time letters-correct score speed)) ;creates a struct called World with letter, time, and position as parameters

(define start-world ;start-world is a... 
  (make-World ;a world that has...
   (list (make-letter-position #\D half-screen 0 "red")) ; a list of letter position (which the letter position has the character D, D's x and y position, and D's color)...
   10 0 0 start-letter-speed)) ;and time, the number of letters correct, and the score of the game

;--------------------------------------------------------------------------------------------------------------------

;Purpose: convert number to alphabetic letter
;Signature: Number -> Character

;Examples:
(check-expect (converter 0) #\A)
(check-expect (converter 4) #\E)

;Stub: (define (converter num) -1)

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

;--------------------------------------------------------------------------------------------------------------------

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

; Stub : (define (draw-letters lst img) "A")

;Code:
(define (draw-letters lst img) 
  (cond ;a set of conditions of...
    ((empty? lst) img) ;where it lst is empty, then output img
    (else ;otherwise, output...
     (overlay/xy ;the overlaying of...
      (text (string (letter-position-letter (first lst))) ;a text, which is the first character of letter-position-letter turned into a string
            letter-size ;with the size of the text being letter-size
            (letter-position-color (first lst)) ;and the color being the first color of letter-position-color
            )
      (* -1 (letter-position-x (first lst))) ;x position is the first letter-position-x of lst  multiplied by -1
      (* -1 (letter-position-y (first lst))) ;y position is the first letter-position-y of lst multiplied by -1
      (draw-letters (rest lst) img) ;and the text is on top of the recursion of draw-letters with the rest of lst
      )
     )
    )
  )

;--------------------------------------------------------------------------------------------------------------------

;Purpose: Show background
;Signature: World -> Image

;Examples:
(check-expect (draw-scene start-world)
              (draw-letters (World-letters start-world)            
                            (overlay/align "left" "top"
                                           (text (number->string (floor (* frame-rate (World-time start-world)))) counter-size "gray")
                                           (overlay/align "right" "top"
                                                          (text (number->string (World-letters-correct start-world))counter-size "gray")
                                                          (overlay/align "center" "top"
                                                                         (text (number->string (World-score start-world)) counter-size "gray")                                                      
                                                                         background) ;overlaying background
                                                          )
                                           )
                            )
              )

;Stub: (define (draw-background wrld) -1)

;Code:
(define (draw-scene wrld); define draw-scene to be...
  (draw-letters (World-letters wrld) ;the case where draw-letters takes in the letters of wrld
                (overlay/align "left" "top"; the position of the timer
                               (text (number->string (floor (* frame-rate (World-time wrld)))) counter-size "gray") ;image of timer
                               (overlay/align "right" "top" ;the position of the counter that keeps track of the number of letters correct
                                              (text (number->string (World-letters-correct wrld))counter-size "gray") ;image of the counter
                                              (overlay/align "center" "top" ;the position of the score
                                                             (text (number->string (World-score wrld)) counter-size "gray") ;image of the score                                                    
                                                             background) ;overlaying background
                                              )
                               )
                )
  )

;--------------------------------------------------------------------------------------------------------------------


;purpose: animating the image of a letter with the changed y coordinate
;signature: letter-position->letter-position

;examples:
(check-expect (animate-letter (make-letter-position #\D half-screen 0 "red"))
              (make-letter-position #\D half-screen start-letter-speed "red")
              )
;stub: (define (animate-letter letter-psn) -1)

;code:
(define (animate-letter letter-psn)
  (make-letter-position ;creating letter position where...
   (letter-position-letter letter-psn) ;animate-letter takes in the letter of letter-psn
   (letter-position-x letter-psn) ;and the x of letter-psn
   (+ (letter-position-y letter-psn) start-letter-speed) ;and the y of letter-psn, which the y is added to start-letter-speed
   (letter-position-color letter-psn) ;and the color of letter-psn
   )
  )

;--------------------------------------------------------------------------------------------------------------------

;Purpose: create a random letter-position
;Signature: -> letter-position

;Examples:
(check-expect (letter-position-y (make-random-letter-position start-world)) 0)

;Stub:

;Code:
(define (make-random-letter-position wrld)
  (make-letter-position ;making a letter position where...
   (random-letter (World-letters wrld)) ;the letter is a random letter
   (new-x (World-letters wrld)) ;the x is a random position
   0 ;the y is 0 
   (vector-ref letter-colors (random (vector-length letter-colors))) ;and the color is a random color
   )
  )

;--------------------------------------------------------------------------------------------------------------------

;Purpose: Animate image of letter
;Signature: World -> World

;Examples:
(check-expect (tick-handler start-world)
              (make-World
               (list (make-letter-position #\D half-screen start-letter-speed "red")) 11 0 0 start-letter-speed))

;Stub: (define (tick-handler wrld) -1)

;Code:
(define (tick-handler wrld)
  (cond ;set of conditions where...
    ((empty? (World-letters wrld)) ;if the list of letters in wrld is empty, then...
     (make-World ;create a world where...
      (list (make-random-letter-position wrld)) ;the list of letters of the world is of random letter positions
      (+ 1 (World-time wrld)) ;the timer of the wrld is added by 1 (time advancement)
      (World-letters-correct wrld) ;the number of letters correct is the same as wrld
      (World-score wrld) ;the score of wrld is the same
      (World-speed wrld) ;and the speed of the letters in the world is the same
      )
     ) 
    (
     (and  ;if it's true that both...
      (integer? (* frame-rate (World-time wrld))) ;wrld's time multiplied by frame-rate is an integer and
      (< (length (World-letters wrld)) 3) ;the length of wrld's list is less than 3
      ) ;then...
     (make-World ;create a world where...
      (append ;we append new letter at end of list
       (World-letters wrld) ;wrld's letters
       (list (make-random-letter-position wrld)) ;and the list of random letter positions
       ) ;which this will be the world's list of letters
      (+ 1 (World-time wrld)) ;the timer of the wrld is added by 1 (time advancement)
      (World-letters-correct wrld) ;the number of letters correct is the same as wrld
      (World-score wrld) ;the score of wrld is the same
      (World-speed wrld) ;and the speed of the letters in the world is the same
      )
     )
    (else ;otherwise...
     (make-World ;make a whole new world
      (map animate-letter (World-letters wrld)) ;where we apply animate-letter to all the letters in wrld
      (+ 1 (World-time wrld)) ;the timer of the wrld is added by 1 (time advancement)
      (World-letters-correct wrld) ;the number of letters correct is the same as wrld
      (World-score wrld) ;the score of wrld is the same
      (World-speed wrld) ;and the speed of the letters in the world is the same
      )
     )
    )
  )




;--------------------------------------------------------------------------------------------------------------------


(define (overlap? x letter-posn)
  (cond
    ((< (letter-position-x letter-posn) (- x letter-size)) false)
    ((> (letter-position-x letter-posn) (+ x letter-size)) false)
    ((> (letter-position-y letter-posn) letter-size) false)
    (else
     true)
    )
  )

;--------------------------------------------------------------------------------------------------------------------






(define (list-overlap? x lst)
         (cond
           ((empty? lst) false)
           ((overlap? x (first lst)) true)
           (else
            (list-overlap? x (rest lst)
                           )
            )
           )
  )


;--------------------------------------------------------------------------------------------------------------------

(define (new-x lst)
  (let ;equivalent to define inside of a function
      (
       (random-x (random (- screen-size letter-size)))
       )
    (if (list-overlap? random-x lst)
        (new-x lst)
        random-x
        )
    )
  )


;--------------------------------------------------------------------------------------------------------------------


;Purpose: Generate letter-position with random letter that doesn't overlap letters that are already in the world
;Signature: World -> Letter-position
;Examples:


;Stub: (define (generate-letter-position wrld) -1)

;Code:
(define (generate-letter-position wrld)
  (make-letter-position (random-letter) (new-x (World-letters wrld)) 0 )
  )


;--------------------------------------------------------------------------------------------------------------------

;Purpose: Return Boolean to indicate game is over
;Signature: World -> Boolean

;Examples:
(check-expect (game-over? (make-World (list (make-letter-position #\D half-screen (+ screen-size letter-size) "red")) 0 0 0 start-letter-speed)) #t)

;Stub: (define (game-over? wrld) -1)

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

;--------------------------------------------------------------------------------------------------------------------

;Purpose: show the ending screen of a finished game
;Signature: world -> image

;Example:
(check-expect (game-over (make-World (list (make-letter-position #\D half-screen (- screen-size letter-size) "red")) 0 0 0 start-letter-speed))
              (overlay (text "GAME OVER" 80 "red")
                       (draw-scene
                        (make-World (list (make-letter-position #\D half-screen (- screen-size letter-size) "red")) 0 0 0 start-letter-speed))
                       )
              )
;Stub: (define (game-over wrld) -1)

;Code:
(define (game-over wrld)
  (overlay; this overlaying the text on top the old world
   (text "GAME OVER" 80 "red");creating the game over text
   (draw-scene wrld);old world
   )
  )

;--------------------------------------------------------------------------------------------------------------------

; Purpose: to determine if a letter-position contains a certain character
; Signature: letter-position character -> boolean

; Examples:
(check-expect (character-in-position? (make-letter-position #\E 0 0 "cyan") "E") #true)
(check-expect (character-in-position? (make-letter-position #\E 0 0 "cyan") "D") #false)

; Stub: (define (character-in-position? letter-psn char) -1)

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

;--------------------------------------------------------------------------------------------------------------------

;Purpose: when a letter on screen is typed, a random new letter appears
;Signature: World Key -> World

;Examples:
(check-expect (empty? (World-letters (key-handler start-world "D"))) #true)
(check-expect (key-handler start-world "X") start-world)

;Stub: (define (key-handler wrld key) -1)

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
   (not
    (empty? ;if list is not empty...
     (filter ;which is a list is created where the characters are verified whether the key is equal to the letter of letter position
      (λ(letter-psn) ;by using a function that returns a boolean depending on letter position 
        (character-in-position? letter-psn key)) ;lambda applies operation to each letter position 
      (World-letters wrld)) ;and the list being filtered is the letters of wrld 
     )
    );then...
   (make-world ;if it's true, then we have a new world with a faster speed
    (filter ;the list of letters is...
     (λ(letter-psn) ;a list where the characters are verified whether the key is not equal to the letter of letter position
       (character-not-in-position? letter-psn key)) ;by using a function that returns a boolean depending on letter position 
     (World-letters wrld) ;lambda applies operation to each letter position 
     ) ;and the list being filtered is the letters of wrld;list of letters
    (World-time wrld) ;time
    (+ (World-letters-correct wrld) 1) ;number of letters correct
    (+ (letter-score (char-upcase (string-ref key 0))) (World-score wrld)) ;score
    (* 1.05 (World-speed wrld)) ;speed
    )
   (make-world ;if it's not, then we have the old world with a slower speed
    ;list of letters
    ;time
    ;number of letters correct
    ;score
    ;speed
    )
   )
  )


;--------------------------------------------------------------------------------------------------------------------

;Purpose: creates a randomized letter
;signature: ListofLetterPositions -> Character

;Examples:
(check-expect (char>=? (random-letter (list)) #\A) #true)
(check-expect (char<=? (random-letter (list)) #\Z) #true)

;Stub: (define (random-letter) 3)

;Code:
(define (random-letter lst)
  (let ;equivalent to define inside of a function
      (
      (random-char
       (vector-ref alphabet ;picking an element from alphabet
                   (random (vector-length alphabet)) ;which the reference is a random number between 0 to 25
                   )
       )
    )
  (cond
    ((empty? lst) random-char)
    ((char=? (letter-position-letter (list-ref lst (- (length lst) 1))) random-char) (random-letter lst))
    (else random-char)
    )
  )
)

;--------------------------------------------------------------------------------------------------------------------

;Purpose: create a randomized position of the letter between the width of the frame
;signature:->number

;examples:
(check-expect (> (random-position) 0) #true)
(check-expect (< (random-position) (- screen-size letter-size)) #true)

;Stub: (define (random-position) "s")

;Code:
(define (random-position)
  (random (- screen-size letter-size)) ;creating a random location so that the letter fits within the screen size
  )

;--------------------------------------------------------------------------------------------------------------------

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

;hash table
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

;--------------------------------------------------------------------------------------------------------------------

(big-bang (make-World ;creating a world
           (list)
           0  ;world's time
           0  ;number of letters correct in the world
           0 ;world's score
          start-letter-speed) ;world's speed
  (on-draw draw-scene) ;generates an image
  (on-tick tick-handler frame-rate) ;animates the falling letters and timer
  (stop-when game-over? game-over) ;tells the animation when to stop
  (on-key key-handler) ;allows the user to use the keyboard
  )