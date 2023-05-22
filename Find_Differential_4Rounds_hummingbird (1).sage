##################################
from sage.crypto.sbox import SBox
s1 = SBox([8,6,5,15,1,12,10,9,14,11,2,4,7,0,13,3])
s2 = SBox(0,7,14,1,5,11,8,2,3,10,13,6,15,12,4,9)
s3 = SBox(2,14,15,5,12,1,9,10,11,4,6,8,0,7,3,13)
s4 = SBox(0,7,3,4,12,1,10,15,13,14,6,11,2,8,9,5)
#value: input value which has to be circularly shifted left
#n: number of positions to shift
#Return value: result after circularly left shifting input value
def circular_left_shift(value, n) :
    num_bits_in_int = 16
    n = n % num_bits_in_int
    mask = (1 << num_bits_in_int) - 1
    result = (value << n) | (value >> (num_bits_in_int - n))
    result = result & mask
    return result
 
 
#value: input value which has to be circularly shifted right
#n: number of positions to shift
#Return value: result after circularly right shifting input
def circular_right_shift(value, n) :
    num_bits_in_int = 16
    n = n % num_bits_in_int
    mask = (1 << num_bits_in_int) - 1
    result = (value >> n) | (value << (num_bits_in_int - n))
    result = result & mask
    return result
class Hummingbird:
    def xor(self,m,k):
        return (k ^^ m)
    def sboxLayer(self,m):
        n = 4;N = 2^n
        [m3 ,m2 ,m1 ,m0] = ZZ(m).digits(N,padto = 4)
        [m0 ,m1 ,m2 ,m3] = [s1(m0),s2(m1),s3(m2),s4(m3)]
        result = (N^3*m0) + (N^2*m1) + (N^1*m2) + (m3)
        return result
    def linear_transform(self,result):
        n = 4;N = 2^n
        [m0,m1,m2,m3] = result
        result = (N^3*m0) + (N^2*m1) + (N^1*m2) + (m3)
        
        result = result ^^ (circular_left_shift(result, 6) ) ^^ (circular_left_shift(result, 10) )  
        
        [m3 ,m2 ,m1 ,m0] = ZZ(result).digits(N,padto = 4)
        return [m0, m1, m2, m3]
hummingbird = Hummingbird()
'''rounds = 3
rows = 2
cols = 2    # 2x2 states
exponent = 4    # 4-bit words
aes = mq.SR(rounds, rows, cols, exponent, allow_zero_inversions=True, star=True)
# - allow_zero_inversions :: suppresses errors when the S-box does just that
# - star :: modifies the last round as specified for Rijndael, but some algebraic attacks might prefer differently

# to debug lin ca, we also define a 1 round and a 2 round version
aes1 = mq.SR(1, rows, cols, exponent, allow_zero_inversions=True, star=True)
aes2 = mq.SR(2, rows, cols, exponent, allow_zero_inversions=True, star=True)

S = aes.sbox()
F = aes.base_ring()
a = F.gen()'''

###########################
b = []
for i in range(65536):
    n = 4;N = 2^n
    (m3 ,m2 ,m1 ,m0) = ZZ(i).digits(N,padto = 4)
    a = (m0 ,m1 ,m2 ,m3)
    b.append(a)
    all_states = b
    
'''from itertools import *
all_states = product(F,repeat=4)
pairs_of_words = product(F,repeat=2)'''

    


######################################

'''M1 = S.difference_distribution_matrix()
M2 = S.difference_distribution_matrix()
M3 = S.difference_distribution_matrix()
M4 = S.difference_distribution_matrix()'''

M1 = s1.difference_distribution_matrix()
M2 = s2.difference_distribution_matrix()
M3 = s3.difference_distribution_matrix()
M4 = s4.difference_distribution_matrix()
##########################################

def h2b(hex):
    '''take a single hex digit and return the corresponding 4 bit string

    sage: h2b('A')
    '1010'
    '''
    integer = ZZ(int(hex,16))
    bits = integer.binary()
    return bits.zfill(4)

