<?php
// api/chat.php - Infrastructure Q&A Chatbot

header('Content-Type: application/json');
require_once __DIR__ . '/claude.php';

$apiKey = getenv('CLAUDE_API_KEY') ?: $_ENV['CLAUDE_API_KEY'] ?? '';

if (empty($apiKey)) {
    echo json_encode(['error' => 'CLAUDE_API_KEY not configured']);
    exit;
}

$input = json_decode(file_get_contents('php://input'), true);
$question = $input['question'] ?? '';

if (empty($question)) {
    echo json_encode(['error' => 'No question provided']);
    exit;
}

$systemPrompt = "You are a DevOps and Infrastructure expert assistant. 
Focus on: Docker, Kubernetes, Azure, CI/CD, monitoring, security best practices.
Give practical, production-ready advice. Use simple language.
If you don't know something, say so clearly.";

$claude = new ClaudeAPI($apiKey);
$result = $claude->chat($question, $systemPrompt);

echo json_encode($result);
?>