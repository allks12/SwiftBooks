import Fluent
import Vapor

// ==========================================
// 1. ИСТИНСКИ МОДЕЛ ЗА ТАБЛИЦА "BOOKS"
// ==========================================
final class Book: Model, Content, @unchecked Sendable {
    static let schema = "books"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "book_id") // Числото 1, 2, 3 за линковете
    var bookId: Int

    @Field(key: "title")
    var title: String

    @Field(key: "author")
    var author: String

    @Field(key: "price")
    var price: String

    @Field(key: "image")
    var image: String

    @Field(key: "description")
    var description: String

    init() { }

    init(id: UUID? = nil, bookId: Int, title: String, author: String, price: String, image: String, description: String) {
        self.id = id
        self.bookId = bookId
        self.title = title
        self.author = author
        self.price = price
        self.image = image
        self.description = description
    }
}

// ==========================================
// 2. ИСТИНСКИ МОДЕЛ ЗА ТАБЛИЦА "ORDERS"
// ==========================================
final class Order: Model, Content, @unchecked Sendable {
    static let schema = "orders"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "customer_name")
    var customerName: String

    @Field(key: "customer_phone")
    var customerPhone: String

    @Field(key: "customer_address")
    var customerAddress: String

    @Field(key: "book_title")
    var bookTitle: String

    init() { }

    init(id: UUID? = nil, customerName: String, customerPhone: String, customerAddress: String, bookTitle: String) {
        self.id = id
        self.customerName = customerName
        self.customerPhone = customerPhone
        self.customerAddress = customerAddress
        self.bookTitle = bookTitle
    }
}

