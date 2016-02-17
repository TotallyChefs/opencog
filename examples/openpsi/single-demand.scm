; Copyright (C) 2015 OpenCog Foundation
;
; Initial steps
; 1. ./opencog/cogserver/server/cogserver -c ../lib/development.conf
; 2. (add-to-load-path "/absolute/path/to/opencog/opencog")
; 3. (load "../examples/openpsi/single-demand.scm")

(use-modules (ice-9 format))

(load-from-path "openpsi/active-schema-pool.scm")

; --------------------------------------------------------------
; Start defining an OpenPsi-Demand called Energy
; Specify what kind of default behavior the demand should have, using one of
; the 3 options provided. You can define your own behavior.
(define energy-default-action  (psi-action-minimize 5))

; Associate the default behavior with your demand and set starting
; demand-value. Do this only once for each demand.
(define energy (psi-demand "Energy" .71 energy-default-action))

; Populate with some actions that affect the demand.
; * Add action for increasing the demand.
(psi-action-rule-maximize energy 10)

; * Add action for decreasing the demand.
; NOTE: The rate of minimization is different from the default one above. If
; you define with the same rate as the default one above a new one will not
; be added as a different effect type.
(psi-action-rule-minimize energy 6)

; Set the goal-selector to be used.
(psi-goal-selector-set! (psi-goal-selector-maximize .65))

(define (psi-example-step)
; NOTE: 1. This function is for simplifying runs.
;       2. The `display` and `format` commands are only used for presentation
;          purposes.

    (display "Start------------------------\n")
    ; Startup state
    (format #t "* Initial state of demands =\n~a\n" (psi-get-demands))
    (format #t "* Initial actions in asp =\n~a\n" (ure-rbs-rules (psi-asp)))
    (format #t "* Initial goal =\n~a\n" (psi-current-goal))

    ; Select goal randomly.
    ; NOTE: 1. You can define how goal should be selected. Remeber to set
    ;          conditions to return back to default.
    ;       2. The threshold is lower than the default  energy value defined above.
    (format #t "* Goal selection result =\n~a\n" (psi-select-random-goal))

    ; Select actions
    ; NOTE: You can define how actions should be selected. Just remember to
    ; define what happens when goal switches to default.
    (format #t "* Action selection result =\n~a\n" (psi-select-action-rules))

    ; The number and types of actions in the asp should have changed, depending
    ; on the state of the atomspace.
    (format #t "* Final actions in asp =\n~a\n"  (ure-rbs-rules (psi-asp)))

    ; Single step through the asp resulting in all the actions being run once.
    (format #t "* Result of steping through the asp =\n~a\n" (psi-step))
    (display "End------------------------\n")
)

; Running `(psi-example-step)` will result in switching between one goal-state
; to another. Observer the change in the strength of
; (ConceptNode "OpenPsi: Energy")
