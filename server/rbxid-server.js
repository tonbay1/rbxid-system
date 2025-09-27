const http = require('http');
const https = require('https');
const fs = require('fs');
const path = require('path');
const crypto = require('crypto');
const url = require('url');

const PORT = process.env.PORT || 80; // Use environment PORT or default to 80 for public access
const DOMAIN = process.env.DOMAIN || 'rbxid.com';
const DATA_DIR = path.join(__dirname, 'rbxid_data');
const KEYS_FILE = path.join(__dirname, 'rbxid_keys.json');

// Ensure data directory exists
if (!fs.existsSync(DATA_DIR)) {
    fs.mkdirSync(DATA_DIR, { recursive: true });
    console.log('📁 Created data directory:', DATA_DIR);
}

// Initialize keys file
if (!fs.existsSync(KEYS_FILE)) {
    fs.writeFileSync(KEYS_FILE, JSON.stringify([], null, 2));
    console.log('🔑 Created keys file');
}

// ============================================================================
// UTILITY FUNCTIONS
// ============================================================================

function generateKey() {
    return crypto.randomUUID();
}

function readKeys() {
    try {
        const data = fs.readFileSync(KEYS_FILE, 'utf8');
        return JSON.parse(data);
    } catch (error) {
        console.error('❌ Error reading keys:', error);
        return [];
    }
}

function writeKeys(keys) {
    try {
        fs.writeFileSync(KEYS_FILE, JSON.stringify(keys, null, 2));
        return true;
    } catch (error) {
        console.error('❌ Error writing keys:', error);
        return false;
    }
}

function getKeyDataFile(key) {
    const sanitizedKey = key.replace(/[^a-zA-Z0-9-]/g, '_');
    return path.join(DATA_DIR, `${sanitizedKey}.json`);
}

function readKeyData(key) {
    try {
        const keyFile = getKeyDataFile(key);
        if (!fs.existsSync(keyFile)) {
            return [];
        }
        const data = fs.readFileSync(keyFile, 'utf8');
        const parsed = JSON.parse(data);
        return Array.isArray(parsed) ? parsed : [];
    } catch (error) {
        console.error(`❌ Error reading data for key ${key}:`, error);
        return [];
    }
}

function writeKeyData(key, data) {
    try {
        const keyFile = getKeyDataFile(key);
        const arrayData = Array.isArray(data) ? data : [data];
        fs.writeFileSync(keyFile, JSON.stringify(arrayData, null, 2));
        return true;
    } catch (error) {
        console.error(`❌ Error writing data for key ${key}:`, error);
        return false;
    }
}

function updatePlayerData(key, newEntry) {
    try {
        const existingData = readKeyData(key);
        const playerName = newEntry.playerName || newEntry.account;
        
        // Find existing player by name
        const existingIndex = existingData.findIndex(item => 
            (item.playerName === playerName) || (item.account === playerName)
        );
        
        // Add timestamp and online status
        newEntry.timestamp = new Date().toISOString();
        newEntry.lastSeen = Date.now();
        newEntry.online = true;
        
        if (existingIndex >= 0) {
            // Update existing player
            existingData[existingIndex] = { ...existingData[existingIndex], ...newEntry };
        } else {
            // Add new player
            existingData.push(newEntry);
        }
        
        return writeKeyData(key, existingData);
    } catch (error) {
        console.error(`❌ Error updating player data for key ${key}:`, error);
        return false;
    }
}

function updateOnlineStatus() {
    try {
        const keys = readKeys();
        const now = Date.now();
        const OFFLINE_THRESHOLD = 5 * 60 * 1000; // 5 minutes
        
        keys.forEach(keyRecord => {
            if (keyRecord.revoked) return;
            
            const keyData = readKeyData(keyRecord.key);
            let updated = false;
            
            keyData.forEach(player => {
                const lastSeen = player.lastSeen || 0;
                const wasOnline = player.online;
                const isOnline = (now - lastSeen) < OFFLINE_THRESHOLD;
                
                if (wasOnline !== isOnline) {
                    player.online = isOnline;
                    updated = true;
                    console.log(`🔄 ${player.playerName || player.account}: ${isOnline ? 'ONLINE' : 'OFFLINE'}`);
                }
            });
            
            if (updated) {
                writeKeyData(keyRecord.key, keyData);
            }
        });
    } catch (error) {
        console.error('❌ Error updating online status:', error);
    }
}

