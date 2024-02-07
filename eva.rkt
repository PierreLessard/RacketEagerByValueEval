#lang racket ; CSC324 — 2023W — Assignment 1 — Eva Implementation

; Task: implement eva according to A1.eva-test.rkt.

(provide (contract-out (eva (any/c . -> . any/c)))
         ; Add any a-helperper functions you tested in A1.eva-test.rkt.
         ; Whether you add contracts to them is optional.
         a-helper)

(define (eva term) 
    (match term
    [(list 'λ (list param) body) term]
    [(list (list 'λ (list param) body) term) (eva (a-helper body param term))]
    [(list fun term) (eva (list (eva fun) term))]
    [_ term]
    )
)

(define (a-helper body id term) 
    (match body 
        [(list (== id) res ...) (cons term (a-helper res id term))]
        [(list (list lst_items ..1) res ...) (cons (a-helper lst_items id term) (a-helper res id term))]
        [(list frst res ...) (cons frst (a-helper res id term))]
        ['() '()]
        [_ (if (equal? body id) term body)]
    )
)
