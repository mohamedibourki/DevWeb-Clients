<?php
header('Content-Type: application/json');

$filePath = __DIR__ . '/../data/clients.json';
$data = file_get_contents($filePath);
$clients = json_decode($data, true) ?: [];

$input = json_decode(file_get_contents('php://input'), true);
$id = (int)$input['id'];

$clients = array_filter($clients, fn($c) => $c['id'] !== $id);

file_put_contents($filePath, json_encode(array_values($clients), JSON_PRETTY_PRINT));

echo json_encode(['success' => true]);
?>