function isValidKey(key) {
    const keys = readKeys();
    const record = keys.find(k => k.key === key);
    return record && !record.revoked;
}

// ============================================================================
// OBFUSCATION FUNCTION
// ============================================================================

function obfuscateScript(script) {
    try {
        // Advanced Lua obfuscation
        let obfuscated = script;
        
        // Replace common patterns
        const replacements = {
            'game': '_G[string.char(103,97,109,101)]',
            'HttpGet': 'string.char(72,116,116,112,71,101,116)',
            'loadstring': '_G[string.char(108,111,97,100,115,116,114,105,110,103)]',
            'getgenv': '_G[string.char(103,101,116,103,101,110,118)]',
            'task': '_G[string.char(116,97,115,107)]',
            'spawn': 'string.char(115,112,97,119,110)'
        };
        
        // Apply string encoding
        for (const [original, encoded] of Object.entries(replacements)) {
            const regex = new RegExp(`\\b${original}\\b`, 'g');
            obfuscated = obfuscated.replace(regex, encoded);
        }
        
        // Add random variables and comments
        const randomVars = [];
        for (let i = 0; i < 5; i++) {
            const varName = `_${crypto.randomBytes(4).toString('hex')}`;
            const varValue = Math.random() * 1000;
            randomVars.push(`local ${varName} = ${varValue}`);
        }
        
        // Wrap in function with random name
        const funcName = `_${crypto.randomBytes(6).toString('hex')}`;
        
        return `-- Protected by RbxID Security System
-- Unauthorized access is prohibited
${randomVars.join('\n')}
local ${funcName} = function()
${obfuscated}
end
${funcName}()`;
        
    } catch (error) {
        console.error('❌ Obfuscation error:', error);
        return script;
    }
}

// ============================================================================
// HTTP SERVER
// ============================================================================