// ==========================================
// 3. МИГРАЦИЯТА ЗА SQLite
// ==========================================
struct CreateBooksAndOrders: AsyncMigration {
    func prepare(on database: any Database) async throws {
        // Създаваме таблицата за книгите
        try await database.schema("books")
            .id()
            .field("book_id", .int, .required)
            .field("title", .string, .required)
            .field("author", .string, .required)
            .field("price", .string, .required)
            .field("image", .string, .required)
            .field("description", .string, .required)
            .create()

        // Създаваме таблицата за поръчките
        try await database.schema("orders")
            .id()
            .field("customer_name", .string, .required)
            .field("customer_phone", .string, .required)
            .field("customer_address", .string, .required)
            .field("book_title", .string, .required)
            .create()

        // Пълним автоматично 16-те книги в базата данни
        let defaultBooks = [
            Book(bookId: 1, title: "A Court of Thorns and Roses", author: "Sarah J. Maas", price: "15.00 EUR", image: "/book1.jpg", description: "When nineteen-year-old huntress Feyre kills a wolf in the woods, a beast-like creature arrives to demand retribution. Dragged to a treacherous magical land she only knows about from legends, Feyre discovers that her captor is not truly a beast, but one of the lethal, immortal faeries who once ruled their world. As she dwells on his estate, her feelings for the faerie, Tamlin, transform from icy hostility into a fiery passion that burns through every lie and warning she’s been told about the beautiful, dangerous world of the Fae. But an ancient, wicked shadow over the faerie lands is growing, and Feyre must find a way to stop it . . . or doom Tamlin—and his world—forever."),
            Book(bookId: 2, title: "Throne of Glass", author: "Sarah J. Maas", price: "15.00 EUR", image: "/book2.jpg", description: "In a land without magic, an assassin is summoned to the castle. She has no love for the vicious king who rules from his throne of glass, but she has not come to kill him. She has come to win her freedom. If she defeats twenty-three murderers, thieves, and warriors in a competition, she will be released from prison to serve as the King’s Champion. Her name is Celaena Sardothien. The Crown Prince will provoke her. The Captain of the Guard will protect her. And a princess from a faraway country will befriend her. But something rotten dwells in the castle, and it’s there to kill. When her competitors start dying mysteriously, one by one, Celaena’s fight for freedom becomes a fight for survival-and a desperate quest to root out the evil before it destroys her world."),
            Book(bookId: 3, title: "A Court of Mist and Fury", author: "Sarah J. Maas", price: "16.00 EUR", image: "/book3.jpg", description: "Feyre survived Amarantha’s clutches to return to the Spring Court–but at a steep cost. Though she now has the powers of the High Fae, her heart remains human, and it can’t forget the terrible deeds she performed to save Tamlin’s people. Nor has Feyre forgotten her bargain with Rhysand, High Lord of the feared Night Court. As Feyre navigates its dark web of politics, passion, and dazzling power, a greater evil looms—and she might just be key to stopping it. But only if she can harness her harrowing gifts, heal her fractured soul, and decide how she wishes to shape her future—and the future of a world cleaved in two."),
            Book(bookId: 4, title: "A Court of Wings and Ruin", author: "Sarah J. Maas", price: "17.00 EUR", image: "/book4.jpg", description: "Feyre has returned to the Spring Court, determined to gather information on Tamlin’s actions and learn what she can about the invading king threatening to bring Prythian to its knees. But to do so she must play a deadly game of deceit. One slip may spell doom not only for Feyre, but for her world as well. As war bears down upon them all, Feyre must decide whom to trust among the dazzling and lethal High Lords, and hunt for allies in unexpected places."),
            Book(bookId: 5, title: "A Court of Frost and Starlight", author: "Sarah J. Maas", price: "19.00 EUR", image: "/book5.jpg", description: "Narrated by Feyre and Rhysand, this story bridges the events in A Court of Wings and Ruin and the upcoming novels in the series. Feyre, Rhys and their friends are still busy rebuilding the Night Court and the vastly changed world beyond. But the Winter Solstice is finally near, and with it a hard-earned reprieve. Yet even the festive atmosphere can’t keep the shadows of the past from looming. As Feyre navigates her first Winter Solstice as High Lady, she finds that those dearest to her have more wounds than she anticipated—scars that will have a far-reaching impact on the future of their court."),
            Book(bookId: 6, title: "A Court of Silver flames", author: "Sarah J. Maas", price: "16.00 EUR", image: "/book6.jpg", description: "Nesta Archeron has always been prickly—proud, swift to anger, and slow to forgive. And ever since being forced into the Cauldron and becoming High Fae against her will, she’s struggled to find a place for herself within the strange, deadly world she inhabits. Worse, she can’t seem to move past the horrors of the war with Hybern and all she lost in it. The one person who ignites her temper more than any other is Cassian, the battle-scarred warrior whose position in Rhysand and Feyre’s Night Court keeps him constantly in Nesta’s orbit. But her temper isn’t the only thing Cassian ignites. The fire between them is undeniable, and only burns hotter as they are forced into close quarters with each other. Meanwhile, the treacherous human queens who returned to the Continent during the last war have forged a dangerous new alliance, threatening the fragile peace that has settled over the realms. And the key to halting them might very well rely on Cassian and Nesta facing their haunting pasts."),
            Book(bookId: 7, title: "Crown of Midnight", author: "Sarah J. Maas", price: "15.00 EUR", image: "/book7.jpg", description: "Celaena Sardothien won a brutal contest to become the King’s Champion. But she is far from loyal to the crown. Though she goes to great lengths to hide her secret, her deadly charade becomes more difficult when she realizes she is not the only one seeking justice. Her search for answers ensnares those closest to her, and no one is safe from suspicion-not the Crown Prince Dorian; not Chaol, the Captain of the Guard; not even her best friend, Nehemia, a princess with a rebel heart. Then, one terrible night, the secrets they have all been keeping lead to an unspeakable tragedy. As Celaena’s world shatters, she will be forced to decide once and for all where her true loyalties lie . . . and what she is willing to fight for."),
            Book(bookId: 8, title: "The Assassin`s blade", author: "Sarah J. Maas", price: "18.00 EUR", image: "/book8.jpg", description: "Celaena Sardothien is her kingdom’s most feared assassin. Though she works for the powerful Assassin’s Guild and its scheming master, Arobynn Hamel, she yields to no one and trusts only her fellow killer-for-hire, Sam. But when Arobynn dispatches her on missions that take her from remote islands to hostile deserts, Celaena finds herself acting independently of his wishes and questioning her own allegiance. If she hopes to escape Arobynn’s clutches, Celaena will have to put her faith in her wits and her blade . . . knowing that if she fails, she’ll lose not just a chance at freedom but her life."),
            Book(bookId: 9, title: "Heir of Fire", author: "Sarah J. Maas", price: "17.00 EUR", image: "/book9.jpg", description: "Celaena Sardothien has survived deadly contests and shattering heartbreak, but now she must travel to a new land to confront her darkest truth. That truth could change her life-and her future-forever. Meanwhile, monstrous forces are gathering on the horizon, intent on enslaving her world. To defeat them, Celaena will need the strength not only to fight the evil that is about to be unleashed but also to harness her inner demons. If she is to win this battle, she must find the courage to face her destiny-and burn brighter than ever before."),
            Book(bookId: 10, title: "Queen of Shadows", author: "Sarah J. Maas", price: "15.00 EUR", image: "/book10.jpg", description: "Celaena Sardothien has embraced her identity as Aelin Galathynius, Queen of Terrasen. But before she can reclaim her throne, she must fight. She will fight for her cousin, a warrior prepared to die for her. She will fight for her friend, a young man trapped in an unspeakable prison. And she will fight for her people, enslaved to a brutal king and awaiting their lost queen’s triumphant return.Everyone Aelin loves has been taken from her. Everything she holds dear is in danger. But she has the heart of a queen-and that heart beats for vengeance."),
            Book(bookId: 11, title: "Empire of Storms", author: "Sarah J. Maas", price: "19.00 EUR", image: "/book11.jpg", description: "The long path to the throne has only just begun for Aelin Galathynius as war looms on the horizon. Loyalties have been broken and bought, friends have been lost and gained, and those who possess magic find themselves increasingly at odds with those who don’t. With her heart sworn to the warrior-prince by her side and her fealty pledged to the people she is determined to save, Aelin will delve into the depths of her power to protect those she loves. But as monsters emerge from the horrors of the past, dark forces stand poised to claim her world. The only chance for salvation lies in a desperate quest that may take more from Aelin than she has to give, a quest that forces her to choose what-and who-she’s willing to sacrifice for the sake of peace."),
            Book(bookId: 12, title: "Tower of Dawn", author: "Sarah J. Maas", price: "16.00 EUR", image: "/book12.jpg", description: "Chaol Westfall and Nesryn Faliq have arrived in the shining city of Antica to forge an alliance with the Khagan of the Southern Continent, whose vast armies are Erilea’s last hope. But they have also come to Antica for another purpose: to seek healing at the famed Torre Cesme for the wounds Chaol received in Rifthold. After enduring unspeakable horrors as a child at the hands of Adarlanian soldiers, Yrene Towers has no desire to help the young lord from Adarlan, let alone heal him. Yet she has sworn an oath to assist those in need, and she will honor it. But Lord Westfall carries his own dark past, and Yrene soon realizes that those shadows could engulf them both. Chaol, Nesryn, and Yrene will have to draw on every scrap of their resilience to overcome the danger that surrounds them. But while they become entangled in the political webs of the khaganate, long-awaited answers slumber deep in the mountains, where warriors soar on legendary ruks. Answers that might offer their world a chance at survival . . . or doom them all."),
            Book(bookId: 13, title: "Kingdom of Ash", author: "Sarah J. Maas", price: "17.00 EUR", image: "/book13.jpg", description: "Aelin Galathynius has vowed to save her people—but at a tremendous cost. Locked in an iron coffin by the Queen of the Fae, Aelin must draw upon her fiery will as she endures months of torture. The knowledge that yielding to Maeve will doom those she loves keeps her from breaking, but her resolve unravels with each passing day. With Aelin captured, her friends and allies have scattered. Some bonds will grow even deeper, while others will be severed forever. But as destinies weave together at last, all must stand together if Erilea is to have any hope of salvation."),
            Book(bookId: 14, title: "House of Earth and Blood", author: "Sarah J. Maas", price: "18.00 EUR", image: "/book14.jpg", description: "Bryce Quinlan had the perfect life—working hard all day and partying all night—until a demon murdered her closest friends, leaving her bereft, wounded, and alone. When the accused is behind bars but the crimes start up again, Bryce finds herself at the heart of the investigation. She’ll do whatever it takes to avenge their deaths. Hunt Athalar is a notorious Fallen angel, now enslaved to the Archangels he once attempted to overthrow. His brutal skills and incredible strength have been set to one purpose—to assassinate his boss’s enemies, no questions asked. But with a demon wreaking havoc in the city, he’s offered an irresistible deal: help Bryce find the murderer, and his freedom will be within reach. As Bryce and Hunt dig deep into Crescent City’s underbelly, they discover a dark power that threatens everything and everyone they hold dear, and they find, in each other, a blazing passion—one that could set them both free, if they’d only let it."),
            Book(bookId: 15, title: "House of Sky and Breath", author: "Sarah J. Maas", price: "15.00 EUR", image: "/book15.jpg", description: "Bryce Quinlan and Hunt Athalar are trying to get back to normal—they may have saved Crescent City, but with so much upheaval in their lives lately, they mostly want a chance to relax. Slow down. Figure out what the future holds. The Asteri have kept their word so far, leaving Bryce and Hunt alone. But with the rebels chipping away at the Asteri’s power, the threat the rulers pose is growing. As Bryce, Hunt, and their friends get pulled into the rebels’ plans, the choice becomes clear: stay silent while others are oppressed or fight for what’s right. And they’ve never been very good at staying silent."),
            Book(bookId: 16, title: "House of Flame and Shadows", author: "Sarah J. Maas", price: "15.00 EUR", image: "/book16.jpg", description: "Bryce Quinlan never expected to see a world other than Midgard, but now that she has, all she wants is to get back. Everything she loves is in Midgard: her family, her friends, her mate. Stranded in a strange new world, she's going to need all her wits about her to get home again. And that's no easy feat when she has no idea who to trust. Hunt Athalar has found himself in some deep holes in his life, but this one might be the deepest of all. After a few brief months with everything he ever wanted, he's in the Asteri's dungeons again, stripped of his freedom and without a clue as to Bryce's fate. He's desperate to help her, but until he can escape the Asteri's leash, his hands are quite literally tied.")
        ]

        for book in defaultBooks {
            try await book.create(on: database)
        }
    }

