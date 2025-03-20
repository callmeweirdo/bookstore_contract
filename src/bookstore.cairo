#[starknet::contract]

mod Bookstore{
    use starknet::ContractAddress;
    use starknet::get_caller_address;
    use starknet::storage::Storage;

    #[storage]
    struct Storage {
        books: LegacyMap<felt252, Book>,
        owser: ContractAddress,
    }

    #[derive(Drop, Serde)]
    struct Book {
        title: felt252,
        author: felt252,
        description: felt252,
        price: u16,
        quantity: u8
    }

    #[constructor]
    fn constructor(ref self: ContractState, owner: ContractAddress){
        self.owner.write(owner);
    }

    #[external]
    fn add_book(
        ref self: ContractState,
        id: felt252,
        title: felt252,
        author: felt252,
        description: felt252,
        price: u16,
        quantity: u8,
    ){
        assert(self.owner.read() == get_caller_address(), "Only Owner can add books");
        let book = Book {title, author, description, price, quantity};
    }

    #[external]
    fn update_book(
        ref self: ContractState,
        id: felt252,
        title: felt252,
        author: felt252,
        description: felt252,
        price: felt252,
        quantity: u8
    )
        {
        assert(self.owner.read() == get_caller_address(), "Only Owner can update books")
        let book = Book {title, author, decsription, price, quantity}
        self.books.write(id, book);
    }

    #[external]
    fn remove_book(
        ref self: ContractState,
        id: felt252
    ){
        assert(self.owner.read() == get_caller_address(), "Only owners can remove books"){
            self.books.write(id, Option::None);
        }
    }

    #[view]
    fn get_book(self: @ContractState, id: felt252) -> Book {
        self.books.read(id).unwrap();
    }

}