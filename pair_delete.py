def solution(s):
    stack = []
    idx = 0
    if len(s)%2 == 1:
        return 0
    while idx < len(s):
        if not stack:
            stack.append(s[idx])
        elif stack[-1] == s[idx]:
            stack.pop()
        else:
            stack.append(s[idx])
        idx+=1
        continue

    if stack:
        return 0
    else:
        return 1