const server = http.createServer((req, res) => {
    // CORS headers
    res.setHeader('Access-Control-Allow-Origin', '*');
    res.setHeader('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS');
    res.setHeader('Access-Control-Allow-Headers', 'Content-Type, Authorization');
    
    if (req.method === 'OPTIONS') {
        res.writeHead(200);
        res.end();
        return;
    }
    
    const parsedUrl = url.parse(req.url, true);
    const pathname = parsedUrl.pathname;
    const query = parsedUrl.query;
    
    console.log(`📡 ${req.method} ${pathname}`);
    
    // ========================================================================
    // TELEMETRY DATA ENDPOINT
    // ========================================================================
    if (pathname === '/api/telemetry' && req.method === 'POST') {
        let body = '';
        req.on('data', chunk => {
            body += chunk.toString();
        });
        
        req.on('end', () => {
            try {
                const data = JSON.parse(body);
                const apiKey = data.key || data.apiKey || data.API_KEY;
                
                console.log('📡 Telemetry received:', {
                    key: apiKey ? (apiKey.substring(0, 8) + '...') : 'MISSING',
                    pc: data.PC || data.pcName || 'Unknown',
                    player: data.playerName || 'Unknown'
                });
                
                if (!apiKey) {
                    res.writeHead(400, { 'Content-Type': 'application/json' });
                    res.end(JSON.stringify({ success: false, error: 'API key required' }));
                    return;
                }
                
                if (!isValidKey(apiKey)) {
                    res.writeHead(401, { 'Content-Type': 'application/json' });
                    res.end(JSON.stringify({ success: false, error: 'Invalid API key' }));
                    return;
                }
                
                // Update player data
                const success = updatePlayerData(apiKey, {
                    ...data,
                    timestamp: new Date().toISOString(),
                    receivedAt: Date.now()
                });
                
                if (success) {
                    res.writeHead(200, { 'Content-Type': 'application/json' });
                    res.end(JSON.stringify({ success: true, message: 'Data received' }));
                } else {
                    res.writeHead(500, { 'Content-Type': 'application/json' });
                    res.end(JSON.stringify({ success: false, error: 'Failed to save data' }));
                }
                
            } catch (error) {
                console.error('❌ Telemetry error:', error);
                res.writeHead(400, { 'Content-Type': 'application/json' });
                res.end(JSON.stringify({ success: false, error: 'Invalid JSON' }));
            }
        });
        return;
    }
    
    // ========================================================================
    // SERVE GITHUB RAW URL REDIRECT
    // ========================================================================
    if (pathname === '/script' && req.method === 'GET') {
        // Redirect to GitHub raw URL for latest script
        const githubUrl = 'https://raw.githubusercontent.com/tonbay1/rbxid-system/main/client/rbxid_loader.lua';
        
        res.writeHead(302, { 
            'Location': githubUrl,
            'Content-Type': 'text/plain'
        });
        res.end(`-- Redirecting to GitHub: ${githubUrl}`);
        
        console.log(`🔗 Redirected to GitHub: ${githubUrl}`);
        return;
    }
    
    // ========================================================================
    // SERVE LOCAL OBFUSCATED SCRIPT (BACKUP)
    // ========================================================================
    if (pathname === '/script/local' && req.method === 'GET') {
        try {
            // Try rbxid_telemetry.lua first, then fallback to working_simple_telemetry.lua
            let scriptPath = path.join(__dirname, '..', 'client', 'rbxid_telemetry.lua');
            
            if (!fs.existsSync(scriptPath)) {
                scriptPath = path.join(__dirname, '..', 'client', 'working_simple_telemetry.lua');
            }
            
            if (!fs.existsSync(scriptPath)) {
                res.writeHead(404, { 'Content-Type': 'text/plain' });
                res.end('-- Script not found');
                return;
            }
            
            const content = fs.readFileSync(scriptPath, 'utf8');
            const obfuscatedContent = obfuscateScript(content);
            
            res.writeHead(200, { 'Content-Type': 'text/plain' });
            res.end(obfuscatedContent);
            
            console.log(`📜 Served obfuscated script: ${path.basename(scriptPath)}`);
            
        } catch (error) {
            console.error('❌ Script serve error:', error);
            res.writeHead(500, { 'Content-Type': 'text/plain' });
            res.end('-- Server error');
        }
        return;
    }
    
    // ========================================================================
    // RECEIVE TELEMETRY DATA
    // ========================================================================
    if (pathname === '/api/telemetry' && req.method === 'POST') {
        let body = '';
        req.on('data', chunk => {
            body += chunk.toString();
        });
        
        req.on('end', () => {
            try {
                const data = JSON.parse(body);
                const key = data.key;
                
                if (!key) {
                    res.writeHead(400, { 'Content-Type': 'application/json' });
                    res.end(JSON.stringify({ success: false, message: 'Missing key' }));
                    return;
                }
                
                if (!isValidKey(key)) {
                    res.writeHead(403, { 'Content-Type': 'application/json' });
                    res.end(JSON.stringify({ success: false, message: 'Invalid or revoked key' }));
                    return;
                }
                
                // Remove key from data before storing
                const playerData = { ...data };
                delete playerData.key;
                
                const success = updatePlayerData(key, playerData);
                
                if (success) {
                    res.writeHead(200, { 'Content-Type': 'application/json' });
                    res.end(JSON.stringify({ success: true, message: 'Data received' }));
                    console.log(`✅ Telemetry saved for ${playerData.playerName || playerData.account} (key: ${key})`);
                } else {
                    res.writeHead(500, { 'Content-Type': 'application/json' });
                    res.end(JSON.stringify({ success: false, message: 'Failed to save data' }));
                }
                
            } catch (error) {
                console.error('❌ Telemetry error:', error);
                res.writeHead(400, { 'Content-Type': 'application/json' });
                res.end(JSON.stringify({ success: false, message: 'Invalid JSON' }));
            }
        });
        return;
    }
    
    // ========================================================================
    // GET DATA BY KEY
    // ========================================================================
    if (pathname === '/api/data' && req.method === 'GET') {
        const key = query.key;
        
        if (!key) {
            res.writeHead(400, { 'Content-Type': 'application/json' });
            res.end(JSON.stringify({ error: 'Missing key parameter' }));
            return;
        }
        
        if (!isValidKey(key)) {
            res.writeHead(403, { 'Content-Type': 'application/json' });
            res.end(JSON.stringify({ error: 'Invalid or revoked key' }));
            return;
        }
        
        const keyData = readKeyData(key);
        
        res.writeHead(200, { 'Content-Type': 'application/json' });
        res.end(JSON.stringify({
            success: true,
            data: keyData,
            count: keyData.length,
            timestamp: new Date().toISOString()
        }));
        return;
    }
    
    // ========================================================================
    // KEY MANAGEMENT
    // ========================================================================
    if (pathname === '/api/keys' && req.method === 'POST') {
        let body = '';
        req.on('data', chunk => {
            body += chunk.toString();
        });
        
        req.on('end', () => {
            try {
                const requestData = JSON.parse(body || '{}');
                const description = requestData.description || `Key created at ${new Date().toLocaleString()}`;
                const machineName = requestData.machineName || requestData.machine || 'Unknown Machine';
                
                const newKey = generateKey();
                const keys = readKeys();
                
                const keyRecord = {
                    key: newKey,
                    createdAt: new Date().toISOString(),
                    revoked: false,
                    description: description,
                    machineName: machineName,
                    lastUsed: null,
                    totalPlayers: 0
                };
                
                keys.push(keyRecord);
                
                if (writeKeys(keys)) {
                    res.writeHead(200, { 'Content-Type': 'application/json' });
                    res.end(JSON.stringify({
                        success: true,
                        key: newKey,
                        machineName: machineName,
                        description: description,
                        message: 'Key created successfully'
                    }));
                    console.log(`🔑 New key created for ${machineName}: ${newKey}`);
                } else {
                    res.writeHead(500, { 'Content-Type': 'application/json' });
                    res.end(JSON.stringify({ error: 'Failed to create key' }));
                }
            } catch (error) {
                res.writeHead(400, { 'Content-Type': 'application/json' });
                res.end(JSON.stringify({ error: 'Invalid JSON data' }));
            }
        });
        return;
    }
    
    if (pathname === '/api/keys' && req.method === 'GET') {
        const keys = readKeys();
        res.writeHead(200, { 'Content-Type': 'application/json' });
        res.end(JSON.stringify({
            success: true,
            keys: keys.map(k => ({
                key: k.key,
                createdAt: k.createdAt,
                revoked: k.revoked,
                description: k.description
            }))
        }));
        return;
    }
    
    // ========================================================================
    // AUTO DEPLOY ENDPOINT
    // ========================================================================
    if (pathname === '/deploy' && req.method === 'POST') {
        const deployToken = 'rbxid-deploy-2024';
        
        let body = '';
        req.on('data', chunk => {
            body += chunk.toString();
        });
        
        req.on('end', () => {
            try {
                // Simple token validation
                if (!body.includes(deployToken)) {
                    res.writeHead(401, { 'Content-Type': 'application/json' });
                    res.end(JSON.stringify({ error: 'Invalid deploy token' }));
                    return;
                }
                
                // Restart server process
                console.log('🚀 Deploy triggered - restarting server...');
                
                res.writeHead(200, { 'Content-Type': 'application/json' });
                res.end(JSON.stringify({ 
                    message: 'Deploy successful', 
                    timestamp: new Date().toISOString() 
                }));
                
                // Restart after response
                setTimeout(() => {
                    process.exit(0);
                }, 1000);
                
            } catch (error) {
                res.writeHead(500, { 'Content-Type': 'application/json' });
                res.end(JSON.stringify({ error: 'Deploy failed' }));
            }
        });
        return;
    }
    
    // ========================================================================
    // SERVE REACT DASHBOARD
    // ========================================================================
    if (pathname === '/' && req.method === 'GET') {
        try {
            // Try to serve React build first
            const reactIndexPath = path.join(__dirname, '..', 'ui-react', 'dist', 'index.html');
            if (fs.existsSync(reactIndexPath)) {
                const content = fs.readFileSync(reactIndexPath, 'utf8');
                res.writeHead(200, { 'Content-Type': 'text/html' });
                res.end(content);
                return;
            }
            
            // Fallback JSON API response
            res.writeHead(200, { 'Content-Type': 'application/json' });
            res.end(JSON.stringify({
                name: 'RbxID Telemetry Server',
                version: '1.0.0',
                status: 'running',
                port: PORT,
                domain: DOMAIN,
                dashboard: `http://${DOMAIN}:${PORT}`,
                endpoints: {
                    health: '/health',
                    keys: '/api/keys',
                    data: '/api/data',
                    telemetry: '/api/telemetry',
                    script: '/script'
                }
            }));
        } catch (error) {
            console.error('❌ Error serving dashboard:', error);
            res.writeHead(500, { 'Content-Type': 'application/json' });
            res.end(JSON.stringify({
                error: 'Dashboard not available',
                port: PORT,
                domain: DOMAIN
            }));
        }
        return;
    }

// ========================================================================
// SERVE REACT STATIC FILES
// ========================================================================
if (req.method === 'GET') {
    const reactDistPath = path.join(__dirname, '..', 'ui-react', 'dist', pathname);
    if (fs.existsSync(reactDistPath) && fs.statSync(reactDistPath).isFile()) {
        const ext = path.extname(pathname);
        const contentTypes = {
            '.html': 'text/html',
            '.js': 'application/javascript',
            '.css': 'text/css',
            '.json': 'application/json',
            '.png': 'image/png',
            '.jpg': 'image/jpeg',
            '.gif': 'image/gif',
            '.svg': 'image/svg+xml',
            '.ico': 'image/x-icon'
        };
        
        const contentType = contentTypes[ext] || 'application/octet-stream';
        const content = fs.readFileSync(reactDistPath);
        
        res.writeHead(200, { 'Content-Type': contentType });
        res.end(content);
        return;
    }
}

// 404 Not Found
res.writeHead(404, { 'Content-Type': 'application/json' });
res.end(JSON.stringify({ error: 'Not found' }));
});

