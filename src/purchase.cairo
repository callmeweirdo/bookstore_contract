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
        
    }
}