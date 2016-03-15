/*:
# CS 190 Problem Set #5&mdash;Protocols and Rot13 Crypto

[Course Home Page]( http://physics.stmarys-ca.edu/classes/CS190_S16/index.html )

[My St. Mary's Home Page]( http://physics.stmarys-ca.edu/lecturers/brianrhill/index.html )

Due: Tuesday, March 15th, 2016.

## Reading that is Related to this Week's Lectures and/or This Problem Set

### An outline of our object-oriented (OO) programming topics

* Inheritance of methods and how they are overridden.
* The difference between run-time binding and compile-time binding.
* BTW, jargon: run-time binding is also called "late binding" or "dynamic binding, and compile-time binding is also called "early binding" or "static binding."
* All the jargon aside, when you get down to brass tacks, the computer has to jump to some block of compiled code when a method is called. It is the language designer's language decision whether the jump that is made is decided at compile time or run time. All modern languages use run-time binding because it is more versatile. C++ is pre-modern, so it is not the default, and they had to graft it in with the [virtual keyword]( http://stackoverflow.com/questions/2391679/why-do-we-need-virtual-methods-in-c ). Their excuse is that run-time binding is computationally more expensive.
* Protocols and how they are in practice less likely to make a mess than multiple inheritance.
* An exposure to how delegation and protocols are used in Apple's UITableViewDataSource and UITableViewDelegate protocols. UITableView is very important, but it is so complex that we'll also do a UITextViewDelegate example.
* Note: delegation is not a language feature. There is no "delegate" keyword. It is just a design pattern that OO kit designers typically use to give you the ability to customize the very complicated UI classes they have created. The alternative for customizing the UI widgets is to subclass them. In practice, delegation more clearly delineates where customization should occur. It doesn't prevent you from also subclassing the widgets.
* We worked together through a UITextViewDelegate example in which the delegate tells the text view to resign first responder when a newline is entered.
* Explain the keywords self and super and how to use them to access and "chain" superclass methods.
* Explain the difference between instance methods and class methods.
* Introduce instance variables and show how they are inherited.
* The difference between instance variables and class variables. Introduce the static keyword.
* Cover a few of the slightly fancier instance variable techniques: getters, setters and computed values. _We didn't get to this or the last bullet point._
* At least mention a much fancier instance variable technique called "property observers" and how a typical pitfall can lead to confusing behavior (or even infinite recursion!).

The primary reference for the object-oriented subject matter we are doing right now is the Chapter titled "Inheritance" in Apple's free book on Swift, [The Swift Programming Language]( https://itunes.apple.com/us/book/swift-programming-language/id881256329 ).

Apple's book is complete, but if you want a more tutorial version (complete with illustrations and short videos) you could look at Kevin McNeish's chapter titled "Inheritance & Polymorphism" in [Learn to Code in Swift]( https://itunes.apple.com/us/book/learn-to-code-in-swift/id942956811 ). That book is not free, but it is a lot better than most of the introductory books, so you might find it to be worth the $25.

If you are going to pay money for a book, the one that will have the longest shelf life if you continue on as a Swift developer is [Advanced Swift]( https://www.objc.io/books/advanced-swift/ ) by Eidhof and Velocity. I lifted a lot of last week's material on arrays and mutability from their chapter titled "Collections". We still have to cover dictionaries and sets which is also in that chapter. That will have to happen after the break as we are full up with all we can handle before then.

### Cryptography

In the problem set directions below, you will see a reference to public key private key cryptography using the Rivest-Shamir-Adleman (RSA) method. Please get yourself ready for Tuesday's class by reading as much of that or any other refernce on RSA cryptography as you can.

We should also in this course at some point look at Diffie-Helman-Merkle key exchange protocol. The greatest things have an element of obviousness in retrospect. Combining public-key/private-cryptography with Diffie-Helman-Merkle key exchange is the foundation of private digital communication.

With NSA-level computing resources, keys of length 1024 bits are becoming breakable. With these methods, but using even larger keys, private conversations can be kept private. For example, iMessage uses these methods with 1280-bit keys and this is documented in the [iOS Security White Paper]( http://www.apple.com/business/docs/iOS_Security_Guide.pdf ). See page 39 of the white paper.

## Directions Specific to this Problem Set

You are going to implement a Rot13 class that adopts the Crypto protocol. Here is the protocol:

*/

