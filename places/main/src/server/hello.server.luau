const shared = require("@shared")

const function greeting(name: string)
    print(`Hello, { name }!`)
end

greeting("word")
greeting("main place")
greeting("rojo")
greeting(tostring(shared))