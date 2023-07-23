proc Fact1 {n} {
    if {$n<=1} {
        return 1
    }
    return [expr $n*[Fact1 [expr $n-1]]]
}

proc Fact2 {n} {
    set result 1
    for {set i 1} {$i<=$n} {incr i} {
        set result [expr $result*$i]
    }
    return $result
}

proc Fact3 {n} {
    set result 1
    set i 1
    while {$i<=$n} {
        set result [expr $result*$i]
        incr i        
    }
    return $result
}
