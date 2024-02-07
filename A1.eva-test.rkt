#lang racket ; CSC324 — 2023W — Assignment 1 - Eva Design and Testing

; • Eva: Eager By-Value Algebraic Evaluator for an Extended Lambda Calculus

; Task: understand the syntax and semantics of the language LCA described below,
; then create a good test suite for an evaluator of LCA named eva which you will
; then implement in A1.eva.rkt

(require "A1.eva.rkt"
         rackunit)

; · Syntax of LCA

; The grammar of “terms” [along with how we'll refer to them] in LCA is:
;   term = (λ (<parameter-identifier>) <body-term>)  [“λ term”]
;        | (<function-term> <argument-term>)  [“function call term”]
;        | <identifier>  [“variable term”]
;        | <literal>  [“literal term”]

; A term where each variable term <id> occurs inside some enclosing λ term
; whose parameter is <id> is called “closed”, otherwise it's called “open”.
; In particular, identifier terms are open and literal terms are closed.

; We will refer to literal terms and closed λ terms (closures) as “values”.

; Parenthesized terms are represented by lists.
; Identifiers (including "λ") are represented by symbols.
; Literals are, and represented by, values that are not lists nor symbols.

; For example, the following represents a (syntactically) valid term in LCA,
; and contains one instance of each production:
#;'(324 (λ (y) y))
; It contains two values:
#;(λ (y) y)
#;324

; · Semantics of LCA

; Assume that the evaluator is only asked to evaluate closed terms that are
; semantically valid (satisfy the evaluation assumptions mentioned below).
; This ends up guaranteeing that the recursive evaluation described below
; only produces values (exercise: prove this by structural induction).

; Evaluation of a value is just the value itself.

; Evaluation of function call is eager algebraic substitution of argument value.
; More precisely, evaluation of (<function-term> <argument-term>) is:
;   1. Evaluate <function-term>.
;      Evaluation Assumption: the evaluation is not an infinite recursion
;      and the result is a closed λ term (λ (<id>) <body>).
;   2. Evaluate <argument-term> to produce a value v.
;      Evaluation Assumption: the evaluation is not an infinite recursion.
;   3. Substitute occurrences of variable term <id> in <body> with v.
;      Substitution respects scope: if <body> contains a λ term whose parameter
;      is also <id> it does not replace <id> inside that λ term.
;   4. Produce the evaluation of the transformed body.

; · Design and Testing

; Create a good test suite for eva, with a comment above each test case giving
; a clear rationale for its inclusion. We have provided you with 8 test cases
; to help start the test suite and the implementation. 

; Also include test cases for any significant helper functions you create
; (e.g. a recursive function is likely to be significant) to aid debugging, and
; export those helper functions from A1.eva.rkt so they can be referenced here.

; A literal term.
(check-equal? (eva 324) 324)
(check-equal? (eva 'eva) 'eva)
(check-equal? (eva '(λ (x) x)) '(λ (x) x))
; Call literal λ having literal body, with literal argument.
(check-equal? (eva '((λ (x) 324) 325)) 324)
; Call literal λ with body substitution to literal.
(check-equal? (eva '((λ (x) x) 324)) 324)
; Call literal λ with body requiring evaluation.
(check-equal? (eva '((λ (x) ((λ (y) 325) x)) 324)) 325)
(check-equal? (eva '((λ (y) 325) 324)) 325)
(check-equal? (eva '((λ (y) y) 324)) 324)
(check-equal? (eva '((λ (y) (λ (x) 324)) 325)) '(λ (x) 324))
(check-equal? (eva '((λ (x) x) ((λ (x) 325) 324))) 325)
(check-equal? (eva '((λ (x) (x x)) (λ (y) 324))) 324)
; Call eva with more complicated expression.
(check-equal? (eva '((λ (y) ((λ (x) x) y)) 325)) 325)

; Test case 1: Test evaluating a literal term
(check-equal? (eva 42) 42)
; This test case checks if the evaluator correctly evaluates a literal term to the value itself.

; Test case 2: Test evaluating a function call term with a literal argument
(check-equal? (eva '((λ (x) x) 2)) 2)
; This test case checks if the evaluator correctly evaluates a function call term with a literal argument.

; Test case 3: Test evaluating a function call term with a closure argument
(check-equal? (eva '((λ (f) (f 2)) (λ (x) x))) 2)
; This test case checks if the evaluator correctly evaluates a function call term with a closure argument.

; Test case 4: Test evaluating a nested function call term
(check-equal? (eva '((λ (x) ((λ (y) x) 2)) 1)) 1)
; This test case checks if the evaluator correctly evaluates a nested function call term.

; Test case 5: Test evaluating a closure term
(check-equal? (eva '(λ (x) 1)) '(λ (x) 1))
; This test case checks if the evaluator correctly evaluates a closure term to itself.

; Test case 6: Test evaluating a variable term
(check-equal? (eva 'x) 'x)
; This test case checks if the evaluator correctly evaluates a variable term to itself.


; Test helper function hel:
(check-equal? (a-helper 'x 'x 1) 1)
