const http = require('http');

const lessons = [
  { id: 1, title: 'Intro to Blockchain', content: 'Learn the basics of blockchain.' },
  { id: 2, title: 'Stacks 101', content: 'Learn about the Stacks ecosystem.' }
];

const quizzes = {
  1: { question: 'What is a blockchain?', answer: 'distributed ledger' },
  2: { question: 'What token does Stacks use?', answer: 'STX' }
};

const userProgress = {}; // memory store {userId: {lessonId: bool, tokens: number}}

const server = http.createServer((req, res) => {
  const url = new URL(req.url, `http://${req.headers.host}`);
  if (url.pathname === '/lessons') {
    res.writeHead(200, { 'Content-Type': 'application/json' });
    res.end(JSON.stringify(lessons));
    return;
  }
  const lessonMatch = url.pathname.match(/^\/lessons\/(\d+)$/);
  if (lessonMatch) {
    const lesson = lessons.find(l => l.id === parseInt(lessonMatch[1]));
    if (lesson) {
      res.writeHead(200, { 'Content-Type': 'application/json' });
      res.end(JSON.stringify(lesson));
    } else {
      res.writeHead(404);
      res.end('Lesson not found');
    }
    return;
  }
  const quizMatch = url.pathname.match(/^\/quizzes\/(\d+)\/submit$/);
  if (quizMatch && req.method === 'POST') {
    let body = '';
    req.on('data', chunk => (body += chunk.toString()));
    req.on('end', () => {
      const data = JSON.parse(body || '{}');
      const quiz = quizzes[quizMatch[1]];
      if (quiz && data.answer && data.answer.toLowerCase().includes(quiz.answer)) {
        const userId = data.user || 'anon';
        if (!userProgress[userId]) userProgress[userId] = { tokens: 0 };
        userProgress[userId].tokens += 1; // award 1 token (mock)
        res.writeHead(200, { 'Content-Type': 'application/json' });
        res.end(JSON.stringify({ result: 'correct', tokens: userProgress[userId].tokens }));
      } else {
        res.writeHead(200, { 'Content-Type': 'application/json' });
        res.end(JSON.stringify({ result: 'incorrect' }));
      }
    });
    return;
  }
  res.writeHead(404);
  res.end('Not Found');
});

const PORT = process.env.PORT || 3000;
server.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
