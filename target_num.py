import copy
def solution(numbers, target):
    a = [0]
    for i in range(len(numbers)):
        b  = []
        for j in range(len(a)):
            b.append(a[j]+numbers[i])
            b.append(a[j]-numbers[i])
        a= copy.deepcopy(b)
    return a.count(target)