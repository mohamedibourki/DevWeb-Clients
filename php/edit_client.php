<?php
header('Content-Type: application/json');

$filePath = __DIR__ . '/../data/clients.json';
$data = file_get_contents($filePath);
$clients = json_decode($data, true) ?: [];

$input = json_decode(file_get_contents('php://input'), true);
$id = (int)$input['id'];

foreach ($clients as &$client) {
    if ($client['id'] === $id) {
        $client['name'] = $input['name'];
        $client['email'] = $input['email'];
        $client['phone'] = $input['phone'];
        $client['company'] = $input['company'] ?? '';
        break;
    }
}

file_put_contents($filePath, json_encode($clients, JSON_PRETTY_PRINT));

echo json_encode(['success' => true]);
?>
