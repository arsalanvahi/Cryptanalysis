from sage.crypto.sbox import SBox
S = SBox(6, 4, 7, 8, 0, 5, 2, 10, 14, 3, 13, 1, 12, 15, 9, 11)
def I(difference):
    '''return the list of pairs with specified (input) bitstring difference'''
    a = [ [F2b(word),F2b(word+b2F(difference))] for word in F]
    a.sort()
    return a

dx = '0000'
print 'For example I(', dx, ') =', I(dx)

print '% 5s % 5s % 5s % 5s %5s'%('x','x^*','y','y^*','dy')
for pair in I(dx):
    x = pair[0]
    x1 = pair[1]
    y = F2b(aes.sub_byte(b2F(x)))
    y1 = F2b(aes.sub_byte(b2F(x1)))
    dy = F2b(b2F(y)+b2F(y1))
    print '% 5s % 5s % 5s % 5s %5s'%(x,x1,y,y1,dy)

print 'absolute frequency for differentials with dx =',dx,':', S.difference_distribution_matrix()[int(dx,base=2),:]
print 'difference distribution table for the S-Box of baby-AES\n', S.difference_distribution_matrix()

