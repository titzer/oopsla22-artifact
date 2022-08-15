#!/usr/bin/env awk -f
{ 
    sum += $1
    nums[NR] = $1  # We store the input records
}
END {
    if (NR < 20) p5 = nums[0]
    else p5 = nums[int((NR * 5) / 100)]
    printf "%s\n", p5
}
