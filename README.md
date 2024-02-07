# Principles of Programming - Evaluators Project

This repository contains my work for the Principles of Programming course. The main task was to create three evaluators: `eva`, `eve`, and `evo`.

## Evaluators

### EVA
The EVA evaluator, implemented in [`eva.rkt`](command:_github.copilot.openRelativePath?%5B%22eva.rkt%22%5D "eva.rkt"), is the simplest of the three. It evaluates expressions in a basic arithmetic language.

### EVE
The EVE evaluator, implemented in [`eve.rkt`](command:_github.copilot.openRelativePath?%5B%22eve.rkt%22%5D "eve.rkt"), is a bit more complex. It evaluates expressions in a language that supports closures.

### EVO
The EVO evaluator, implemented in [`evo.rkt`](command:_github.copilot.openRelativePath?%5B%22evo.rkt%22%5D "evo.rkt"), is the most complex. It evaluates expressions in a language that supports setting values within mutable boxes.

## Running Tests

Each evaluator has its own test file: [`eva-test.rkt`](command:_github.copilot.openRelativePath?%5B%22eva-test.rkt%22%5D "eva-test.rkt"), [`eve-test.rkt`](command:_github.copilot.openRelativePath?%5B%22eve-test.rkt%22%5D "eve-test.rkt"), and [`evo-test.rkt`](command:_github.copilot.openRelativePath?%5B%22evo-test.rkt%22%5D "evo-test.rkt"). To run the tests for an evaluator, simply open the corresponding test file in your Racket environment and run it.

```sh
racket eva-test.rkt
racket eve-test.rkt
racket evo-test.rkt
```
