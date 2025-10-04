const express = require("express");
const bodyParser = require("body-parser");
const cors = require("cors");
const fs = require("fs");
const path = require("path");
const { v4: uuidv4 } = require("uuid");

const app = express();
app.use(cors());
app.use(bodyParser.json());

// File paths for persistence
const DATA_DIR = path.join(__dirname, "data");
const BALANCE_FILE = path.join(DATA_DIR, "balance.json");
const TRANSACTIONS_FILE = path.join(DATA_DIR, "transactions.json");

// Ensure data directory exists
if (!fs.existsSync(DATA_DIR)) {
  fs.mkdirSync(DATA_DIR);
}

// Load data from files or initialize
let balance = {};
let transactions = {};

function loadData() {
  try {
    if (fs.existsSync(BALANCE_FILE)) {
      balance = JSON.parse(fs.readFileSync(BALANCE_FILE, "utf8"));
    } else {
      balance = { user_1: 1000 };
      saveBalance();
    }

    if (fs.existsSync(TRANSACTIONS_FILE)) {
      transactions = JSON.parse(fs.readFileSync(TRANSACTIONS_FILE, "utf8"));
    } else {
      transactions = {};
      saveTransactions();
    }

    console.log("✅ Data loaded successfully");
    console.log(`📊 Total transactions: ${Object.keys(transactions).length}`);
  } catch (error) {
    console.error("❌ Error loading data:", error);
    balance = { user_1: 1000 };
    transactions = {};
  }
}

function saveBalance() {
  try {
    fs.writeFileSync(BALANCE_FILE, JSON.stringify(balance, null, 2));
  } catch (error) {
    console.error("❌ Error saving balance:", error);
  }
}

function saveTransactions() {
  try {
    fs.writeFileSync(TRANSACTIONS_FILE, JSON.stringify(transactions, null, 2));
  } catch (error) {
    console.error("❌ Error saving transactions:", error);
  }
}

// Load data on startup
loadData();

// Get available providers
app.get("/providers", (req, res) => {
  res.json({ providers: ["mtn", "airtel", "glo", "9mobile"] });
});

// Get balance by userId
app.get("/balance", (req, res) => {
  const { userId } = req.query;
  res.json({ balanceNGN: balance[userId] || 0 });
});

// Sell airtime
app.post("/sell", (req, res) => {
  const { userId, network, phone, amount } = req.body;
  const id = uuidv4();
  const createdAt = new Date().toISOString();

  const transaction = {
    id,
    userId,
    network,
    phone,
    amount: Number(amount),
    cashAmount: Number(amount) * 0.85, // 85% conversion rate
    status: "pending",
    createdAt,
    type: "received"
  };

  transactions[id] = transaction;
  balance[userId] = (balance[userId] || 0) + transaction.cashAmount;

  // Save immediately
  saveTransactions();
  saveBalance();

  // Simulate processing delay
  setTimeout(() => {
    transactions[id].status = "completed";
    transactions[id].completedAt = new Date().toISOString();
    saveTransactions();
    console.log(`✅ Transaction ${id} completed`);
  }, 5000);

  res.json({ success: true, transaction: transactions[id] });
});

// Get single transaction by id
app.get("/transactions/:id", (req, res) => {
  const tx = transactions[req.params.id];
  if (!tx) return res.status(404).json({ error: "Not found" });
  res.json({ transaction: tx });
});

// Get all transactions for a user
app.get("/transactions", (req, res) => {
  const { userId } = req.query;
  
  if (!userId) {
    return res.status(400).json({ error: "userId is required" });
  }

  const userTransactions = Object.values(transactions)
    .filter(tx => tx.userId === userId)
    .sort((a, b) => new Date(b.createdAt) - new Date(a.createdAt));

  res.json({ transactions: userTransactions });
});
// Get all transactions for a user
app.get("/transactions", (req, res) => {
  const { userId } = req.query;
  
  if (!userId) {
    return res.status(400).json({ error: "userId is required" });
  }

  const userTransactions = Object.values(transactions)
    .filter(tx => tx.userId === userId)
    .sort((a, b) => new Date(b.createdAt) - new Date(a.createdAt)); // Latest first

  res.json({ transactions: userTransactions });
});

// Clear all data (for testing)
app.delete("/reset", (req, res) => {
  balance = { user_1: 1000 };
  transactions = {};
  saveBalance();
  saveTransactions();
  res.json({ success: true, message: "Data reset successfully" });
});

const PORT = 4000;
app.listen(PORT, "0.0.0.0", () => {
  console.log(`🚀 Airtime API running on http://localhost:${PORT}`);
  console.log(`💾 Data persisted in: ${DATA_DIR}`);
});