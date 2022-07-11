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

    printf "%s\n", p50
}
