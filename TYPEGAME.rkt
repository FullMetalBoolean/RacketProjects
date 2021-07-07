;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-advanced-reader.ss" "lang")((modname TYPEGAME) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #t #t none #f () #f)))
; Typing Tutor
; Final Project CISC 106 Fall 2018
; Authors: The class of CISC 106 Fall 2018 and the professor 
; Sun Kang, Tanner Pettit, Tyler Hayes, Mark Bernstein, Justin Yandall, Christopher Crain, Brett Young, Santos Graham, Jeremy Reuwer

(require 2htdp/image)
(require 2htdp/universe)

;Constants
(define screen-size 500);width and height of screen
(define half-screen (/ screen-size 2));midpoint of screen
(define background (rectangle screen-size screen-size "solid" "gray")) ;static background image
(define letter-size 25) ;size of letters used for game
(define counter-size 50) ;size of the counter numbers
(define letter-speed 5) ;velocity of letters falling from top

; Type definition: Character Number Posn
(define-struct World (letter time position)) ;creates a struct called World with letter, time, and position as parameters
(define start-world (make-World #\D 0 (make-posn half-screen 0))) ;world that has a letter D at time 0, at the midpoint of screen

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

;Purpose: Convert string to characters
;Signature 

;Purpose: Show background
;Signature: World -> Image
;Examples:
(check-expect (draw-scene start-world)
              (overlay/xy
               (text (string (World-letter start-world)) letter-size "red")
               (* -1 (posn-x (World-position start-world)))
               (* -1 (posn-y (World-position start-world)))               
               (overlay/align "left" "top"
                              (text (number->string (World-time start-world)) counter-size "black")
                              background
                              )
               )
              )
;Stub:
;(define (draw-background wrld) -1)
;Code:
(define (draw-scene wrld); define draw-scene to be the  
  (overlay/xy; alignment of
   (text (string (World-letter wrld)) letter-size "red") ; the random letter     
   (* -1 (posn-x (World-position wrld)));the x position of the letter
   (* -1 (posn-y (World-position wrld)));the y position of the letter 
   (overlay/align "left" "top"; the position of the timer
                  (text (number->string (World-time wrld)) counter-size "black") ;image of timer
                  background ;overlaying background
                  )
   )
  )

;Purpose: Animate image of letter
;Signature: World -> World
;Examples:
(check-expect (tick-handler start-world) (make-World #\D 1 (make-posn half-screen letter-speed)))
;Stub
;(define (tick-handler wrld) -1)
;Code:
(define (tick-handler wrld) 
  (make-World ;makes a whole new world
   (World-letter wrld) ;makes same letter
   (+ 1 (World-time wrld)) ;time advancements
   (make-posn ;new posn
    (posn-x (World-position wrld)) ;same x
    (+ (posn-y (World-position wrld)) letter-speed)) ;advancement of y position
   )
  )

;Purpose: Return Boolean to indicate game is over
;Signature: World -> Boolean
;Examples:
(check-expect (game-over? (make-World "D" 0 (make-posn half-screen (+ screen-size letter-size)))) #t)
;Stub
;(define (game-over? wrld) -1)
;Code
(define (game-over? wrld) 
  (<= screen-size ;comparing screen size to bottom of letter
      (+ ;addition of 
       (posn-y (World-position wrld)) ;y posn of the world        
       letter-size);and letter size
      ) ;and if screen size is less than or equal to the sum, then is is true, otherwise false
  ); when the letter meets the bottom of the screen then its game over 


;Purpose: show the ending screen of a finished game
;Signature: world -> image
;Example:
(check-expect (game-over (make-World #\D 0 (make-posn half-screen (- screen-size letter-size))))
              (overlay (text "GAME OVER" 80 "red")
                       (draw-scene
                        (make-World #\D 0 (make-posn half-screen (- screen-size letter-size))))
                       )
              )
;Stub:
;(define (game-over wrld) -1)
;Code:
(define (game-over wrld)
  (overlay; this overlaying the text on top the old world
   (text "GAME OVER" 80 "red");creating the game over text
   (draw-scene wrld);old world
   )
  )

;Purpose: when a letter on screen is typed, a random new letter appears
;Signature: World Key -> World
;Examples:
(check-expect (posn-y (World-position (key-handler start-world "D"))) 0)

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
  (cond
    ((char=?;comparing
      (World-letter wrld);letter on the screen
      (char-upcase (string-ref key 0));with the letter typed on the keyboard
      );if this condition is true
     (make-World;make a whole new world
      (random-letter);with a random letter
      (World-time wrld); the old timer of the world
      (make-posn; a whole new position
       (random-position);with a random horizontal position 
       0))) ;with the vertical position at the top of the screen
    (else wrld);otherwise output the old world, meaning nothing changes
    )
  )

;Purpose: create a randomized letter
;signature: -> character
(check-expect (char>=? (random-letter) #\A) #true)
(check-expect (char<=? (random-letter) #\Z) #true)
;Stub:
;(define (random-letter) 3)
;Code:
(define (random-letter)
  (vector-ref alphabet ;picking an element from alphabet
              (random (vector-length alphabet)) ;which the reference is a random number between 0 to 25
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

(big-bang (make-World #\D 0 (make-posn (/ screen-size 2) 0)) ;this is a world starting with "D" with position being in the midpoint of the screen and at the top of the screen
          (on-draw draw-scene) ;generates an image
          (on-tick tick-handler) ;animates the falling letters and timer
          (stop-when game-over? game-over) ;tells the animation when to stop
          (on-key key-handler) ;allows the user to use the keyboard
          )
