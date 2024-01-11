#!/bin/bash

# Define variables
DESTINATION_NODE_DELEGATION="bbnvaloper1wftzqpcyhtdcywscyqax6fl8v6w43wqskd43s0"
AMOUNT_SEND="1000000"
AMOUNT_FEES_DELEGATION_TX="1000ubbn"

# Colors for messages
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Enable dry run mode if requested
DRY_RUN=false
if [ "$1" == "--dry-run" ]; then
    DRY_RUN=true
fi

# Read wallets from a file
read_wallets_from_file() {
    local file_path=$1
    if [[ -f "$file_path" ]]; then
        mapfile -t wallets < "$file_path"
    else
        echo -e "${RED}The file $file_path does not exist.${NC}"
        exit 1
    fi
}

# Path to the file containing wallets
wallets_file="wallets.txt"

# Read wallets
read_wallets_from_file "$wallets_file"

# Function to check staking balances for a wallet
check_staking_balances() {
    local wallet_address=$1
    echo -e "${YELLOW}Checking staking balances for address $wallet_address...${NC}"

    # Execute the command to get delegation details
    staking_output=$(babylond q staking delegations "$wallet_address")

    # Parse the response to get validator_address and shares
    validator_address=$(echo "$staking_output" | grep -oP 'validator_address: \K\S+')
    shares=$(echo "$staking_output" | grep -oP 'shares: "\K\d+')

    # Display the results
    echo -e "${GREEN}Validator: $validator_address"
    echo -e "Stacked Amount: ${shares}ubbn${NC}"
}

# Process wallet for staking
process_wallet_for_staking() {
    local wallet_address=$1
    echo -e "${GREEN}Checking the balance for address $wallet_address...${NC}"

    # Execute the command to get balances
    balance_output=$(babylond q bank balances "$wallet_address")

    # Check if the amount is equal to or greater than AMOUNT_SEND
    if [[ $balance_output == *"amount: \""* && $(echo $balance_output | grep -oP 'amount: "\K\d+') -ge $AMOUNT_SEND ]]; then
        echo -e "${GREEN}Balance is sufficient for delegation.${NC}"

        # Build the command for delegation
        delegate_cmd="babylond tx epoching delegate $DESTINATION_NODE_DELEGATION ${AMOUNT_SEND}ubbn --from $wallet_address --chain-id bbn-test-2 --fees=$AMOUNT_FEES_DELEGATION_TX -y"

        if $DRY_RUN; then
            echo -e "${YELLOW}Dry Run: $delegate_cmd${NC}"
        else
            echo -e "${GREEN}Executing: $delegate_cmd${NC}"
            eval "$delegate_cmd"
        fi
    else
        echo -e "${RED}Insufficient balance for delegation or balance not accessible.${NC}"
    fi
}

# Display the menu
echo "Choose an option:"
echo "1) Execute staking of $AMOUNT_SEND ubbn on all wallets"
echo "2) Execute staking of $AMOUNT_SEND ubbn on a specific wallet"
echo "3) Check staking balances of all wallets"
echo "4) Check the staking balance of a specific wallet"
read -p "Enter your choice (1, 2, 3, or 4): " choice

case $choice in
    1)
        echo "Executing staking on all wallets..."
        for wallet in "${wallets[@]}"; do
            IFS=" : " read -r name address <<< "$wallet"
            process_wallet_for_staking "$address"
        done
        ;;
    2)
        echo "List of available wallets for staking:"
        for ((i = 0; i < ${#wallets[@]}; i++)); do
            echo "$((i + 1))) ${wallets[$i]}"
        done
        read -p "Choose the wallet number for staking: " wallet_number
        if (( wallet_number >= 1 && wallet_number <= ${#wallets[@]} )); then
            IFS=" : " read -r name address <<< "${wallets[$((wallet_number - 1))]}"
            process_wallet_for_staking "$address"
        else
            echo -e "${RED}Invalid wallet number.${NC}"
        fi
        ;;
    3)
        echo "Checking staking balances for all wallets..."
        for wallet in "${wallets[@]}"; do
            IFS=" : " read -r name address <<< "$wallet"
            check_staking_balances "$address"
        done
        ;;
    4)
        echo "List of available wallets for staking balance check:"
        for ((i = 0; i < ${#wallets[@]}; i++)); do
            echo "$((i + 1))) ${wallets[$i]}"
        done
        read -p "Choose the wallet number to check the staking balance: " wallet_number
        if (( wallet_number >= 1 && wallet_number <= ${#wallets[@]} )); then
            IFS=" : " read -r name address <<< "${wallets[$((wallet_number - 1))]}"
            check_staking_balances "$address"
        else
            echo -e "${RED}Invalid wallet number.${NC}"
        fi
        ;;
    *)
        echo -e "${RED}Invalid choice.${NC}"
        ;;
esac
