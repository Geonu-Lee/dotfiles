from itertools import cycle

def mock(answers):
    mock_math = [cycle([1,2,3,4,5]),cycle([2,1,2,3,2,4,2,5]),cycle([3,3,1,1,2,2,4,4,5,5])]
    correct = [0, 0, 0]
    for i in (answers):
        for j in range(len(correct)):
            if i==next(mock_math[j]):
                correct[j] += 1
    return [i+1 for i,v in enumerate(correct) if v == max(correct)]
print(mock([1,3,2,4,2]))


    # for num in answers:
    #     for i in range(3):
    #         if next(giveups[i]) == num:
    #             scores[i] += 1
    # highest = max(scores)