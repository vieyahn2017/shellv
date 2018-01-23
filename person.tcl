package require Itcl
namespace import itcl::*

class CPerson {
    protected variable m_name
    protected variable m_sex

    constructor {name sex} {
        set m_name $name
        set m_sex $sex
    }

    public method PrintInfo {} {
        puts "CPerson [GetInfo]"
    }

    public method GetInfo {} {
        return "name=$m_name;sex=$m_sex"
    }

}

class CStudent {
    inherit CPerson

    protected variable m_age

    constructor {name sex age} {
        CPerson::constructor $name $sex } {
            set m_age $age
    }

    public method GetInfo {} {
        return "name=$m_name;sex=$m_sex;age=$m_age"
    }
}


proc main {} {
    CPerson a "Leiyuhou" M
    CStudent b "lily" F 20
    a PrintInfo
    b PrintInfo
}

main
