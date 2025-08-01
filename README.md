# Learn-to-Earn Platform

This project is a simple prototype of a learn-to-earn platform where
users can complete lessons and quizzes to earn mock STX tokens.

## Usage

Run the server:

```bash
node server.js
```

Then visit `http://localhost:3000/lessons` to see available lessons.
Submit quiz answers by POSTing JSON to `/quizzes/<id>/submit` with fields
`user` and `answer`.

This prototype does not connect to the real Stacks blockchain. It simply
awards in-memory tokens for correct quiz answers.