protocol Crypto {
    
    // encrypts plain text and returns cipher text
    func encrypt(plainText: String) -> String
    
    // returns the plain text
    func decrypt(cipherText: String) -> String
    
}

/*:

1. (1 pt) Sam Allen has done most of the hard work for us by implementing a [rot13 function]( http://www.dotnetperls.com/rot13-swift ). Copy-and-paste his code into this playground. Make a prominent comment in the code saying that you took it from his website and that all rights are reserved by him. Let's hope he considers the amount we are taking to be fair use.
2. (4 pts) Rot13 class continued. Notice that the playground doesn't even compile. The Rot13 class adopts the Crypto protocol but it doesn't actually implement it. Once you have implemented it it will compile and you can start checking the unit tests to see if your implementation is correct.

For the next problem set, which will be after the break, we are going to implement _the first six sections_ of the Wikibook [A Basic Public Key Example]( https://en.wikibooks.org/wiki/A_Basic_Public_Key_Example ).

Uncomment the following two lines to get started:
*/

// class Rot13: Crypto {
// }

/*:
The rest of this file contains the unit tests that run automatically as you edit the code. You shouldn't have to mess with the unit tests unless I made a mistake writing them.
*/

import XCTest

class Rot13TestSuite: XCTestCase {
    
    // Mary Poppins
    func testRot13EncryptAllCaps() {
        let crypto = Rot13() as Crypto
        let plainText = "SUPERCALIFRAGILISTICEXPIALIDOCIOUS"
        let cipherText = crypto.encrypt(plainText)
        let expectedCipherText = "FHCREPNYVSENTVYVFGVPRKCVNYVQBPVBHF"
        XCTAssertEqual(expectedCipherText, cipherText, "Oh-oh.")
    }

    // Mary Poppins again
    func testRot13EncryptAllLower() {
        let crypto = Rot13() as Crypto
        let plainText = "supercalifragilisticexpialidocious"
        let cipherText = crypto.encrypt(plainText)
        let expectedCipherText = "fhcrepnyvsentvyvfgvprkcvnyvqbpvbhf"
        XCTAssertEqual(expectedCipherText, cipherText, "Oh-oh.")
    }
    
    // Rot13 should have no effect on spaces.
    func testRot13DecryptWithSpaces() {
        let crypto = Rot13() as Crypto
        let cipherText = "super califragilistic expialidocious"
        let plainText = crypto.decrypt(cipherText)
        let expectedPlainText = "fhcre pnyvsentvyvfgvp rkcvnyvqbpvbhf"
        XCTAssertEqual(expectedPlainText, plainText, "Oh-oh.")
    }
    
    // Rot13 should have no effect on Cantonese characters.
    func testRot13DecryptWithCantonese() {
        let crypto = Rot13() as Crypto
        let cipherText = "香港增補字符集"
        let plainText = crypto.decrypt(cipherText)
        let expectedPlainText = "香港增補字符集"
        XCTAssertEqual(expectedPlainText, plainText, "Oh-oh.")
    }
    
}

/*:
The last bit of arcana is necessary to support the execution of unit tests in a playground, but isn't documented in [Apple's XCTest Library]( https://github.com/apple/swift-corelibs-xctest ). I gratefully acknowledge Stuart Sharpe for sharing it in his blog post, [TDD in Swift Playgrounds]( http://initwithstyle.net/2015/11/tdd-in-swift-playgrounds/ ).
*/

class PlaygroundTestObserver : NSObject, XCTestObservation {
    @objc func testCase(testCase: XCTestCase, didFailWithDescription description: String, inFile filePath: String?, atLine lineNumber: UInt) {
        print("Test failed on line \(lineNumber): \(description)")
    }
}

XCTestObservationCenter.sharedTestObservationCenter().addTestObserver(PlaygroundTestObserver())

Rot13TestSuite.defaultTestSuite().runTest()
