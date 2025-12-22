import os from 'node:os'
import * as fs from 'node:fs/promises'
import * as path from 'node:path'
import { execSync } from 'child_process'

import dotenv from 'dotenv'

dotenv.config({ quiet: true })

const {
    CF_INTERVAL = 10,
    APP_VERSION = 'unknown',
    TZ,
    CF_API_TOKEN,
    CF_ZONE_ID,
    CF_DOMAIN,
    CF_RECORD_TYPE = 'A',
    CF_TTL = 300,
    CF_PROXIED = 'false',
    STATE_DIR = '/data',
} = process.env

const execute = async () => {
    const time = timestamp()
    console.log(`${time} 🚀 Cloudflare DDNS version ${APP_VERSION} running on ${os.arch()} (TZ=${TZ})`)

    const hasPersistence = await pathExists(STATE_DIR)

    if (!hasPersistence) {
        console.log(`${time} ⚠️ ${STATE_DIR} does not exist`)
    } else if (!isMountPoint(STATE_DIR)) {
        console.log(`${time} ⚠️ ${STATE_DIR} exists but is not a mounted volume`)
    } else {
        console.log(`${time} ✅ Persistence enabled: ${STATE_DIR}`)
    }

    setInterval(async () => {
        await updateDNSRecord()
    }, CF_INTERVAL * 1000)

    await updateDNSRecord()
}

function timestamp() {
    return new Date().toISOString().replace('T', ' ').split('.')[0]
}

async function pathExists(path) {
    try {
        await fs.access(path)
        return true
    } catch {
        return false
    }
}

function isMountPoint(path) {
    try {
        execSync(`mountpoint -q ${path}`)
        return true
    } catch {
        return false
    }
}

const updateDNSRecord = async () => {
    console.log(`${timestamp()} 🌐 Updating DNS record for ${CF_DOMAIN}`)

    try {
        const publicIP = await tryToGetPublicIP()
        console.log(`${timestamp()} 🔍 Current public IP address: ${publicIP}`)

        const lastKnownIP = await tryToGetLastKnownIP()

        if (publicIP === lastKnownIP) {
            console.log(`${timestamp()} ℹ️  Public IP has not changed. No update needed.`)
            return
        }

        await tryToUpdateDNSRecord(publicIP)

        console.log(`${timestamp()} ✏️  Public IP has changed (${lastKnownIP} -> ${publicIP}). Updating DNS record.`)
    } catch (error) {
        console.error(`${timestamp()} ❌ Aborting DNS update due to error`)
        console.error(error)
    }
}

const tryToGetPublicIP = async () => {
    try {
        const response = await fetch('https://api.ipify.org?format=json')
        if (!response.ok) {
            throw new Error(`HTTP error! status: ${response.status}`)
        }

        const data = await response.json()
        return data.ip
    } catch (error) {
        console.error(`${timestamp()} ❌ Failed to get public IP address`)
    }
}

const tryToGetLastKnownIP = async () => {
    try {
        const filePath = path.join(STATE_DIR, 'last_ip')
        const data = await fs.readFile(filePath, 'utf8')
        return data.trim()
    } catch (error) {
        if (error.code !== 'ENOENT') {
            console.warn(`${timestamp()} ❌ Failed to read last known IP address`)
            throw error
        }

        console.error(`${timestamp()} ℹ️  No last known IP address found`)
    }
}

/** * @returns {Promise<string>} */
const tryToGetDNSRecordID = async () => {
    try {
        const filePath = path.join(STATE_DIR, 'dns_record_id')
        const data = await fs.readFile(filePath, 'utf8')
        const dnsRecordId = data.trim()
        if (dnsRecordId) return dnsRecordId
    } catch (error) {
        if (error.code !== 'ENOENT') {
            console.warn(`${timestamp()} ❌ Failed to read DNS record ID from state file`)
            throw error
        }

        console.error(`${timestamp()} ℹ️  No DNS record ID found in state file`)
    }

    try {
        const url = `https://api.cloudflare.com/client/v4/zones/${CF_ZONE_ID}/dns_records?name=${CF_DOMAIN}`
        const response = await fetch(url, {
            method: 'GET',
            headers: {
                'Content-Type': 'application/json',
                Authorization: `Bearer ${CF_API_TOKEN}`,
            },
        })

        if (!response.ok) {
            throw new Error(`HTTP error! status: ${response.status}`)
        }

        const data = await response.json()
        const dnsRecordId = data.result[0].id

        try {
            const filePath = path.join(STATE_DIR, 'dns_record_id')
            await fs.writeFile(filePath, dnsRecordId, 'utf8')
        } catch (error) {
            console.error(`${timestamp()} ❌ Failed to write DNS record ID to state file`)
        }

        return dnsRecordId
    } catch (error) {
        console.error(`${timestamp()} ❌ Failed to get DNS record ID from Cloudflare`)
        throw error
    }
}

const tryToUpdateDNSRecord = async (publicIP) => {
    const dnsRecordId = await tryToGetDNSRecordID()

    try {
        const url = `https://api.cloudflare.com/client/v4/zones/${CF_ZONE_ID}/dns_records/${dnsRecordId}`

        const response = await fetch(url, {
            method: 'PATCH',
            headers: {
                'Content-Type': 'application/json',
                Authorization: `Bearer ${CF_API_TOKEN}`,
            },
            body: JSON.stringify({
                type: CF_RECORD_TYPE,
                name: CF_DOMAIN,
                content: publicIP,
                ttl: parseInt(CF_TTL),
                proxied: CF_PROXIED === 'true',
            }),
        })

        if (!response.ok) {
            throw new Error(`HTTP error! status: ${response.status}`)
        }

        const data = await response.json()
        if (!data.success) {
            throw new Error(`Cloudflare API error: ${JSON.stringify(data.errors)}`)
        }

        console.log(`${timestamp()} ✅ DNS record updated successfully`)

        try {
            const filePath = path.join(STATE_DIR, 'last_ip')
            await fs.writeFile(filePath, publicIP, 'utf8')
        } catch (error) {
            console.error(`${timestamp()} ❌ Failed to write last known IP address to state file`)
        }
    } catch (error) {
        console.error(`${timestamp()} ❌ Failed to update DNS record on Cloudflare`)
        throw error
    }
}

execute()
