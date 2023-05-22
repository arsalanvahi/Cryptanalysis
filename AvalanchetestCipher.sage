def Avalanchetest(n,m):
    f = open("CipherText1.txt","r")   #copy each line of cipher Execution output with pt1
    f1 = f.read()
    f1 = f1.split('\n')
    f.close()
    f = open("CipherText2.txt","r")  ##copy each line of cipher Execution output with pt2
    f2 = f.read()
    f2 = f2.split('\n')
    f.close()
    for i in range(n):
        X = ZZ("0x"+f1[i])
        Y = ZZ("0x"+f2[i])
        XY = X ^^ Y
        b = XY.binary()
        s = sum(ZZ(i) for i in b)
        print s,b.zfill(m)
#if the ciphertext1 and ciphertext2 files are not correctly feeded , the program will not work
