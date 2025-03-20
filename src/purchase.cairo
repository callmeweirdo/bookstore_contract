#[starknet::contract]
mod Purchase {
    use starknet::ContractAddress;
    use starknet::get_caller_address;
    use starknet::storage::Storage;

    #[storage]
    struct Storage{
        bookstore: ContractAddress
    }

    #[constructor]
    fn constructor(ref self: ContractState, bookstore: ContractAddress){
        self.bookstore.write(bookstore);
    }

    #[external]
    fn buy_book(
        ref self: ContractState,
        id:felt252,
        quantity: u8,
    ){
        let bookstore = self.bookstore.read();
        let caller = self.get_caller_address();

        // call the bookstore contract to get the book details
        let book = self.dispatcher(bookstore).get_book(id);

        // check if the book is available in sufficient quantity
        assert(book.quantity >= quantity, "Insufficient quantity");

        // update the book quantity in the Bookstore contract
        self.dispatcher(bookstore).update_book(
            id,
            book.title,
            book.author,
            book.description,
            book.price,
            book.quantity - quantity
        );

        // Emit an event for the puchase
        self.emit(BookPurchased {buyer:caller, book_id: id, quantity});

        #[event]
        #[derive(Drop, Starknet::Event)]
        enum Event{
            BookPurchased: BookPurchased,
        }

        #[derive(Drop, Serde)]
        struct BookPurchased{
            buyrer: ContractAddress,
            book_id: felt252,
            quantity: u8,
        }
    }
}