variable myEmployeeObject {
    type = object({
        name = string
        age = number
        is_married = bool
        companies = map(string)
        schools = list(string)
    })
    default = {
        name = "ritesh"
        age = 25
        is_married = true
        companies = {
            company1 =  "abcd"
            "2company" = "xyz"
        }
        schools = ["school1", "school2"]
    }

}


variable myEmployeeAny {
    type = object({
        name = any
        age = any
        is_married = any
        companies = any
        schools = any
    })
    default = {
        name = "ritesh"
        age = 25
        is_married = true
        companies = {
            company1 =  "abcd"
            "2company" = "xyz"
        }
        schools = ["school1", "school2"]
    }

}
