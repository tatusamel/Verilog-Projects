nm = list(map(int, input().split()))
n = nm[0]
m = nm[1]

arr = list(map(int, input().split()))
arr = sorted(arr)

j = 0
i = 1
while(i < m):
    if (j >= len(arr)):
        print(i, end= ' ')
    elif (arr[j] != i):
        print(i, end= ' ')
    else:
        j+=1
    i+=1

    













print(arr)