// ============================================================================
// START SERVER
// ============================================================================

server.listen(PORT, '0.0.0.0', () => {
    console.log(`🚀 RbxID Server running on port ${PORT}`);
    console.log(`🌐 Domain: ${DOMAIN}`);
    console.log(`📡 API Base: http://localhost:${PORT}`);
    
    // Create demo key if none exist
    const keys = readKeys();
    if (keys.length === 0) {
        const demoKey = generateKey();
        const demoRecord = {
            key: demoKey,
            createdAt: new Date().toISOString(),
            revoked: false,
            description: 'Demo key - created on startup'
        };
        keys.push(demoRecord);
        writeKeys(keys);
        
        console.log('\n🔑 Demo key created:');
        console.log(`   Key: ${demoKey}`);
        console.log(`   Script URL: https://${DOMAIN}/script`);
        console.log(`   Data URL: https://${DOMAIN}/api/data?key=${demoKey}`);
        console.log('\n📝 Usage example:');
        console.log(`getgenv().Shop888_Settings = {`);
        console.log(`    ['key'] = '${demoKey}',`);
        console.log(`    ['PC'] = 'CHANGE-ME',`);
        console.log(`}`);
        console.log(`task.spawn(function() loadstring(game:HttpGet('https://${DOMAIN}/script'))() end)`);
    }
    
    // Start online status checker
    setInterval(updateOnlineStatus, 30000); // Check every 30 seconds
    console.log('⏰ Online status checker started (30s interval)');
});

module.exports = server;
