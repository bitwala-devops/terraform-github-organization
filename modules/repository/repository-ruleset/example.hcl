inputs = {
  ruleset = {
    name        = "main"
    target      = "branch"
    enforcement = "active"
    
    conditions = [ {
      ref_name = {
        include = ["main"]
        exclude = []
      }
    }
      ]
    bypass_actors = list()
    rules = list()
  }
}
