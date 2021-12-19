## Analyze a very simple websocket packet (Captured by WireShark)
* This is a 12-byte packet (long payload has additional packet fragments)
```
1        2        3        4        5        6        7        8        9        10       11       12  
10000001 10000110 11100010 10110100 10110111 01010011 11010011 10000110 10000100 01100111 11010111 10000010
│   │  │ |│     │ |                                 | |                                                   |
│   └──┤ │└─────┤ └─────────────────────────────────┤ ├───────────────────────────────────────────────────┘
①      ② ③      ④                                   ⑤ ⑥ 
```
  * ① Fin: This bit tells whether this is the last message in a series. If it's 0, then the server keeps listening for more parts of the message; otherwise, the server should consider the message delivered.
  * Three reserved bits between ① and ② serve no purpose.
  * ② OpCode: These four bits defines how to interpret the payload data: 0x0 for continuation, 0x1 for text (which is always encoded in UTF-8), 0x2 for binary, and ...
  * ③ Mask: This bit tells whether the message is encoded. Messages from the client must be masked (1) while it is 0 for server's reply.  
  * ④ Payload Length: It is 6.
  * ⑤ Masking key: Four bytes, randomly chosen by the client
  * ⑥ Masked Payload: Six bytes. Unmasked payload is '123456'
### Masking and Unmasking code:
* Running following python code, you will get unmasked '123456' and masked payload. [RFC6455](https://datatracker.ietf.org/doc/html/rfc6455#section-5.3)
```python
masking_key      = [0b11100010, 0b10110100, 0b10110111, 0b01010011]
masked_payload   = [0b11010011, 0b10000110, 0b10000100, 0b01100111, 0b11010111, 0b10000010]  
unmasked_payload = ['1', '2', '3', '4', '5', '6']

print('Unmasked Payload:', [ chr(c^masking_key[i%4])  for i, c in enumerate(masked_payload)] ) 
print('Masked Payload:', [ bin(ord(c)^masking_key[i%4])  for i, c in enumerate(unmasked_payload)] ) 
``` 
