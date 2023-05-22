def testAE(X,b,n):  # X = Sbox , b = [2^i] , n = count of bit entrance
    wts = 0;
    for i in range(2^n):
        s = X(i) ^^ X(i^^b)
        wts += sum(s.bits())
    print wts
    return wts

#from sage.crypto.
#S = SBox(8,6,5,15,1,12,10,9,14,11,2,4,7,0,13,3)

#for i in [1,2,4,8]:
#   testAE(S,i,4)
        