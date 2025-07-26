# 📚 Learn-to-Earn Clarity Contract

A secure, minimalist **Learn-to-Earn smart contract** on the Stacks blockchain, built with **Clarity** and tested via **Clarinet**. This contract allows platform admins to distribute STX rewards to learners who complete quizzes tied to specific lessons and courses.

---

## ✨ Features

- 🎓 **Claim-Based Rewards**: Users can claim STX rewards after completing course lessons and quizzes
- 🔐 **Admin-Controlled**: Only the admin (`tx-sender`) can configure or withdraw funds
- 💾 **Reward Tracking**: Persistent mapping of reward metadata and user claims
- ✅ **Claim Validation**: Ensures each user can claim only once per (course, lesson, quiz)
- 📊 **Read-only Reward Preview**: Anyone can view claim status or reward amount
- 🧪 **Fully Testable with Clarinet**

---

## 📁 Project Structure

```
learn-to-earn/
├── contracts/
│   └── learntoearn.clar         # Main Clarity contract
├── deployments/                 # Clarinet deployment configs
├── settings/                    # Clarinet devnet settings
├── tests/                       # Unit and integration tests
├── Clarinet.toml                # Project manifest
├── package.json                 # JS test env (if used)
├── tsconfig.json                # TypeScript config
├── vitest.config.js             # Test runner config
└── README.md                    # Project overview
```

---

## 🔐 Contract Logic

### 🔸 Maps

- `reward-table`: Maps (course-id, lesson-id, quiz-id) to reward amount
- `has-claimed`: Tracks whether a learner has claimed reward for a specific quiz

### 🔹 Key Functions

```clarity
(define-public (set-reward course-id lesson-id quiz-id amount))
```
> Admin sets reward for a quiz

```clarity
(define-public (claim-reward course-id lesson-id quiz-id))
```
> Learner claims reward if eligible and not yet claimed

```clarity
(define-read-only (get-reward course-id lesson-id quiz-id))
```
> Anyone can view reward amount

```clarity
(define-read-only (has-user-claimed learner course-id lesson-id quiz-id))
```
> Check if a learner has already claimed a reward

```clarity
(define-public (withdraw-stx amount recipient))
```
> Admin-only: withdraw unused STX

---

## 🧪 Testing

### 🔧 Prerequisite

Install Clarinet:  
👉 https://docs.hiro.so/clarinet/get-started/installation

### ✅ Run Tests

```bash
clarinet test
```

---

## 🚀 Deployment

Deploy using Clarinet CLI:

```bash
clarinet deploy learntoearn --network=devnet
```

---

## ⚠️ Errors & Constants

```clarity
ERR-UNAUTHORIZED     ;; Only ADMIN can execute
ERR-ALREADY-CLAIMED  ;; Reward already claimed by learner
ERR-NO-REWARD        ;; No reward set for the quiz
```

---

## 📄 License

MIT License — open to modification, forks, and enhancements.

---

## 🙏 Acknowledgements

- [Stacks Blockchain](https://www.stacks.co/)
- [Clarity Language](https://docs.stacks.co/docs/clarity-lang/)
- [Clarinet](https://github.com/hirosystems/clarinet)
# Stack
