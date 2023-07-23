set students {
    {LiLei Mail 16}
    {LiLy Femail 18}
    {Tiger Mail 22}
}

set index 1
foreach s $students {
    foreach {name sex age} $s {
        puts "$index -> $name $age"        
    }
    incr index
}

puts [lindex $students end] ;# end表示尾元素，可以改成0 1 2 等下标
