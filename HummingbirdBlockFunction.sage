from sage.crypto.sbox import SBox
s1 = SBox([8,6,5,15,1,12,10,9,14,11,2,4,7,0,13,3])
s2 = SBox(0,7,14,1,5,11,8,2,3,10,13,6,15,12,4,9)
s3 = SBox(2,14,15,5,12,1,9,10,11,4,6,8,0,7,3,13)
s4 = SBox(0,7,3,4,12,1,10,15,13,14,6,11,2,8,9,5)
def key_xor(
def HummingbirdBlock(m,k):
    n = 4;N = 2^n
    m = m ^^ k
    [m1 ,m2 ,m3 ,m4] = ZZ(m).digits(N,padto = 4)
    print m1;print m2;print m3;print m4
    [m1 ,m2 ,m3 ,m4] = [s4(m1),s3(m2),s2(m3),s1(m4)]
    print m1;print m2;print m3;print m4
    result = (N^3*m4) + (N^2*m3) + (N^1*m2) + (m1)
    result = result ^^ (result <<6) ^^ (result <<10)
    return hex(result)

    
#############################################################
from sage.crypto.sbox import SBox
s1 = SBox([8,6,5,15,1,12,10,9,14,11,2,4,7,0,13,3])
s2 = SBox(0,7,14,1,5,11,8,2,3,10,13,6,15,12,4,9)
s3 = SBox(2,14,15,5,12,1,9,10,11,4,6,8,0,7,3,13)
s4 = SBox(0,7,3,4,12,1,10,15,13,14,6,11,2,8,9,5)

def key_xor(m,k):
    return (m ^^ k)
def sbox_layer(m):
    n = 4;N = 2^n
    [m1 ,m2 ,m3 ,m4] = ZZ(m).digits(N,padto = 4)
    print m1;print m2;print m3;print m4
    [m1 ,m2 ,m3 ,m4] = [s4(m1),s3(m2),s2(m3),s1(m4)]
    print m1;print m2;print m3;print m4
    result = (N^3*m4) + (N^2*m3) + (N^1*m2) + (m1)
    print result
    return result
def linear_transform(result):
    result = result ^^ (result <<6) ^^ (result <<10)
    return result
def HummingbirdBlock(m,k):
    m = key_xor(m,k)
    m = sbox_layer(m)
    m = linear_transform(m)
    return hex(m)
#############################################################
from sage.crypto.sbox import SBox
s1 = SBox([8,6,5,15,1,12,10,9,14,11,2,4,7,0,13,3])
s2 = SBox(0,7,14,1,5,11,8,2,3,10,13,6,15,12,4,9)
s3 = SBox(2,14,15,5,12,1,9,10,11,4,6,8,0,7,3,13)
s4 = SBox(0,7,3,4,12,1,10,15,13,14,6,11,2,8,9,5)
class Hummingbird:
    def __init__(self,m,k):
        self.m = m
        self.k = k
    def xor(self):
        return (self.k ^^ self.m)
    def sboxLayer(self,m):
        n = 4;N = 2^n
        [m3 ,m2 ,m1 ,m0] = ZZ(self.m).digits(N,padto = 4)
        [m0 ,m1 ,m2 ,m3] = [s1(m0),s2(m1),s3(m2),s4(m3)]
        result = (N^3*m0) + (N^2*m1) + (N^1*m2) + (m3)
        return result
    def linear_transform(self,result):
        result = result ^^ (result <<6) ^^ (result <<10)
        return hex(result)
hummingbird = Hummingbird(0,0)
a = hummingbird.xor()
b = hummingbird.sboxLayer(a)
c = hummingbird.linear_transform(b)
##########################################################
from sage.crypto.sbox import SBox
s1 = SBox([8,6,5,15,1,12,10,9,14,11,2,4,7,0,13,3])
s2 = SBox(0,7,14,1,5,11,8,2,3,10,13,6,15,12,4,9)
s3 = SBox(2,14,15,5,12,1,9,10,11,4,6,8,0,7,3,13)
s4 = SBox(0,7,3,4,12,1,10,15,13,14,6,11,2,8,9,5)
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
        result = result ^^ (result <<6) ^^ (result <<10)
        return hex(result)
hummingbird = Hummingbird()
a = hummingbird.xor(0,0)
b = hummingbird.sboxLayer(a)
c = hummingbird.linear_transform(b)
    ####################################################
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
    
    