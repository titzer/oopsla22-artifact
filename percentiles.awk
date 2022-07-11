#!/usr/bin/env awk -f
{ 
    sum += $1
    nums[NR] = $1  # We store the input records
}
END {
    if (NR == 0) exit  #To avoid division by zero
 
    asort(nums)  #  Here, we sort the array that
                 #+ contains the stored input
 
    p50 = (NR % 2 == 0) ?  #  Let's be carefull with the
                              #+ short-if syntax
        ( nums[NR / 2] + nums[(NR / 2) + 1] ) / 2 \
        :
        nums[int(NR / 2) + 1]

    p5 = nums[NR * 5 / 100]
    p95 = nums[NR * 95 / 100]

    mean = sum/NR
 
    printf \
        "min=%s, P5=%s, P50=%s, P95=%s, max=%s, avg=%s\n",\
        nums[1],\
        p5,\
        p50,\
        p95,\
        nums[NR],\
        mean
}
