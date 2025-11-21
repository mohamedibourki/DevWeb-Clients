<?php
header('Content-Type: application/json');

$filePath = __DIR__ . '/../data/clients.json';
$data = file_get_contents($filePath);
$clients = json_decode($data, true) ?: [];

if (isset($_GET['id'])) {
    $id = (int)$_GET['id'];
    $client = array_filter($clients, fn($c) => $c['id'] === $id);
    echo json_encode(array_values($client)[0] ?? null);
} else {
    echo json_encode($clients);
}
?>
