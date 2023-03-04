### Encryption
* Authenticated encryption ([wiki](https://en.wikipedia.org/wiki/Authenticated_encryption))
  * Concept:
    1. Plaintext: a human-readable secret to be protected
    2. Key: another secret to protect the Plaintext 
    3. Header (optional): public text (associated data), can be used to identify the owner.
    4. Ciphertext: the encrypted secret
    5. Tag: authentication tag
  * Python example:
```
#pip install pycryptodome

from Crypto.Cipher import ChaCha20_Poly1305
from Crypto.Random import get_random_bytes  
key           = get_random_bytes(32)
nonce_rfc7539 = get_random_bytes(12)
cipher   = ChaCha20_Poly1305.new(key=key, nonce=nonce_rfc7539)
decipher = ChaCha20_Poly1305.new(key=key, nonce=nonce_rfc7539)

# Why header ? If you use different headers, MAC check fails even if the key and nonce are the same. Also see https://developers.google.com/tink/bind-ciphertext
header   = b'Allies '
cipher.update(header)
decipher.update(header)

plaintext = b'Attack at dawn' 
ciphertext = cipher.encrypt(plaintext)  
print(decipher.decrypt(ciphertext))

plaintext = b'Holy crap'
ciphertext = cipher.encrypt(plaintext)  
print(decipher.decrypt(ciphertext))

decipher.verify(cipher.digest())
```