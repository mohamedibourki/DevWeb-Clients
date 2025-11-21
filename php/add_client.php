<?php
header('Content-Type: application/json');

$filePath = __DIR__ . '/../data/clients.json';
$data = file_get_contents($filePath);
$clients = json_decode($data, true) ?: [];

$input = json_decode(file_get_contents('php://input'), true);

$newClient = [
    'id' => count($clients) > 0 ? max(array_column($clients, 'id')) + 1 : 1,
    'name' => $input['name'],
    'email' => $input['email'],
    'phone' => $input['phone'],
    'company' => $input['company'] ?? ''
];

$clients[] = $newClient;
file_put_contents($filePath, json_encode($clients, JSON_PRETTY_PRINT));

echo json_encode(['success' => true, 'client' => $newClient]);
?>
