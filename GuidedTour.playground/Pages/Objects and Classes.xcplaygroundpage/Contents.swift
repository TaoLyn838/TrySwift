//: ## Objects and Classes
//:
//: Use `class` followed by the class’s name to create a class. A property declaration in a class is written the same way as a constant or variable declaration, except that it’s in the context of a class. Likewise, method and function declarations are written the same way.
//:
class Shape {
    var numberOfSides = 0
    func simpleDescription() -> String {
        return "A shape with \(numberOfSides) sides."
    }
    
    
//    Start Experiment
    
    let className = "Shape"
    
    func multipleSides(multiple: Int) -> Void {
        self.numberOfSides = numberOfSides * multiple
    }
    
//    End Experiment
    
}

//: - Experiment:
//: Add a constant property with `let`, and add another method that takes an argument.
//:
//: Create an instance of a class by putting parentheses after the class name. Use dot syntax to access the properties and methods of the instance.
//:
var shape = Shape()
shape.numberOfSides = 7
var shapeDescription = shape.simpleDescription()

shape.className
shape.multipleSides(multiple: 3)
shapeDescription = shape.simpleDescription()
//: This version of the `Shape` class is missing something important: an initializer to set up the class when an instance is created. Use `init` to create one.
//:
class NamedShape {
    var numberOfSides: Int = 0
    var name: String

    init(name: String) {
       self.name = name
    }

    func simpleDescription() -> String {
       return "A shape with \(numberOfSides) sides."
    }
}
//:Notice how `self` is used to distinguish the `name` property from the name argument to the initializer. The arguments to the initializer are passed like a function call when you create an instance of the class. Every property needs a value assigned—either in its declaration (as with `numberOfSides`) or in the initializer (as with `name`).
//:Use `deinit` to create a deinitializer if you need to perform some cleanup before the object is deallocated.

class Bank {
    static var coinsInBank = 10_000
    static func distribute(coins numberOfCoinsRequested: Int) -> Int {
        let numberOfCoinsToVend = min(numberOfCoinsRequested, coinsInBank)
        coinsInBank -= numberOfCoinsToVend
        return numberOfCoinsToVend
    }
    static func receive(coins: Int) {
        coinsInBank += coins
    }
}

class Player {
    var coinsInPurse: Int
    init(coins: Int) {
        coinsInPurse = Bank.distribute(coins: coins)
    }
    func win(coins: Int) {
        coinsInPurse += Bank.distribute(coins: coins)
    }
    deinit {
        Bank.receive(coins: coinsInPurse)
    }
}

var playerOne: Player? = Player(coins: 100)
print("A new player has joined the game with \(playerOne!.coinsInPurse) coins")
// Prints "A new player has joined the game with 100 coins"
print("There are now \(Bank.coinsInBank) coins left in the bank")
// Prints "There are now 9900 coins left in the bank"

//:`deinit` allow user to do something before user to clean up a object. Here set `playerOne` to `nil`, but player's coins will return to bank becasue of `deinit` at line 79-81.
//:
//:
playerOne = nil
print("PlayerOne has left the game")
// Prints "PlayerOne has left the game"
print("The bank now has \(Bank.coinsInBank) coins")
// Prints "The bank now has 10000 coins"
//:Subclasses include their superclass name after their class name, separated by a colon. There’s no requirement for classes to subclass any standard root class, so you can include or omit a superclass as needed.
//:
//:Methods on a subclass that override the superclass’s implementation are marked with `override`—overriding a method by accident, without `override`, is detected by the compiler as an error. The compiler also detects methods with override that don’t actually `override` any method in the superclass.
//:

class Square: NamedShape {
    var sideLength: Double

    init(sideLength: Double, name: String) {
        self.sideLength = sideLength
        super.init(name: name)
        numberOfSides = 4
    }

    func area() -> Double {
        return sideLength * sideLength
    }

    override func simpleDescription() -> String {
        return "A square with sides of length \(sideLength)."
    }
}
let test = Square(sideLength: 5.2, name: "my test square")
test.area()
test.simpleDescription()

//: - Experiment:
//: Make another subclass of `NamedShape` called `Circle` that takes a radius and a name as arguments to its initializer. Implement an `area()` and a `simpleDescription()` method on the `Circle` class.
//:
//: In addition to simple properties that are stored, properties can have a getter and a setter.
//:
class Circle: NamedShape {
    var radius: Double = 0.0
    
    init(name: String, radius: Double) {
        self.radius = radius
        super.init(name: name)
    }
    
    override func simpleDescription() -> String {
        return "A circle with radius \(radius)."
    }
    
    func area() -> Double {
        return (Double.pi * radius * radius)
    }
}
let c1 = Circle(name: "c1", radius: 3.2)

Float(c1.area())

var A:Int = 0
var B:Int = 0

var C: Int {
get {
    return 3
}
set {print("Recived new value", newValue, " and stored into 'B' ")
     B = newValue
     }
}

//:`set`的触发条件是当 `var C` 被赋予一个新值(`newValue`)的时候，就像下面的`C = 4`，如果没有写入`newValue`那么它只会运行`get`的部分。 uncomment line 184 to see the difference.
C = 4

class EquilateralTriangle: NamedShape {
    var sideLength: Double = 0.0

