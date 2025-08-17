<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DevOps Assistant - Claude on Azure</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="css/custom.css">
</head>
<body>
    <nav class="navbar navbar-dark bg-dark">
        <div class="container">
            <span class="navbar-brand mb-0 h1">🤖 DevOps Assistant with Claude on Azure</span>
        </div>
    </nav>

    <div class="container mt-4">
        <div class="row">
            <div class="col-md-12">
                <ul class="nav nav-tabs" id="mainTab" role="tablist">
                    <li class="nav-item" role="presentation">
                        <button class="nav-link active" id="log-tab" data-bs-toggle="tab" data-bs-target="#log" type="button">
                            📋 Log Analyzer
                        </button>
                    </li>
                    <li class="nav-item" role="presentation">
                        <button class="nav-link" id="chat-tab" data-bs-toggle="tab" data-bs-target="#chat" type="button">
                            💬 Infrastructure Q & A
                        </button>
                    </li>
                </ul>

                <div class="tab-content mt-3" id="mainTabContent">
                    <!-- Log Analyzer Tab -->
                    <div class="tab-pane fade show active" id="log" role="tabpanel">
                        <div class="card">
                            <div class="card-body">
                                <h5 class="card-title">Paste your deployment or error logs</h5>
                                <textarea class="form-control" id="logInput" rows="10" placeholder="Paste your logs here..."></textarea>
                                <button class="btn btn-primary mt-3" id="analyzeBtn">
                                    <span id="analyzeSpinner" class="spinner-border spinner-border-sm d-none"></span>
                                    Analyze Log
                                </button>
                            </div>
                        </div>
                        <div id="logResult" class="mt-3 d-none">
                            <div class="card">
                                <div class="card-header bg-success text-white">
                                    <strong>Analysis Result</strong>
                                </div>
                                <div class="card-body" id="logResultContent"></div>
                            </div>
                        </div>
                    </div>

                    <!-- Chat Tab -->
                    <div class="tab-pane fade" id="chat" role="tabpanel">
                        <div class="card">
                            <div class="card-body">
                                <h5 class="card-title">Ask me anything about DevOps & Infrastructure</h5>
                                <div id="chatMessages" class="mb-3" style="min-height: 400px; max-height: 400px; overflow-y: auto; border: 1px solid #ddd; padding: 15px; border-radius: 5px;">
                                    <div class="alert alert-info">
                                        👋 Hi! I'm your DevOps assistant powered by Claude on Azure. Ask me about Docker, Kubernetes, CI/CD, monitoring, or any infrastructure questions!
                                    </div>
                                </div>
                                <div class="input-group">
                                    <input type="text" class="form-control" id="chatInput" placeholder="Ask your question...">
                                    <button class="btn btn-primary" id="chatBtn">
                                        <span id="chatSpinner" class="spinner-border spinner-border-sm d-none"></span>
                                        Send
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <footer class="mt-5 text-center text-muted">
            <p>Built with Claude API on Azure | <a href="https://github.com/mesuttunga/DevOps-Assistant-with-Claude-on-Azure" target="_blank">GitHub</a></p>
        </footer>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="js/app.js"></script>
</body>
</html>
