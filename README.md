# Principles of Programming - Evaluators Project

This repository contains my work for the Principles of Programming course. The main task was to create three evaluators: `eva`, `eve`, and `evo`.

## Evaluators

### EVA
The EVA evaluator, implemented in [`A1.eva.rkt`](command:_github.copilot.openRelativePath?%5B%22A1.eva.rkt%22%5D "A1.eva.rkt"), is the simplest of the three. It evaluates expressions in a basic arithmetic language.

### EVE
The EVE evaluator, implemented in [`A1.eve.rkt`](command:_github.copilot.openRelativePath?%5B%22A1.eve.rkt%22%5D "A1.eve.rkt"), is a bit more complex. It evaluates expressions in a language that supports closures, allowing for functions to be first-class citizens.

### EVO
The EVO evaluator, implemented in [`A1.evo.rkt`](command:_github.copilot.openRelativePath?%5B%22A1.evo.rkt%22%5D "A1.evo.rkt"), is the most complex. It evaluates expressions in a language that supports object-oriented programming, including classes and inheritance.

## Running Tests

Each evaluator has its own test file: [`A1.eva-test.rkt`](command:_github.copilot.openRelativePath?%5B%22A1.eva-test.rkt%22%5D "A1.eva-test.rkt"), [`A1.eve-test.rkt`](command:_github.copilot.openRelativePath?%5B%22A1.eve-test.rkt%22%5D "A1.eve-test.rkt"), and [`A1.evo-test.rkt`](command:_github.copilot.openRelativePath?%5B%22A1.evo-test.rkt%22%5D "A1.evo-test.rkt"). To run the tests for an evaluator, simply open the corresponding test file in your Racket environment and run it.

```sh
racket A1.eva-test.rkt
racket A1.eve-test.rkt
racket A1.evo-test.rkt
```