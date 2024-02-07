#lang racket ; CSC324 — 2023W — Assignment 1 — Evo Implementation

; Task: implement evo according to A1.evo-test.rkt.

(provide
 (contract-out (evo (any/c . -> . (list/c any/c (hash/c symbol? list?)))))
 ; Add any helper functions you tested in A1.evo-test.rkt.
 ; Whether you add contracts to them is optional.
 #;a-helper)

; · Support: indexer and Void

(provide (contract-out (indexer (any/c . -> . (-> symbol?)))))

(define (indexer prefix)
  (define last-index -1)
  (λ ()
    (local-require (only-in racket/syntax format-symbol))
    (set! last-index (add1 last-index))
    (format-symbol "~a~a" prefix last-index)))

; There is no literal nor variable for the void value (although it has a printed
; representation when printed inside compound values), so we'll name it here and
; and also export it for testing.

(provide (contract-out (Void void?)))

(define Void (void))

; · evo

; Produce a two-element list with the value and the environment-closure table
; from evaluating an LCO term.
(define (evo term)

  ; A mutable table of environments and closures.
  (define environments-closures (make-hash))
  
  ; Iterators to produce indices for environments and closures.
  (define En (indexer 'E))
  (define λn (indexer 'λ))

  (define global-env 'E0)
  (En)

  ; Search environment
  (define (lookup lit E)
    (cond 
      [(equal? E 'E0) lit]
      [(equal? (first (first (hash-ref environments-closures E))) lit)
        (unbox (second (first (hash-ref environments-closures E))))
      ]
      [else (lookup lit (second (hash-ref environments-closures E)))]
    )
  )

  ; evaluate a lambda with inp
  (define (evalu lamb inp E) (
    let ((fun (first (hash-ref environments-closures lamb))) (Ec (En)))
    (match fun 
      [ (list 'λ (list <param>) <body>)
        (hash-set! environments-closures Ec (list (list <param> (box inp)) global-env))
        (set! global-env Ec)
        (rec <body> global-env)
      ]
    ) 
  ))

  ; set an already set variable to a value
  (define (evoSet param val E)
    (cond 
      [(equal? (first (first (hash-ref environments-closures E))) param)
        (hash-set! environments-closures E
          (list (list param (box val)) (second (hash-ref environments-closures E)))
        )
        Void
      ]
      [else (evoSet param val (second (hash-ref environments-closures E)))]
    )
  )

  ; recursively evaluate a term
  (define (rec t E) 
    (match t
    [(list 'λ (list <param>) <body>) (
      let ((λc (λn)))
        (hash-set! environments-closures λc (list t global-env))
        λc
      
    )]

    [(list 'set! <param> <val>) 
      (evoSet <param> (rec <val> E) global-env)
    ]

    [(list <fun> <attr>)  (
      if (not (procedure? <fun>))
        (let* ((efun (rec <fun> global-env)) (eattr (rec <attr> global-env)))
          (evalu efun eattr global-env))
        (<fun> (rec <attr> E))
    )
    ]

    [literal (
      lookup literal E
    )]
    )
  )
  
  (list (rec term global-env)
        (make-immutable-hash (hash->list environments-closures))))
