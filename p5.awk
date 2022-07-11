#!/usr/bin/env awk -f
{ 
    sum += $1
    nums[NR] = $1  # We store the input records
}
END {
    if (NR == 0) exit  #To avoid division by zero
 
    asort(nums)  #  Here, we sort the array that
                 #+ contains the stored input
 
    p5 = nums[NR * 5 / 100]

    printf "%s\n", p5
}