    init(sideLength: Double, name: String) {
        self.sideLength = sideLength
        super.init(name: name)
        numberOfSides = 3
    }

    var perimeter: Double {
        get {
             return 3.0 * sideLength
        }
        // If a computed property’s setter doesn’t define a name for the new value to be set, a default name of newValue is used.
        set {
            sideLength = newValue / 3.0
        }
    }

    override func simpleDescription() -> String {
        return "An equilateral triangle with sides of length \(sideLength)."
    }
}
var triangle = EquilateralTriangle(sideLength: 3.1, name: "a triangle")

// 3.1 * 3.0 (only execute get{...} part because no newValue from input)
print(triangle.perimeter)

// input newValue
triangle.perimeter = 9.9

// 9.9 / 3.0 (do set{...} part)
print(triangle.sideLength)

//: In the setter for `perimeter`, the new value has the implicit name `newValue`. You can provide an explicit name in parentheses after `set`.
//:
//: Notice that the initializer for the `EquilateralTriangle` class has three different steps:
//:
//: 1. Setting the value of properties that the subclass declares.
//:
//: 1. Calling the superclass’s initializer.
//:
//: 1. Changing the value of properties defined by the superclass. Any additional setup work that uses methods, getters, or setters can also be done at this point.
//:
//: If you don’t need to compute the property but still need to provide code that’s run before and after setting a new value, use `willSet` and `didSet`. The code you provide is run any time the value changes outside of an initializer. For example, the class below ensures that the side length of its triangle is always the same as the side length of its square.
//:
class TriangleAndSquare {
    var triangle: EquilateralTriangle {
        willSet {
            square.sideLength = newValue.sideLength
        }
        didSet {
            print("old value = : \(oldValue.sideLength)")
        }
    }
    var square: Square {
        willSet {
            triangle.sideLength = newValue.sideLength
        }
    }
    init(size: Double, name: String) {
        square = Square(sideLength: size, name: name)
        triangle = EquilateralTriangle(sideLength: size, name: name)
    }
}
var triangleAndSquare = TriangleAndSquare(size: 10, name: "another test shape")
print(triangleAndSquare.square.sideLength)
print(triangleAndSquare.triangle.sideLength)
triangleAndSquare.square = Square(sideLength: 50, name: "larger square")
print(triangleAndSquare.triangle.sideLength)
//: Another example of `willSet` and `didSet`
var fooVar = 0 {
  willSet {
    print("willSet: current value: \(fooVar); newValue : \(newValue)")
  }

  didSet {
    print("didSet: current value: \(fooVar); oldValue : \(oldValue)")
  }
}

//    willSet: current value: 0; newValue : 1
//    didSet: current value: 1; oldValue : 0
fooVar = 1
//: When working with optional values, you can write `?` before operations like methods, properties, and subscripting. If the value before the `?` is `nil`, everything after the `?` is ignored and the value of the whole expression is `nil`. Otherwise, the optional value is unwrapped, and everything after the `?` acts on the unwrapped value. In both cases, the value of the whole expression is an optional value.
//:

let optionalSquare: Square? = Square(sideLength: 2.5, name: "optional square")
let sideLength = optionalSquare?.sideLength

sideLength == nil
optionalSquare == nil

class TryQuestionMark {
}

let optionalTryQuestionMark: TryQuestionMark? = nil

optionalTryQuestionMark == nil


//:Using `mutating` to modify the properties of a struct
struct Person {
    var name: String
    
    // if no add nutating here, complier will report an error that "Cannot assign to property: 'self' is immutable"
    mutating func makeAnonymous() {
        name = "Anonymous"
    }
}

var preson = Person(name: "Ed")
preson.makeAnonymous()
//:
//: Note:
//:
//: 1. Marking methods as `mutating` will stop the method from being called on constant structs, even if the method itself doesn’t actually change any properties. If you say it changes stuff, Swift believes you!
//:
//: 1. A method that is not marked as mutating cannot call a `mutating` function – you must mark them both as mutating.
//:
var str: String

str = ""

var checkEmptyStr = str.count == 0
str.hasPrefix("h")
str.uppercased()
str.sorted()

//: What’s the point of static properties and methods in Swift?

struct Unwrap {
    static let UID = "233112"
    
    // what will happen if I remove static (see line 307-310)
    let UUID = "1000001"
    
    static var entropy = Int.random(in: 1...10_000)
    
    // make entropy from "truly random to fair random"
    static func getEntropy() -> Int {
        entropy += 1
        return entropy
    }
    
}

Unwrap.UID

// Cannot call it directly
// Unwrap.UUID
// Should do this
// Unwrap().UUID

//:The app is designed to give you various Swift tests in a random order, but if it were `truly` random then it’s likely you’d see the same question back to back sometimes. I don’t want that, so my entropy actually makes randomness less random so we get a fairer spread of questions
//:
// remove truly random by add entropy value by 1 (see line 299)
Unwrap.getEntropy()

//: What’s the point of access control?
 private var UserSections = Set<String>()

//: If I hadn’t made the UserSections property `private`, it’s possible I might forget and write things to it directly. That would result in my UI being inconsistent with its data, and also not saving the change – bad all around!
//:
//: So, by using `private` here I’m asking Swift to enforce the rules for me: don’t let me read or write this property from anywhere outside the User struct.
//:

//: [Previous](@previous) | [Next](@next)