    func revert(on database: any Database) async throws {
        try await database.schema("books").delete()
        try await database.schema("orders").delete()
    }
}

// ==========================================
// 4. МАРШРУТИ (ROUTES ДИРЕКТНО СЪС SQLite)
// ==========================================
func routes(_ app: Application) throws {

    // А. НАЧАЛНА СТРАНИЦА - Чете книгите от базата и филтрира през SQL
    app.get { req async throws -> View in
        let searchTerm: String? = req.query["search"]

        let query = Book.query(on: req.db)

        if let search = searchTerm, !search.isEmpty {
            // Търси чрез SQL LIKE заявка
            query.filter(\.$title, .custom("LIKE"), "%\(search)%")
        }

        let allBooks = try await query.sort(\.$bookId, .ascending).all()
        return try await req.view.render("index", ["books": allBooks])
    }

    // Б. ДЕТАЙЛИ НА КНИГАТА - Търси в базата по числото bookId
    app.get("book", ":bookID") { req async throws -> View in
        guard let bookIDString = req.parameters.get("bookID"),
              let idQuery = Int(bookIDString) else {
            throw Abort(.badRequest)
        }

        guard let book = try await Book.query(on: req.db)
            .filter(\.$bookId == idQuery)
            .first() else {
                throw Abort(.notFound)
        }

        return try await req.view.render("bookDetails", book)
    }

    // В. ПОКУПКА - Записва новата поръчка директно в таблицата "orders"
    app.post("submit-order") { req async throws -> View in
        struct InputOrder: Content {
            let customerName: String
            let customerPhone: String
            let customerAddress: String
            let bookTitle: String
        }

        let input = try req.content.decode(InputOrder.self)

        let newOrder = Order(
            customerName: input.customerName,
            customerPhone: input.customerPhone,
            customerAddress: input.customerAddress,
            bookTitle: input.bookTitle
        )

        // Записваме я в SQLite!
        try await newOrder.create(on: req.db)
        return try await req.view.render("orderSuccess", newOrder)
    }

    try app.register(collection: TodoController())
}
