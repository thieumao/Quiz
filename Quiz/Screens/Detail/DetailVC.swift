//
//  DetailVC.swift
//  Quiz
//
//  Created by Nguyen Van Thieu on 12/20/18.
//  Copyright © 2018 Nguyen Van Thieu. All rights reserved.
//

import UIKit
import SQLite

class DetailVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

//        let fileManager = FileManager.default
//
//        // Get current directory path
//
//        let path = fileManager.currentDirectoryPath
//        print(path)

        let urlPath = Bundle.main.url(forResource: "db", withExtension: "sqlite3")
//

        guard let db = try? Connection(urlPath?.absoluteString ?? "") else { return }
//        let score = Table("Score")
//        let scoreColumn = Expression<String?>("score")
//        let insert = score.insert(scoreColumn <- "100")
//        let rowid = try? db?.run(insert)
//
//        let value = try? db?.scalar(score.count) ?? 0
//        print("value = \(value)")
        let users = Table("users")
        let id = Expression<Int64>("id")
        let name = Expression<String?>("name")
        let email = Expression<String>("email")

        try! db.run(users.create { t in
            t.column(id, primaryKey: true)
            t.column(name)
            t.column(email, unique: true)
        })
        // CREATE TABLE "users" (
        //     "id" INTEGER PRIMARY KEY NOT NULL,
        //     "name" TEXT,
        //     "email" TEXT NOT NULL UNIQUE
        // )

        let insert = users.insert(name <- "Alice", email <- "alice@mac.com")
        let rowid = try! db.run(insert)
        // INSERT INTO "users" ("name", "email") VALUES ('Alice', 'alice@mac.com')

        for user in try! db.prepare(users) {
            print("id: \(user[id]), name: \(user[name]), email: \(user[email])")
            // id: 1, name: Optional("Alice"), email: alice@mac.com
        }
        // SELECT * FROM "users"

        let alice = users.filter(id == rowid)

        try! db.run(alice.update(email <- email.replace("mac.com", with: "me.com")))
        // UPDATE "users" SET "email" = replace("email", 'mac.com', 'me.com')
        // WHERE ("id" = 1)

        try! db.run(alice.delete())
        // DELETE FROM "users" WHERE ("id" = 1)

        let value = try! db.scalar(users.count) // 0
        // SELECT count(*) FROM "users"
        print("value = \(value)")
    }

}
