# BabyD: A Lightweight Wrapper for BabylonChain Node Management

Babyd is a user-friendly script designed as a lightweight wrapper for the BabylonChain node management, resembling a "baby" version of the `babylond` CLI. It simplifies various operations like staking and balance checking on the BabylonChain network.

## Features

- Execute staking of a predefined amount on multiple or individual wallets.
- Check staking balances for all wallets or a specific one.
- Efficiently manage multiple wallet addresses through an external file.
- Dry-run mode to simulate commands without executing actual transactions.

## Prerequisites

- The `babylond` CLI client should be installed and properly configured on your system.
- A file named `wallets.txt` should be present in the same directory as the script, containing wallet information.

## `wallets.txt` File Format

Each line in the file should follow this format dont use space in wallet name and keep space between arround " : " .

Example:

```
Wallet1 : bbn1fuspxl8q7hlt
Wallet2 : bbn1d57yxx6tql558h8uk46p
Wallet3 : bbn1uaqwsxl
Wallet4 : bbn15g6mzatn
```

## Usage

1. Download or clone the script `babyd.sh` to your machine.
2. Go to the directory containing the script: `cd babyd`.
3. Make the script executable: `chmod +x babyd.sh`.
4. Before running the script, make sure to configure the following parameters in the script itself:
    - `AMOUNT_SEND`: The amount of tokens to stake.
    - `DESTINATION_NODE_DELEGATION`: The destination node address for delegation.
    - `AMOUNT_FEES_DELEGATION_TX`: The fees for the delegation transaction.

   You can edit these parameters in the script.

5. Run the script: `./babyd.sh`.
6. Choose the desired operation from the interactive menu.

## Dry-Run Mode

For a dry-run (simulating commands without actual execution), use:
    
``` 
./babyd.sh --dry-run
```
## Cloning or Downloading BabyD

You can obtain the BabyD script by either cloning the GitHub repository or downloading it directly.

**Option 1: Clone the Repository**

If you have Git installed on your system, you can clone the BabyD repository to get the latest version of the script. Open your terminal and run the following command:

```
git clone https://github.com/defi-school/babyd.git
```

This will create a local copy of the BabyD repository in your current directory.

**Option 2: Download the Script**

Alternatively, you can download the script directly from the repository. Visit the [BabyD GitHub repository](https://github.com/defi-school/babyd) in your web browser. Click on the "Code" button, and then select "Download ZIP." This will download a ZIP archive containing the script to your computer. Extract the contents of the archive to a directory of your choice.

Once you have obtained the script, follow the instructions in the README to make it executable and run it as described in the "Usage" section.

## Contributions

Your contributions, issues, and feature requests are welcome. Feel free to check [issues page](link-to-your-issues-page) for contributing.

## License

[MIT](LICENSE)

## Acknowledgments

- This script is developed independently by Defi-school, the editor of BabyD, and is not affiliated with or connected to [BabylonChain](https://babylonchain.io/).
- Special thanks to the BabylonChain community for their invaluable support and contributions.