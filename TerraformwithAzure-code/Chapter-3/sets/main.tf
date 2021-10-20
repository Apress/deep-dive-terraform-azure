variable myset {
    type = set(string)
    default = ["one", "two", "three", "four", "two"]
}

variable mysetany {
    type = set(any)
    default = [10,20,30,40, 30]
}

//converts every element to string
variable mysethybrid {
    type = set(any)
    default = [10, "ritesh", true, "modi"]
}


variable setofmaps {
    type = set(map(string))
    default  = [
        {
            name = "ritesh"
            age = "20"
        },
        {
            name = "avni"
            age = "10"
        },
        {
            name = "avni"
            age = "10"
        }
    ]
}


variable setofobjects {
    type = set(object({
        location = string
        age = number
    }
    ))
    default  = [
        {
            location = "hyderabad"
            age = 20
        },
        {
            location = "kolkata"
            age = 10
        },
        {
            location = "bngalore"
            age = 30
            name = "ritesh"
        }
    ]
}
