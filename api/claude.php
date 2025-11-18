<?php
// api/claude.php - Claude API Wrapper

class ClaudeAPI {
    private $apiKey;
    private $apiUrl = 'https://api.anthropic.com/v1/messages';
    
    public function __construct($apiKey) {
        $this->apiKey = $apiKey;
    }
    
    public function chat($message, $systemPrompt = null) {
        $data = [
            'model' => 'claude-sonnet-4-20250514',
            'max_tokens' => 2000,
            'messages' => [
                ['role' => 'user', 'content' => $message]
            ]
        ];
        
        if ($systemPrompt) {
            $data['system'] = $systemPrompt;
        }
        
        return $this->makeRequest($data);
    }
    
    private function makeRequest($data) {
        $ch = curl_init($this->apiUrl);
        
        curl_setopt_array($ch, [
            CURLOPT_RETURNTRANSFER => true,
            CURLOPT_POST => true,
            CURLOPT_POSTFIELDS => json_encode($data),
            CURLOPT_HTTPHEADER => [
                'Content-Type: application/json',
                'x-api-key: ' . $this->apiKey,
                'anthropic-version: 2023-06-01'
            ]
        ]);
        
        $response = curl_exec($ch);
        $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
        curl_close($ch);
        
        if ($httpCode !== 200) {
            return ['error' => 'API request failed', 'code' => $httpCode];
        }
        
        $result = json_decode($response, true);
        
        if (isset($result['content'][0]['text'])) {
            return ['success' => true, 'response' => $result['content'][0]['text']];
        }
        
        return ['error' => 'Invalid response format'];
    }
}
?>