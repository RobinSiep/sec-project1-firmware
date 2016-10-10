local security = {}

security.syncCryptoDecrypt = function(message)
    -- uses 128 bit AES
    return crypto.decrypt("AES-CBC", "1234567890abcdef", message)
end

security.syncCryptoEncrypt = function(message)
    -- uses 128 bit AES
    return crypto.encrypt("AES-CBC", "Yx9SqhHca9aeuD+hqCNjAA==", message)
end

security.verifyHMAC = function(hmac, message)
    verificationHMAC = crypto.hmac("sha512", message, "secretkey")
    if verificationHMAC  == hmac then
        return true
    end
    return false
end

print(crypto.hmac("sha256", "Hash me please", "Yx9SqhHca9aeuD+hqCNjAA=="))
print(node.heap())

return security
