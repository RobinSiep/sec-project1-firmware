local security = {}

security.syncCryptoDecrypt = function(message)
    -- uses 128 bit AES
    return crypto.decrypt("AES-CBC", "secretkey", message)
end

security.syncCryptoEncrypt = function(message)
    -- uses 128 bit AES
    return crypto.encrypt("AES-CBC", "secretkey", message)
end

security.verifyHMAC = function(hmac, message)
    verificationHMAC = crypto.hmac("sha512", message, "secretkey")
    if verificationHMAC  == hmac then
        return true
    end
    return false
end

return security