#lang web-server/insta
;#lang lang/htdp-advanced
;(require lang/htdp-advanced)

(define (get-name request)
  (if (exists-binding? 'name (request-bindings request))
      (extract-binding/single ; hash-ref
       'name ; key
       (request-bindings request) ; hashtable
       )
      "TOPICS"
      )
  )

(define (start request)
  (response/xexpr
   (list 'html
         (list 'head
               (list 'title "CISC 106 CLASS")
               )
         (list 'body  
               (list 'h1
                     (list
                      (list 'style "color:white; background:black")
                      (list 'id "top")
                      )
                     "MY FAVORITE TOPICS FROM THIS CLASS"
                     
                     )
               (list 'h1
                     (get-name request)
                     )
               (list 'li
                     (list 'a (list (list 'href "https://en.wikipedia.org/wiki/Algorithm")) "ALGORITHMS")
                     (list 'li
                     (list 'a (list (list 'href "https://en.wikipedia.org/wiki/Parametric_equation")) "PARAMETRIC EQUATIONS")
                     (list 'li
                     (list 'a (list (list 'href "https://ocw.mit.edu/courses/electrical-engineering-and-computer-science/6-001-structure-and-interpretation-of-computer-programs-spring-2005/video-lectures/2b-compound-data/")) "COMPOUND DATA")
                     (list 'li
                     (list 'a (list (list 'href "https://en.wikipedia.org/wiki/Encryption")) "ENCRYPTION")
                     (list 'li
                     (list 'a (list (list 'href "https://en.wikipedia.org/wiki/Enigma_machine")) "ENIGMA MACHINE")
                     (list 'li
                     (list 'a (list (list 'href "https://en.wikipedia.org/wiki/Hash_table")) "HASH TABLES")      
               (list 'p
                     "Algorithms are a series of step by step mathematical instructions designed to evaluate a problem and deliver a solution as quick
and efficiently as possible. They are used in almost every aspect of are daily lives. I believe algorithms are important because they have been a key
factor in the technological advancement of the human civilization. Algorithms can also be used to save lives such as the example of matching blood types
for people to receive organ transplants. "
                     )
                     (list 'p
         "Using Parametric equations in Dr Racket are a very precise way of moving a graphic object in an animation in any way you want.
 These equations represent the coordinates of the points that make up a geometric object and are another fundamental tool in designing an animation.
Using these equations have helped me better understand the concept of animations in Dr Racket. "
         )
                     (list 'p
         "Compound data is several pieces of data combined or linked to one single piece of data. An example of compound data would be your
social security number. Your social security number it is just one piece of data that contains other pieces of data such as your date of birth, address, and age.
 With the combination of data into one it allows you to better organize pieces of data.  "                                    
         )
                     (list 'p
         "Encryption is a way to disguise data or information by converting it into a secret code. Encryption has been an effective form of sending
 secret messages and has been used heavily since WWII. A basic example of encryption would be to replace the meaning of a single letter with another letter, for
 instance, instead of “A” meaning “A” it would in fact represent the letter “B”.  Over time encryption has become much more advance due to people learning to
 decrypt the code. One of the flaws of encryption was the spacing between encrypted words. Eventually people would catch on to the trends of how many characters
 would be in each word which would allow them to decrypt the messages. The invention of the enigma machine during WWII by the Nazi’s would change encryption and
 make it almost impossible to crack."                                    
         )
                     (list 'p
         "The Enigma machine invented by Nazi Germany during WWII was one of the most sophisticated and complicated ways of encrypting a message.
The machine had 3 elements that would increase the odds of decrypting a message. The three elements were the rotors which contained numbers that had to be in
a certain order, the letters and the plugboard. Eventually the Americans found a flaw in the enigma and was able to decrypt the messages being sent by the Nazi’s.
The flaw was that a letter could change to every letter in the alphabet, but it would never stay the same, so “K” would never be “K” in an encrypted message. "                                    
         )
                     (list 'p
         "Hash tables are a way of storing data and are considered to be two-dimensional since they use a key and a value. Once a hash table is created it can never
 be changed or altered and if you do want to change anything you would then need to create a new hash table. A hash function is a function which maps data to a data type.
Hash functions can also be used as the search functions in hash tables to quickly access where a certain value should be stored. An example of hash tables being used in
our daily lives is with internet searches, google uses hash tables as part of their search algorithms."                                    
         )
         
                     
               (list 'img
                     (list ; attributes
                      (list 'src "https://2static1.fjcdn.com/thumbnails/comments/Now+i+can+make+my+friends+custom+necklaces+_e0bb404804ed88d7eaf5dc1fdc62511b.jpg")
                      (list 'height "100")
                      ) ; ends attributes
                     )
               (list 'a
                     (list
                      (list 'href "#top")
                      )
                     "Back to top"
                     )))))))))))
               
                     

         

;-------------------------------------------------------------------------------------
;HIGH/LOW-GAME
;-------------------------------------------------------------------------------------

(define secret-number (+ 1 (random 100)))
(define (get-guess request)
  (if (exists-binding? 'guess (request-bindings request))
      (extract-binding/single ; hash-ref
       'guess ; key
       (request-bindings request) ; hashtable
       )
      "-1717"
      )
  )

; Purpose: given a number, return whether the number is too high, too low, or just right.
; Signature: number -> string
; Examples:
; (check-expect (get-message-for-number 101) "Too high.")
; (check-expect (get-message-for-number -1) "Too low.")

; Stub:
;(define (get-message-for-number num) -1)
; Template:
; (define (get-message-for-number num)
;   (cond
;     ((...) ...)
;     ((...) ...)
;     (else ...)
;     ))

; Code:
(define (get-message-for-number num)
  (cond
    ((= num secret-number) "Correct")
    ((> num secret-number) "Too high.")
    ((= -1717 num) "")
    (else "Too low.")
    ))

(define (start request)
  (response/xexpr
   (list 'html
         (list 'head
               (list 'title "High/Low Game"))
         (list 'body
               (list 'h1 "High/Low Game")
               (list 'p
                     "In order to play this game, you need to guess a number. If the guessed number is greater than the assigned number, it's high. If the number is less than the assigned number, it's low. Otherwise, you guessed correctly.")
               (list 'p
                     (get-message-for-number
                      (string->number
                       (get-guess request)
                       )
                      )
                     )
               (list 'form
                     (list 'input
                           (list
                            (list 'type "input")
                            (list 'name "guess")
                            )
                           )
                     
                     (list 'input
                           (list
                            (list 'type "submit")
                            )
                           )
                     )
               )
         )
   )
  )