def d2b(dec):
    '''transform decimal to 4-bit string'''
    return ZZ(dec).binary().zfill(4)




def bitstring2numberstate(bitstring):
    '''transform a ['0001','0001','0001','0001'] into a list of 4 nibbles [1,1,1,1] (these nibbles make a hex word)  '''
    a = [int(x,base=2) for x in bitstring]
    return a

def numstate2bitstring(state):
    '''transform a [1,1,1,1] into a list of 4 nibbles ['0001','0001','0001','0001']'''
    a = map(str,state)
    a =[d2b(state[i]) for i in range(4)]
    return a


dx = ['0000', '1010', '0000', '0011']
dy = ['1100', '0011', '0011', '0000']

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
    '''inputs string and outputs string'''
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
print 'after Sboxes the most likely state is (see above)\n',
v1 = most_likely_state(dx)
prob = prob*p_S(dx,v1)
print 'v1 =', v1
print 'after Linear_tansformation\n',

v1 = bitstring2numberstate(v1)
W1 = hummingbird.linear_transform(v1)
print 'w1 =', W1
w1 = numstate2bitstring(W1)

print 'after Sboxs the most likely state is\n',
v2 = most_likely_state(w1)
prob = prob*p_S(w1,v2)
print 'v2 =', v2
print 'after SR and MC this transitions into\n',
V2 = bitstring2numberstate(v2)
W2 = hummingbird.linear_transform(V2)
w2 = numstate2bitstring(W2)
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
        dx = numstate2bitstring(list(dX))
        print '######## Round 1 ##########'
        print 'dx for first round:',dx
        prob = 1
        v1 = most_likely_state(dx)
        print 'v1=',v1
        prob = prob*p_S(dx,v1)
        print 'prob1=',prob 
        V1 = bitstring2numberstate(v1)
        print 'V1 =',V1
        W1 = hummingbird.linear_transform(V1)
        print 'After Linear_transform w1=',W1
        w1 = numstate2bitstring(W1)
        print 'dy after dound 1:',w1
        print '###### Round 2 #############'
        print 'dx for second round:',w1
        v2 = most_likely_state(w1)
        print 'v2=',v2
        prob = prob*p_S(w1,v2)
        print 'prob2 = ',prob
        V2 = bitstring2numberstate(v2)
        W2 = hummingbird.linear_transform(V2)
        print 'after linear_transform:w2 =',W2
        w2 = numstate2bitstring(W2)
        print 'dy after dound 2:',w2
        print '###### Round 3 ###############'
        print 'dx for third round:',w2
        v3 = most_likely_state(w2)
        print 'v3=',v3
        prob = prob*p_S(w2,v3)
        print 'prob3 = ',prob
        V3 = bitstring2numberstate(v3)
        W3 = hummingbird.linear_transform(V3)
        print 'after linear_transform:w3 =',W3
        w3 = numstate2bitstring(W3)
        print 'dy after dound 3:',w3
        print '########## Round 4 ########'
        print 'dx for third round:',w3
        v4 = most_likely_state(w3)
        print 'v2=',v4
        prob = prob*p_S(w3,v4)
        print 'prob4 = ',prob
        V3 = bitstring2numberstate(v4)
        W4 = hummingbird.linear_transform(V3)
        print 'after linear_transform:w4 =',W4
        w4 = numstate2bitstring(W4)
        print 'dy after dound 4:',w4
        
        weight = 4-w4.count('0000')
        if max_prob < prob < 1:
            max_prob = prob
            max_char = []
            max_weight = weight
        if prob == max_prob:
            counter +=1
            if weight == max_weight:
                max_char.append([dx,w4])
            if 0 < weight < max_weight:
                max_char = [[dx,w4]]
                max_weight = weight
    l = (max_char, counter,  max_prob)
    save(l,'output')
    return max_char, counter,  max_prob

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