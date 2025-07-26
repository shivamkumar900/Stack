;; contracts/learntoearn.clar

(define-constant ERR-UNAUTHORIZED    (err u100))
(define-constant ERR-ALREADY-CLAIMED (err u101))
(define-constant ERR-NO-REWARD       (err u102))

;; Admin principal
(define-constant ADMIN tx-sender)

;; reward-table: (course-id, lesson-id, quiz-id) -> uint
(define-map reward-table
  { course-id: uint, lesson-id: uint, quiz-id: uint }
  uint)

;; has-claimed: (learner, course-id, lesson-id, quiz-id) -> bool
(define-map has-claimed
  { learner: principal, course-id: uint, lesson-id: uint, quiz-id: uint }
  bool)

;; Public helper: get reward amount
(define-read-only (get-reward (course-id uint) (lesson-id uint) (quiz-id uint))
  (match (map-get? reward-table { course-id: course-id, lesson-id: lesson-id, quiz-id: quiz-id })
    reward (ok reward)
    ERR-NO-REWARD))

;; Admin-only: set reward for a specific lesson/quiz
(define-public (set-reward (course-id uint) (lesson-id uint) (quiz-id uint) (amount uint))
  (begin
    (asserts! (is-eq tx-sender ADMIN) ERR-UNAUTHORIZED)
    (map-set reward-table
             { course-id: course-id, lesson-id: lesson-id, quiz-id: quiz-id }
             amount)
    (ok amount)))

;; Admin-only: withdraw STX
(define-public (withdraw-stx (amount uint) (recipient principal))
  (begin
    (asserts! (is-eq tx-sender ADMIN) ERR-UNAUTHORIZED)
    (stx-transfer? amount tx-sender recipient)))

;; Main entrypoint: learner claims their reward
(define-public (claim-reward (course-id uint) (lesson-id uint) (quiz-id uint))
  (let ((key { learner: tx-sender, course-id: course-id, lesson-id: lesson-id, quiz-id: quiz-id })
        (reward-amount (unwrap! (map-get? reward-table { course-id: course-id, lesson-id: lesson-id, quiz-id: quiz-id }) ERR-NO-REWARD)))
    (begin
      (asserts! (is-none (map-get? has-claimed key)) ERR-ALREADY-CLAIMED)
      (map-set has-claimed key true)
      (stx-transfer? reward-amount tx-sender ADMIN))))

;; Helper function to check if reward has been claimed
(define-read-only (has-user-claimed (learner principal) (course-id uint) (lesson-id uint) (quiz-id uint))
  (default-to false 
    (map-get? has-claimed { learner: learner, course-id: course-id, lesson-id: lesson-id, quiz-id: quiz-id })))