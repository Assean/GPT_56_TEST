<?php
session_start();
require_once __DIR__ . '/db.php';
function json_response($success, $message = '', $data = [], $code = 200) {
    http_response_code($code);
    header('Content-Type: application/json; charset=utf-8');
    echo json_encode(['success'=>$success,'message'=>$message,'data'=>$data], JSON_UNESCAPED_UNICODE);
    exit;
}
function current_user_id() { return $_SESSION['uid'] ?? null; }
function require_login() { if (!current_user_id()) json_response(false, '尚未登入', [], 401); }
