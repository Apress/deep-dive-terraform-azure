variable listofhybriditems {
    type = list(any)
    default = [10, "ritesh", true, "modi"]
}

Output listofhybriditems  {
	Value  = var.listofhybriditems 
}

Output singlevaluefromlistofhybriditems  {
	Value = var.listofhybriditems[1]
}
