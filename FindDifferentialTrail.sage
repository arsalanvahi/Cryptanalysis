##################################
rounds = 3
rows = 2
cols = 2    # 2x2 states
exponent = 4    # 4-bit words
aes = mq.SR(rounds, rows, cols, exponent, allow_zero_inversions=True, star=True)
# - allow_zero_inversions :: suppresses errors when the S-box does just that
# - star :: modifies the last round as specified for Rijndael, but some algebraic attacks might prefer differently

# to debug lin ca, we also define a 1 round and a 2 round version
aes1 = mq.SR(1, rows, cols, exponent, allow_zero_inversions=True, star=True)
aes2 = mq.SR(2, rows, cols, exponent, allow_zero_inversions=True, star=True)

F = aes.base_ring()
a = F.gen()

###########################
b = []
for i in range(1300):
    n = 4;N = 2^n
    (m3 ,m2 ,m1 ,m0) = ZZ(i).digits(N,padto = 4)
    a = (m0 ,m1 ,m2 ,m3)
    b.append(a)
    all_states = b

    
pairs_of_words = product(F,repeat=2)

######################################
S = aes.sbox()
M1 = S.difference_distribution_matrix()
M2 = S.difference_distribution_matrix()
M3 = S.difference_distribution_matrix()
M4 = S.difference_distribution_matrix()

def h2b(hex):
    '''take a single hex digit and return the corresponding 4 bit string

    sage: h2b('A')
    '1010'
    '''
    integer = ZZ(int(hex,16))
    bits = integer.binary()
    return bits.zfill(4)

def d2b(dec):
    return ZZ(dec).binary().zfill(4)

def b2F(bits):
    '''transform 4-bits to an element of F

    sage: b2F('0101')
    a^2 + 1
    '''
    prefixed = int(str(bits),2)
    return F.fetch_int(prefixed)

def F2b(element):
    '''transform element of F into 4-bit string

    sage: F2b(a^2+1)
    '0101'
    '''
    integer = sage_eval(str(element), {'a':2})
    bits = integer.binary()
    return bits.zfill(4)

def bitstring2state(bitstring):
    '''transform a list of 4 nibbles (each as string '0100') to the corresponding a 2x2 aes state matrix (colum-wise)'''
    return aes.state_array([b2F(bitstring[i]) for i in range(4)])

def state2bitstring(state):
    '''given a 2x2 aes state matrix, return a list of 4 nibbles'''
    hexstate = aes.hex_str(state, typ='vector')
    return [h2b(hexstate[i]) for i in range(4)]


dx = ['0110','0000','0000','1000']
dy = ['0001','0000','0000','1111']

#delta = [dx,dy]




def p_S(dx,dy):
    '''return the propagation ratio for dx->dy through SubBytes'''
    p = []
    p1 =  M1[int(dx[0],base=2),int(dy[0],base=2)]/M1[0,0] 
    p.append(p1)
    p2 =  M2[int(dx[1],base=2),int(dy[1],base=2)]/M2[0,0] 
    p.append(p2)
    p3 =  M3[int(dx[2],base=2),int(dy[2],base=2)]/M3[0,0] 
    p.append(p3)
    p4 =  M4[int(dx[3],base=2),int(dy[3],base=2)]/M4[0,0] 
    p.append(p4)
    return prod(p)



def most_likely_state(dx):
    '''given a list of four words, return the list of most likely words after calling SubBytes'''
    row1 = M1[int(dx[0],base=2)].list()
    row2 = M2[int(dx[1],base=2)].list()
    row3 = M3[int(dx[2],base=2)].list()
    row4 = M4[int(dx[3],base=2)].list()
    d1 = d2b(row1.index(max(row1)))
    d2 = d2b(row2.index(max(row2)))
    d3 = d2b(row3.index(max(row3)))
    d4 = d2b(row4.index(max(row4)))
    
    return [d1, d2, d3, d4]



print 'check that dy is the most likely state:', dy == most_likely_state(dx)

# run dx through the first 2 rounds

print 'starting with dx as above, we enter the first ronud with\n',
prob = 1
print 'u1 =', dx
print 'after SubBytes the most likely state is (see above)\n',
v1 = most_likely_state(dx)
prob = prob*p_S(dx,v1)
print 'v1 =', v1
print 'after SR and MC this transitions into\n',
V1 = bitstring2state(v1)
W1 = aes.mix_columns(aes.shift_rows(V1))
w1 = state2bitstring(W1)
print 'w1 =', w1
print 'after SubBytes the most likely state is\n',
v2 = most_likely_state(w1)
prob = prob*p_S(w1,v2)
print 'v2 =', v2
print 'after SR and MC this transitions into\n',
V2 = bitstring2state(v2)
W2 = aes.mix_columns(aes.shift_rows(V2))
w2 = state2bitstring(W2)
print 'w2 =', w2
# w2 = ['1010', '1100', '0000', '0000']
print 'and this is u3, the state difference at the beginnig of round 3'
print 'the expected propagation ratio of this differential characteristic is', prob

def find_max():
    '''find all differential characteristics with maximal "expected propagation ratio"'''
    '''ignore the trivial differential, and filter for least number of active words in last round'''
    counter = 0
    max_prob = 0
    max_char = []
    max_weight = 4
    for dX in all_states:
        dx = state2bitstring(aes.state_array(list(dX)))
        prob = 1
        v1 = most_likely_state(dx)
        prob = prob*p_S(dx,v1)
        V1 = bitstring2state(v1)
        W1 = aes.mix_columns(aes.shift_rows(V1))
        w1 = state2bitstring(W1)
        v2 = most_likely_state(w1)
        prob = prob*p_S(w1,v2)
        V2 = bitstring2state(v2)
        W2 = aes.mix_columns(aes.shift_rows(V2))
        w2 = state2bitstring(W2)
        weight = 4-w2.count('0000')
        if max_prob < prob < 1:
            max_prob = prob
            max_char = []
            max_weight = weight
        if prob == max_prob:
            counter +=1
            if weight == max_weight:
                max_char.append([dx,w2])
            if 0 < weight < max_weight:
                max_char = [[dx,w2]]
                max_weight = weight
    return max_char, counter,  max_prob,

# Appendix B : computing the true propagation ratio of dx -> w2 (assuming independent roundkeys)
# find all trails that yield the given differential

def all_trails(du1, du3):
    '''find all differential trails du1->du2->du3 for the 2-round differential du1->du3 with corresponding propagation ratio'''
    intermediate_states = {}
    for dU2 in all_states:
        print dU2
        du2 = state2bitstring(aes.state_array(list(dU2)))
        print du2
        if prop_ratio(du1, du2, du3) > 0:
            intermediate_states[str(du2)] = prop_ratio(du1,du2,du3)
    return intermediate_states