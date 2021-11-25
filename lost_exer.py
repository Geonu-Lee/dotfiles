def solution(n, lost_, reserve_):
    # reserve_ = set(reserve)-set(lost) 
    # lost_ = set(lost)-set(reserve) 

    for b in reserve_:
        if b-1 in lost_:
            lost_.remove(b-1)
        elif b+1 in lost_:
            lost_.remove(b+1)
    a = n-len(lost_)
    return a