#n, lost, reserve
n=5
lost = [2,4]
reserve = [1,3,5]

reserve_set = set(reserve)-set(lost) 
lost_set = set(lost)-set(reserve) 

for b in reserve_set:
    if b+1 in lost_set:
        lost_set.remove(b+1)
    if b-1 in lost_set:
        lost_set.remove(b-1)
a = n-len(lost)
        
print(a)
reserve_set = set(reserve)-set(lost) 
lost_set = set(lost)-set(reserve) 

for reserve_person in reserve_set: 
    if reserve_person-1 in lost_set: 
        lost_set.remove(reserve_person-1) 
    elif reserve_person+1 in lost_set: 
        lost_set.remove(reserve_person+1) 

n-len(lost_set)