<?php
header('Content-Type: application/json');
echo json_encode(['status' => 'OK', 'timestamp' => date('c')]);
