// js/app.js - Frontend Logic

// Log Analyzer
document.getElementById('analyzeBtn').addEventListener('click', async () => {
    const logInput = document.getElementById('logInput').value.trim();
    const analyzeBtn = document.getElementById('analyzeBtn');
    const spinner = document.getElementById('analyzeSpinner');
    const resultDiv = document.getElementById('logResult');
    const resultContent = document.getElementById('logResultContent');

    if (!logInput) {
        alert('Please paste some log content first!');
        return;
    }

    // Show loading
    analyzeBtn.disabled = true;
    spinner.classList.remove('d-none');
    resultDiv.classList.add('d-none');

    try {
        const response = await fetch('/api/analyze-log.php', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ log: logInput })
        });

        const data = await response.json();

        if (data.error) {
            resultContent.innerHTML = `<div class="alert alert-danger">${data.error}</div>`;
        } else if (data.success) {
            resultContent.innerHTML = `<pre style="white-space: pre-wrap;">${data.response}</pre>`;
        }

        resultDiv.classList.remove('d-none');
    } catch (error) {
        resultContent.innerHTML = `<div class="alert alert-danger">Error: ${error.message}</div>`;
        resultDiv.classList.remove('d-none');
    } finally {
        analyzeBtn.disabled = false;
        spinner.classList.add('d-none');
    }
});

// Chat
const chatMessages = document.getElementById('chatMessages');
const chatInput = document.getElementById('chatInput');
const chatBtn = document.getElementById('chatBtn');
const chatSpinner = document.getElementById('chatSpinner');

async function sendMessage() {
    const question = chatInput.value.trim();
    
    if (!question) {
        alert('Please type a question!');
        return;
    }

    // Add user message
    addMessage(question, 'user');
    chatInput.value = '';

    // Show loading
    chatBtn.disabled = true;
    chatSpinner.classList.remove('d-none');

    try {
        const response = await fetch('/api/chat.php', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ question })
        });

        const data = await response.json();

        if (data.error) {
            addMessage(`Error: ${data.error}`, 'error');
        } else if (data.success) {
            addMessage(data.response, 'assistant');
        }
    } catch (error) {
        addMessage(`Error: ${error.message}`, 'error');
    } finally {
        chatBtn.disabled = false;
        chatSpinner.classList.add('d-none');
    }
}

function addMessage(text, type) {
    const messageDiv = document.createElement('div');
    messageDiv.className = `alert ${type === 'user' ? 'alert-primary' : type === 'error' ? 'alert-danger' : 'alert-success'} mb-2`;
    messageDiv.innerHTML = `<strong>${type === 'user' ? 'You' : type === 'error' ? 'Error' : 'Claude'}:</strong><br>${text.replace(/\n/g, '<br>')}`;
    chatMessages.appendChild(messageDiv);
    chatMessages.scrollTop = chatMessages.scrollHeight;
}

chatBtn.addEventListener('click', sendMessage);
chatInput.addEventListener('keypress', (e) => {
    if (e.key === 'Enter') sendMessage();
});