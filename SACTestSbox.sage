def testSAC(X,b,n):  # X = Sbox , b = [2^i] , n = count of bit entrance
    m = [0,0,0,0]
    for i in range(2^n):
        
        s = X(i) ^^ X(i^^b)
        m = [x+y for x,y in zip(m,s.digits(2,padto=4))]
    print m
    return m
