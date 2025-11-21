<?php
class ClientManager
{
    private $filePath;

    public function __construct()
    {
        $this->filePath = __DIR__ . '/../data/clients.json';
    }

    public function getClients()
    {
        return json_decode(file_get_contents($this->filePath), true) ?: [];
    }

    public function getClientById($id)
    {
        $clients = $this->getClients();
        return array_values(array_filter($clients, fn($c) => $c['id'] === (int)$id))[0] ?? null;
    }

    public function saveClients($clients)
    {
        file_put_contents($this->filePath, json_encode($clients, JSON_PRETTY_PRINT));
    }
}
