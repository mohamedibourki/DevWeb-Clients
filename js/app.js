const form = document.getElementById('clientForm');
const nameInput = document.getElementById('name');
const emailInput = document.getElementById('email');
const phoneInput = document.getElementById('phone');
const companyInput = document.getElementById('company');
const clientIdInput = document.getElementById('clientId');
const resetBtn = document.getElementById('resetBtn');
const tableBody = document.querySelector('#clientsTable tbody');

let currentEditId = null;

// Load clients on page load
document.addEventListener('DOMContentLoaded', loadClients);

form.addEventListener('submit', handleFormSubmit);
resetBtn.addEventListener('click', resetForm);

async function loadClients() {
    try {
        const response = await fetch('php/clients.php');
        const clients = await response.json();
        displayClients(clients);
    } catch (error) {
        console.error('Error loading clients:', error);
    }
}

function displayClients(clients) {
    tableBody.innerHTML = '';
    clients.forEach(client => {
        const row = document.createElement('tr');
        row.innerHTML = `
            <td>${client.name}</td>
            <td>${client.email}</td>
            <td>${client.phone}</td>
            <td>${client.company || '-'}</td>
            <td>
                <button class="edit-btn" onclick="editClient(${client.id})">Edit</button>
                <button class="delete-btn" onclick="deleteClient(${client.id})">Delete</button>
            </td>
        `;
        tableBody.appendChild(row);
    });
}

async function handleFormSubmit(e) {
    e.preventDefault();
    
    const clientData = {
        name: nameInput.value,
        email: emailInput.value,
        phone: phoneInput.value,
        company: companyInput.value
    };

    try {
        if (currentEditId) {
            clientData.id = currentEditId;
            await fetch('php/edit_client.php', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(clientData)
            });
        } else {
            await fetch('php/add_client.php', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(clientData)
            });
        }
        
        resetForm();
        loadClients();
    } catch (error) {
        console.error('Error saving client:', error);
    }
}

async function editClient(id) {
    try {
        const response = await fetch(`php/clients.php?id=${id}`);
        const client = await response.json();
        
        nameInput.value = client.name;
        emailInput.value = client.email;
        phoneInput.value = client.phone;
        companyInput.value = client.company || '';
        currentEditId = id;
        
        nameInput.focus();
    } catch (error) {
        console.error('Error loading client:', error);
    }
}

async function deleteClient(id) {
    if (!confirm('Are you sure you want to delete this client?')) return;
    
    try {
        await fetch('php/delete_client.php', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ id })
        });
        
        loadClients();
    } catch (error) {
        console.error('Error deleting client:', error);
    }
}

function resetForm() {
    form.reset();
    currentEditId = null;
}
