import Foundation

typealias Age = Int

struct Company {
    let name: String
    let department: Department
}

struct Department {
    let name: String
    let manager: Manager
}

struct Manager {
    let name: String
    let age: Age
}

struct Lens<A, B> {
    let get: A -> B
    let set: (B, A) -> A
}

////

let dep1 = Department(name: "Dep1", manager: Manager(name: "Jack", age: 35))

let mngNameLens: Lens<Department, Manager> = Lens(get: { $0.manager },
        set: { employee, department in
            return Department(name: department.name, manager: employee)
        }
    )

let newManager = Manager(name: "Michael", age: 34)

var dep1_updated = mngNameLens.set(newManager, dep1)

let ageLens: Lens<Manager, Age> = Lens(get: { $0.age },
        set: { age, manager in
            return Manager(name: manager.name, age: age)
        }
    )

let maturedManager = ageLens.set(newManager.age+1, newManager)

//// Composition

func * <A, B, C>(lhs: Lens<A, B>, rhs: Lens<B, C>) -> Lens<A, C> {
    return Lens(get: { rhs.get(lhs.get($0)) },
        set: { (c, a) in return lhs.set(rhs.set(c, lhs.get(a)), a) }
    )
}

let depMngAgeLens = mngNameLens * ageLens
let age = depMngAgeLens.get(dep1_updated)
dep1_updated = depMngAgeLens.set(age + 1, dep1_updated)
depMngAgeLens.get(dep1_updated)

