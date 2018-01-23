package require Itcl
package require control

itcl::class Complex {
    public variable m_r
    public variable m_i

    constructor {r i} {
        set m_r $r
        set m_i $i
    }

    public method + {c} {
        set r [expr "$m_r + [$c cget -m_r]"]
        set i [expr "$m_i + [$c cget -m_i]"]
        return [code [Complex #auto $r $i]]
    }

    public method - {c} ;# ===

    public method GetReal {} {
        return $m_r
    }

    public method GetImag {} {
        return $m_i
    }
}

itcl::body Complex::- {c} {
    set r [expr "$m_r - [$c cget -m_r]"]
    set i [expr "$m_i - [$c cget -m_i]"]
    return [itcl::code [Complex #auto $r $i]]
}


proc main {} {
    set r 100; set i 200
    Complex a $r $i
    Complex b 50 50

    set c [a - b]

    control::control assert enabled 1
    puts "c.real = [$c GetReal]; c.imag = [$c GetImag]"
    control::assert "[$c GetReal]==50"
    control::assert "[$c GetImag]==150"
}

main
