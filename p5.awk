#!/usr/bin/env awk -f
{ 
    sum += $1
    nums[NR] = $1  # We store the input records
}
END {
    if (NR < 20) p5 = nums[0]
    else p5 = nums[NR * 5 / 100]
# assume inputs are sorted
#    asort(nums)  #  Here, we sort the array that
#                 #+ contains the stored input


    printf "%s\n", p5
}
