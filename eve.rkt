#lang racket ; CSC324 — 2023W — Assignment 1 — Eve Implementation

; Task: implement eve according to A1.eve-test.rkt.

(provide
 (contract-out (eve (any/c . -> . (list/c any/c (hash/c symbol? list?)))))
 ; Add any helper functions you tested in A1.eva-test.rkt.
 ; Whether you add contracts to them is optional.
)

; · Support: indexer

; A constructor for a zero-arity function that when called successively
; produces symbols of the form prefix0 prefix1 prefix2 etc.

(provide (contract-out (indexer (any/c . -> . (-> symbol?)))))

(define (indexer prefix)
  (define last-index -1)
  (λ ()
    (local-require (only-in racket/syntax format-symbol))
    (set! last-index (add1 last-index))
    (format-symbol "~a~a" prefix last-index)))

; · eve

; Produce a two-element list with the value and the environment-closure table
; from evaluating an LCE term.

(define (eve term)
  (define environments-closures (make-hash))
  (define En (indexer 'E))
  (define λn (indexer 'λ))
  (define global-env 'E0)
  (En)

  ; Search environment
  (define (lookup lit E)
    (cond 
      [(equal? E 'E0) lit]
      [(equal? (first (first (hash-ref environments-closures E))) lit)
        (second (first (hash-ref environments-closures E)))
      ]
      [else (lookup lit (second (hash-ref environments-closures E)))]
    )
  )

  ; evaluate a lambda with inp
  (define (evalu lamb inp E) (
    let ((fun (first (hash-ref environments-closures lamb))) (Ec (En)))
    (match fun 
      [ (list 'λ (list <param>) <body>)
        (hash-set! environments-closures Ec (list (list <param> inp) global-env))
        (set! global-env Ec)
        (rec <body> global-env)
      ]
    ) 
  ))

  ; recursively evaluate a term
  (define (rec t E) 
    (match t
    [(list 'λ (list <param>) <body>) (
      let ((λc (λn)))
        (hash-set! environments-closures λc (list t global-env))
        λc
      
    )]

    [(list <fun> <attr>) (
      let* ((efun (rec <fun> global-env)) (eattr (rec <attr> global-env)))
        (evalu efun eattr global-env)
      )
    ]

    [literal (
      lookup literal E
    )]
    )
  )

  (list (rec term global-env)
        (make-immutable-hash (hash->list environments-closures)))
)
