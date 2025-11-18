# 🤖 DevOps Assistant - Claude on Azure

AI-powered DevOps assistant that analyzes deployment logs and answers infrastructure questions using Claude API on Azure Container Apps.

## ✨ Features

- **Log Analyzer**: Paste your deployment or error logs, get instant analysis with root cause and solutions
- **Infrastructure Q&A**: Ask questions about Docker, Kubernetes, Azure, CI/CD, monitoring, and more
- **Powered by Claude Sonnet 4**: Latest AI model from Anthropic
- **Deployed on Azure**: Running on Azure Container Apps

## 🚀 Quick Start

### Local Development

1. **Clone the repo**
```bash
git clone https://github.com/mesuttunga/devops-assistant.git
cd devops-assistant
```

2. **Set up environment**
```bash
cp .env.example .env
# Edit .env and add your CLAUDE_API_KEY
```

3. **Run with Docker**
```bash
docker-compose up -d
```

4. **Open browser**
```
http://localhost:8080
```

### Deploy to Azure

1. **Make sure you have Azure CLI installed**
```bash
az --version
```

2. **Set your Claude API key**
```bash
export CLAUDE_API_KEY="your_api_key_here"
```

3. **Run deployment script**
```bash
chmod +x azure-deploy.sh
./azure-deploy.sh
```

4. **Done!** Your app will be live in ~5 minutes

## 🛠️ Tech Stack

- **Backend**: PHP 8.2
- **Frontend**: Vanilla JavaScript + Bootstrap 5
- **AI**: Claude API (Sonnet 4)
- **Cloud**: Azure Container Apps
- **Container**: Docker

## 📸 Screenshots

[Add screenshots here]

## 🧪 Example Use Cases

### Log Analysis
```
Paste a failed deployment log
→ Get root cause analysis
→ Get step-by-step fix
→ Get prevention tips
```

### Infrastructure Q&A
```
Q: "How do I optimize my Docker image size?"
Q: "What's the best way to implement blue-green deployment?"
Q: "Help me debug this Kubernetes pod crash"
```

## 🔐 Security

- API keys stored as Azure secrets
- No logs stored permanently
- HTTPS only in production

## 📝 License

MIT

## 👤 Author

**Mesut Tunga**
- Email: mesut@tunga.com
- LinkedIn: https://www.linkedin.com/in/mesuttunga/
- GitHub: @mesuttunga

---

Built with ❤️ to demonstrate Claude + Azure integration