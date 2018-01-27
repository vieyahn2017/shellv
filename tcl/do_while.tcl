proc do { body while_key cond} {
    if { $while_key != "while" } {
        error "the second parameter must be \"while\"."
    }

    for {} {1} {} {
        set r [catch {uplevel $body} msg]
        switch $r {
            0 {
                #this is normal, do nothing             
            }
            1 { this is a error, so throw the exception
                return -code error -errorinfo $::errorInfo -errorcode $::errorCode
            }
            2 { #this is return;
                return -code return $msg
            }
            3 { #this is break;
                break
            }
            4 {
                #this is continue, do nothing
            }
        }
        set r [uplevel expr $cond]
        if {!$r} {
            break
        }
    }
}


set a 0
set sum 0
do {
    incr a
    incr sum $a
} while {$a<=100}

puts $sum
