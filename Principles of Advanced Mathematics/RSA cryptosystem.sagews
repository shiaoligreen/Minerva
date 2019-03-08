##Judson 7.7: 1-4##

#construct a keypair for Alice using the first two primes greater than 10^12
p_a = next_prime(10^12)
q_a = next_prime(p_a)
n_a = p_a * q_a
m_a = euler_phi(n_a)
factor(m_a)
E_a = 7
D_a = inverse_mod(E_a,m_a)
print(n_a, E_a, D_a)

#verify encryption and decryption keys are multiplicative inverses
E_a = inverse_mod(D_a , m_a)
print(E_a)

#construct a keypair for Bob using the first two primes greater than 2(10^12)
p_b = next_prime(2*10^12)
q_b = next_prime(p_b)
n_b = p_b * q_b
m_b = euler_phi(n_b)
factor(m_b)
E_b = 3
D_b = inverse_mod(E_b,m_b)
print(n_b, E_b, D_b)

#enocde your name using ASCII values, create signed message for communication from Alice to Bob
#Shiao-li Green:D
name = ['Shia', 'o-li', ' Gre', 'en:D']
message = []
signed = []
encrypted = []
for block in range(len(name)):
    digits = [ord(letter) for letter in name [block]]
    message.append(ZZ(digits , 128))
    signed.append(power_mod(message[block], D_a , n_a ))
    encrypted.append(power_mod(signed[block], E_b , n_b ))
print(" Message ", message , " Signed message ", signed ,
" Encrypted message ", encrypted)

#demonstrate how Bob converts the message received back into your name
decrypted = []
received = []
digits = []
phrase = []
letters = []
for block in range(len(encrypted)):
    decrypted.append(power_mod(encrypted[block], D_b , n_b ))
    received.append(power_mod(decrypted[block], E_a , n_a ))
    digits.append(received[block].digits(base=128))
    letters.append([chr(ascii) for ascii in digits [block]])
    phrase.append(''.join (letters[block]))
print phrase

#create a new signed message simulating the message being tampered by adding 1 to the integer Bob receives
message = []
signed = []
tampered = []
for block in range(len(name)):
    digits = [ord(letter) for letter in name [block]]
    message.append(ZZ(digits , 128))
    signed.append(power_mod(message[block], D_a , n_a ))
    tampered.append(power_mod(signed[block], E_b , n_b )+1)
print(" Message ", message , " Signed message ", signed ,
" Tampered message ", tampered )

#decryption of tampered message 
decrypted = []
received = []
digits = []
phrase = []
letters = []
for block in range(len(encrypted)):
    decrypted.append(power_mod(tampered[block], D_b , n_b ))
    received.append(power_mod(decrypted[block], E_a , n_a ))
    digits.append(received[block].digits(base=128))
    letters.append([chr(ascii) for ascii in digits[block]])
    phrase.append(''.join(letters[block]))
print phrase
