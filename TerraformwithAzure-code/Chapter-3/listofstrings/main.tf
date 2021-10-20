variable listofstrings {
    type = list(string)
    default = ["one", "two", "three", "four"]
}

Output listofstrings {
	Value  = var.listofstring
}

Output singlevaluefromlistofstrings {
	Value = var.listofstrings[1]
}
