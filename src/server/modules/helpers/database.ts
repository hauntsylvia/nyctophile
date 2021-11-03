class Database
{
    constructor()
    {
        let name = ("11-02-2021.A.1")
        print("initialized database: " + name)
        this.database = game.GetService("DataStoreService").GetDataStore(name)
    }
    database: GlobalDataStore
}
export {Database}