#!/usr/bin/env awk -f
{ 
    sum += $1
    nums[NR] = $1  # We store the input records
}
END {
    if (NR < 20) p95 = nums[NR - 1]
    else p95 = nums[NR * 95 / 100]

#    asort(nums)  #  Here, we sort the array that
#                 #+ contains the stored input
 

    printf "%s\n", p95
}
