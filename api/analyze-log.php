<?php
// api/analyze-log.php - Log Analysis Endpoint

header('Content-Type: application/json');
require_once __DIR__ . '/claude.php';

// Get API key from environment
$apiKey = getenv('CLAUDE_API_KEY') ?: $_ENV['CLAUDE_API_KEY'] ?? '';

if (empty($apiKey)) {
    echo json_encode(['error' => 'CLAUDE_API_KEY not configured']);
    exit;
}

// Get log content from POST
$input = json_decode(file_get_contents('php://input'), true);
$logContent = $input['log'] ?? '';

if (empty($logContent)) {
    echo json_encode(['error' => 'No log content provided']);
    exit;
}

$systemPrompt = "You are a DevOps expert analyzing deployment and error logs. 
Provide:
1. Quick summary of the issue
2. Root cause analysis
3. Step-by-step solution
4. Prevention tips

Keep it practical and actionable. Use simple language.";

$userMessage = "Analyze this log and help me fix the issue:\n\n```\n" . $logContent . "\n```";

$claude = new ClaudeAPI($apiKey);
$result = $claude->chat($userMessage, $systemPrompt);

echo json_encode($result);
?>