// 1-ი თასქი ბიბლიოთეკის სიმულაცია. (თავისი ქვეთასქებით).

// 1. შევქმნათ Class Book.
// Properties: bookID(უნიკალური იდენტიფიკატორი Int), String title, String author, Bool isBorrowed.
// Designated Init.
// Method რომელიც ნიშნავს წიგნს როგორც borrowed-ს.
// Method რომელიც ნიშნავს წიგნს როგორც დაბრუნებულს.


// 2. შევქმნათ Class Owner
// Properties: ownerID(უნიკალური იდენტიფიკატორი Int), String name, Books Array სახელით borrowedBooks.
// Designated Init.
// Method რომელიც აძლევს უფლებას რომ აიღოს წიგნი ბიბლიოთეკიდან.
// Method რომელიც აძლევს უფლებას რომ დააბრუნოს წაღებული წიგნი.


// 3. შევქმნათ Class Library
// Properties: Books Array, Owners Array.
// Designated Init.
// Method წიგნის დამატება, რათა ჩვენი ბიბლიოთეკა შევავსოთ წიგნებით.
// Method რომელიც ბიბლიოთეკაში ამატებს Owner-ს.
// Method რომელიც პოულობს და აბრუნებს ყველა ხელმისაწვდომ წიგნს.
// Method რომელიც პოულობს და აბრუნებს ყველა წაღებულ წიგნს.
// Method რომელიც ეძებს Owner-ს თავისი აიდით თუ ეგეთი არსებობს.
// Method რომელიც ეძებს წაღებულ წიგნებს კონკრეტული Owner-ის მიერ.
// Method რომელიც აძლევს უფლებას Owner-ს წააღებინოს წიგნი თუ ის თავისუფალია.

// 4. გავაკეთოთ ბიბლიოთეკის სიმულაცია.
// შევქმნათ რამოდენიმე წიგნი და რამოდენიმე Owner-ი, შევქმნათ ბიბლიოთეკა.
// დავამატოთ წიგნები და Owner-ები ბიბლიოთეკაში
// წავაღებინოთ Owner-ებს წიგნები და დავაბრუნებინოთ რაღაც ნაწილი.
// დავბეჭდოთ ინფორმაცია ბიბლიოთეკიდან წაღებულ წიგნებზე, ხელმისაწვდომ წიგნებზე და გამოვიტანოთ წაღებული წიგნები კონკრეტულად ერთი Owner-ის მიერ.

print("Problem 1")
print("")

class Book {
  let bookID: Int
  var title: String
  var author: String
  var isBorrowed = false

  var description: String {
    return "\(title) by \(author)"
  }

  init(bookID: Int, title: String, author: String) {
    self.bookID = bookID
    self.title = title
    self.author = author
  }

  func markAsBorrowed() {
    isBorrowed = true
  }

  func markAsReturned() {
    isBorrowed = false
  }
}


class Owner {
  var ownerID: Int
  var name: String
  var borrowedBooks: [Book] = []

  init(ownerID: Int, name: String) {
    self.ownerID = ownerID
    self.name = name
  }

  func borrowBookFromLibrary(book: Book) {
    borrowedBooks.append(book)
  }

  func returnBookToLibrary(book: Book) {
    if let index = borrowedBooks.firstIndex(where: { (b: Book) -> Bool in return book.bookID == b.bookID }) {
      book.markAsReturned()
      borrowedBooks.remove(at: index)
    } else {
      print("Error: there no borrowed book with this ID")
    }
  }
}

class Library {
  var books: [Book]
  var owners: [Owner]

  init(books: [Book], owners: [Owner]){
    self.books = books
    self.owners = owners
  }

  func addBook(book: Book) {
    books.append(book)
  }

  func addNOwner(owner: Owner){
    owners.append(owner)
  }

  func findAvailableBooks() -> [Book] {
    books.filter({ (book: Book) -> Bool in return book.isBorrowed == false })
  }

  func findBorrowedBooks() -> [Book] {
    books.filter({ (book: Book) -> Bool in return book.isBorrowed == true })
  }

  func findOwnerById(id: Int) -> Owner? {
    let owner = owners.first(where: { (owner: Owner) -> Bool in return owner.ownerID == id })

    if owner == nil {
      print("There's no such an owner")
    }

    return owner
  }

  func findBooksByOwner(owner: Owner) -> [Book]? {
    if let foundOwner = findOwnerById(id: owner.ownerID) {
      return foundOwner.borrowedBooks
    } else {
      return nil
    }
  }

  func letOwnerBorrowBook(owner: Owner, book: Book) {
    if let foundBook = books.first(where: { (b: Book) -> Bool in return b.bookID == book.bookID }) {
      if foundBook.isBorrowed {
        print("Requested book is already borrowed.")
      } else {
        owner.borrowBookFromLibrary(book: foundBook)
        foundBook.markAsBorrowed()
      }
    } else {
      print("There's no such a book in library.")
    }
  }
  
}

let book1 = Book(bookID: 1, title: "Republic", author: "Plato")
let book2 = Book(bookID: 2, title: "Odyssey", author: "Homer")
let book3 = Book(bookID: 3, title: "Don Quixote", author: "Miguel de Cervantes")

let owner1 = Owner(ownerID: 1, name: "Jotia Tsaava")
let owner2 = Owner(ownerID: 2, name: "Konstantine Gamsakhurdia")
let owner3 = Owner(ownerID: 3, name: "George Bush")

let library = Library(books: [book1, book2], owners: [owner1, owner2])
library.addBook(book: book3)
library.addNOwner(owner: owner3)

print("Available books: \(library.findAvailableBooks().map({ $0.description }))")

