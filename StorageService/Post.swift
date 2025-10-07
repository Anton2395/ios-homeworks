//
//  File.swift
//  Navigation
//
//  Created by Toha Shilin on 25.07.25.
//

public struct Post {
    public let author: String
    public let description: String
    public let image: String
    public var likes: Int
    public var views: Int
    
    public init(author: String, description: String, image: String, likes: Int, views: Int) {
        self.author = author
        self.description = description
        self.image = image
        self.likes = likes
        self.views = views
    }
}

extension Post {
    public static func make() -> [Post] {
        return [
            Post(
                author: "anton1",
                description: """
                Travis Scott представил проект JACKBOYS 2
                
                JACKBOYS — группа, в которую входит Travis Scott и артисты его лейбла Cactus Jack (среди них Don Toliver, Sheck Wes, SoFaygo и Wallie The Sensei). Всего в альбом вошло 17 песен, среди них коллабы с GloRilla, Tyla, 21 Savage и другими.
                """,
                image: "PostFirst",
                likes: 0,
                views: 10
            ),
            Post(
                author: "anton2",
                description: """
                sombr выпустил песню 12 to 12 

                Восходящий инди-поп музыкант представил новый сингл. Наверняка дело идёт к дебютному альбому, поскольку синглов у артиста накопилось уже прилично.
                """,
                image: "PostSecond",
                likes: 0,
                views: 10
            ),
            Post(
                author: "anton3",
                description: """
                Sam Smith выпустил песню To Be Free 

                Британский артист представляет камбэк-сингл. Эта песня была записана ещё в 2020-м году, выпустить решили лишь сейчас. 

                Последний альбом артиста вышел два с половиной года назад. Готовится ли он к новому? Пока непонятно.
                """,
                image: "PostThird",
                likes: 0,
                views: 10
            ),
            Post(
                author: "anton4",
                description: """
                Tame Impala представил сингл End Of Summer 

                Австралийский музыкант выпустил первую за пять лет сольную песню (не считая саундтрека к Барби). В социальных сетях артист написал, что этот сингл открывает эру его пятого альбома.
                """,
                image: "PostFourth",
                likes: 0,
                views: 10
            ),
        ]
    }
}