library.letOwnerBorrowBook(owner: owner1, book: book2)
library.letOwnerBorrowBook(owner: owner1, book: book3)
print("\(owner1.name) borrowed books '\(book2.title)' and '\(book3.title)'")

library.letOwnerBorrowBook(owner: owner3, book: book1)
print("\(owner3.name) borrowed book '\(book1.title)'")

owner1.returnBookToLibrary(book: book2)
print("\(owner1.name) returend book '\(book2.title)'")

print("Borrowed books: \(library.findBorrowedBooks().map({ $0.description }))")
print("Available books: \(library.findAvailableBooks().map({ $0.description }))")
print("Books borrowed by \(owner1.name): \(library.findBooksByOwner(owner: owner1)?.map({ $0.description }) ?? [])")
print("Books borrowed by \(owner3.name): \(library.findBooksByOwner(owner: owner3)?.map({ $0.description }) ?? [])")

print("")




// 2 თასქი ავაწყოთ პატარა E-commerce სისტემა. (თავისი ქვეთასქებით).

// 1. შევქმნათ Class Product,
// შევქმნათ შემდეგი properties productID (უნიკალური იდენტიფიკატორი Int), String name, Double price.
// შევქმნათ Designated Init.

// 2. შევქმნათ Class Cart
// Properties: cartID(უნიკალური იდენტიფიკატორი Int), Product-ების Array სახელად items.
// შევქმნათ Designated Init.
// Method იმისათვის რომ ჩვენს კალათაში დავამატოთ პროდუქტი.
// Method იმისათვის რომ ჩვენი კალათიდან წავშალოთ პროდუქტი მისი აიდით.
// Method რომელიც დაგვითვლის ფასს ყველა იმ არსებული პროდუქტის რომელიც ჩვენს კალათაშია.

// 3. შევქმნათ Class User
// Properties: userID(უნიკალური იდენტიფიკატორი Int), String username, Cart cart.
// Designated Init.
// Method რომელიც კალათაში ამატებს პროდუქტს.
// Method რომელიც კალათიდან უშლის პროდუქტს.
// Method რომელიც checkout (გადახდის)  იმიტაციას გააკეთებს დაგვითვლის თანხას და გაასუფთავებს ჩვენს shopping cart-ს.

// 4. გავაკეთოთ იმიტაცია და ვამუშაოთ ჩვენი ობიექტები ერთად.
// შევქმნათ რამოდენიმე პროდუქტი.
// შევქმნათ 2 user-ი, თავისი კალათებით,
// დავუმატოთ ამ იუზერებს კალათებში სხვადასხვა პროდუქტები,
// დავბეჭდოთ price ყველა item-ის ამ იუზერების კალათიდან.
// და ბოლოს გავაკეთოთ სიმულაცია ჩექაუთის, დავაბეჭდინოთ იუზერების გადასხდელი თანხა და გავუსუფთაოთ კალათები.

print("Problem 2")
print("")

class Product {
  let productID: Int
  var name: String
  var price: Double

  init(productID: Int, name: String, price: Double){
    self.productID = productID
    self.name = name
    self.price = price
  }
}

class Cart {
  let cartID: Int
  var items: [Product] = []

  var isEmpty: Bool {
    return items.count == 0
  }

  init(cartID: Int) {
    self.cartID = cartID
  }

  func addItemToCart(product: Product) {
     items.append(product)
  }

  func removeItemById(productId: Int) {
    if let index = items.firstIndex(where: { $0.productID == productId }) {
      items.remove(at: index)
    } else {
      print("Thedre's no product with this ID.")
    }
  }

  func getTotal() -> Double {
    items.reduce(0, { (sum: Double, item: Product) -> Double in return sum + item.price })
  }

  func removeAllItems() {
    items = []
  }
}

class User {
  let userID: Int
  var userName: String
  var cart: Cart

  init(userID: Int, userName: String, cart: Cart) {
    self.userID = userID
    self.userName = userName
    self.cart = cart
  }

  func addProductToCart(item: Product) {
    cart.addItemToCart(product: item)
  }

  func removeProductFromCart(item: Product) {
    cart.removeItemById(productId: item.productID)
  }

  func checkout() {
    if cart.isEmpty {
      print("The cart is empty")
    } else {
      print("Total price: \(cart.getTotal())")
      cart.removeAllItems()
    }
  }
}

let product1 = Product(productID: 1, name: "Shampoo", price: 5.00)
let product2 = Product(productID: 2, name: "Jacket", price: 120.00)
let product3 = Product(productID: 3, name: "Dress", price: 68.00)
let product4 = Product(productID: 4, name: "Boots", price: 150.00)

let user1 = User(userID: 1, userName: "Sofoetno", cart: Cart(cartID: 1))
let user2 = User(userID: 2, userName: "Serafita", cart: Cart(cartID: 2))

user1.addProductToCart(item: product1)
user1.addProductToCart(item: product4)

user2.addProductToCart(item: product2)
user2.addProductToCart(item: product3)

print("Prices for \(user1.userName) cart:")
print(user1.cart.items.map({"\($0.name) costs \($0.price) Gel"}))

print("Prices for \(user2.userName) cart:")
print(user2.cart.items.map({"\($0.name) costs \($0.price) Gel"}))
print("")

print("Checkout process for \(user1.userName)")
print("Cart is empty before checkout: \(user1.cart.isEmpty)")
user1.checkout()
print("Cart is empty after checkout: \(user1.cart.isEmpty)")

print("")

print("Checkout process for \(user2.userName)")
print("Cart is empty before checkout: \(user2.cart.isEmpty)")
user2.checkout()
print("Cart is empty after checkout: \(user2.cart.isEmpty)")
