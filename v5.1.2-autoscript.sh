#!/bin/bash
LOG_FILE="/var/log/layer_node_install.log"
exec > >(tee -a "$LOG_FILE") 2>&1

printGreen() {
    echo -e "\033[32m$1\033[0m"
}

printLine() {
    echo "------------------------------"
}

# Function to print the node logo
function printNodeLogo {
    echo -e "\033[32m"
    echo "          
████████████████████████████████████████████████████████████████████████████████████████████████████
████████████████████████████████████████████████████████████████████████████████████████████████████
████████████████████████████████████████████████████████████████████████████████████████████████████
████████████████████████████████████████████████████████████████████████████████████████████████████
████████████████████████████████████████████████████████████████████████████████████████████████████
████████████████████████████████████████████████████████████████████████████████████████████████████
████████████████████████████████████████████████████████████████████████████████████████████████████
████████████████████████████████████████████████████████████████████████████████████████████████████
████████████████████████████████████████████████████████████████████████████████████████████████████
████████████████████████████████████████████████████████████████████████████████████████████████████
████████████████████████████████████████████████████████████████████████████████████████████████████
████████████████████████████████████████████████████████████████████████████████████████████████████
████████████████████████████████████████████████████████████████████████████████████████████████████
████████████████████████████████████████████████████████████████████████████████████████████████████
██████████████████████████████████████████████        ██████████████████████████████████████████████
███████████████████████████████████████████              ███████████████████████████████████████████
████████████████████████████████████████                    ████████████████████████████████████████
█████████████████████████████████████                          █████████████████████████████████████
█████████████████████████████████                                  █████████████████████████████████
██████████████████████████████             █             █            ██████████████████████████████
████████████████████████████           █████             ████           ████████████████████████████
████████████████████████████          ██████             ██████         ████████████████████████████
████████████████████████████          ██████             ██████          ███████████████████████████
████████████████████████████          ███████            ██████          ███████████████████████████
████████████████████████████          ██████████         ██████          ███████████████████████████
████████████████████████████          █████████████      ██████          ███████████████████████████
████████████████████████████             █████████████     ████          ███████████████████████████
████████████████████████████          █     █████████████     █          ███████████████████████████
████████████████████████████          █████     ████████████             ███████████████████████████
████████████████████████████          ██████       ████████████          ███████████████████████████
████████████████████████████          ██████          █████████          ███████████████████████████
████████████████████████████          ██████             ██████          ███████████████████████████
████████████████████████████          ██████             ██████          ███████████████████████████
████████████████████████████          ██████             ██████         ████████████████████████████
████████████████████████████            ████             ███            ████████████████████████████
██████████████████████████████                                        ██████████████████████████████
█████████████████████████████████                                  █████████████████████████████████
█████████████████████████████████████                           ████████████████████████████████████
████████████████████████████████████████                    ████████████████████████████████████████
███████████████████████████████████████████              ███████████████████████████████████████████
██████████████████████████████████████████████        ██████████████████████████████████████████████
████████████████████████████████████████████████████████████████████████████████████████████████████
████████████████████████████████████████████████████████████████████████████████████████████████████
████████████████████████████████████████████████████████████████████████████████████████████████████
████████████████████████████████████████████████████████████████████████████████████████████████████
████████████████████████████████████████████████████████████████████████████████████████████████████
████████████████████████████████████████████████████████████████████████████████████████████████████
████████████████████████████████████████████████████████████████████████████████████████████████████
████████████████████████████████████████████████████████████████████████████████████████████████████
████████████████████████████████████████████████████████████████████████████████████████████████████
████████████████████████████████████████████████████████████████████████████████████████████████████
████████████████████████████████████████████████████████████████████████████████████████████████████
████████████████████████████████████████████████████████████████████████████████████████████████████
████████████████████████████████████████████████████████████████████████████████████████████████████
████████████████████████████████████████████████████████████████████████████████████████████████████
Hazen Network Solutions 2025 All rights reserved."
    echo -e "\033[0m"
}

# Show the node logo
printNodeLogo

# User confirmation to proceed
echo -n "Type 'yes' to start the installation Tellor Mainnet v5.1.2 and press Enter: "
read user_input

if [[ "$user_input" != "yes" ]]; then
  echo "Installation cancelled."
  exit 1
fi

# Function to print in green
printGreen() {
  echo -e "\033[32m$1\033[0m"
}

printGreen "Starting installation..."
sleep 1

printGreen "If there are any, clean up the previous installation files"

sudo systemctl stop layerd
sudo systemctl disable layerd
sudo rm -rf /etc/systemd/system/layerd.service
sudo rm $(which layerd)
sudo rm -rf $HOME/.layer
sed -i "/LAYER_/d" $HOME/.bash_profile

# Update packages and install dependencies
printGreen "1. Updating and installing dependencies..."
sudo apt update && sudo apt upgrade -y
sudo apt install curl git wget htop tmux build-essential jq make lz4 gcc unzip screen btop iotop nethogs hdparm -y
sudo apt install -y curl git jq lz4 build-essential cmake perl automake autoconf libtool wget libssl-dev -y

# User inputs
read -p "Enter your MONIKER: " MONIKER
echo 'export MONIKER='$MONIKER
read -p "Enter your PORT (2-digit): " PORT
echo 'export PORT='$PORT

# Setting environment variables
echo "export MONIKER=$MONIKER" >> $HOME/.bash_profile
echo "export LAYER_CHAIN_ID=\"tellor-1\"" >> $HOME/.bash_profile
echo "export LAYER_PORT=$PORT" >> $HOME/.bash_profile
source $HOME/.bash_profile

printLine
echo -e "Moniker:        \e[1m\e[32m$MONIKER\e[0m"
echo -e "Chain ID:       \e[1m\e[32m$LAYER_CHAIN_ID\e[0m"
echo -e "Node custom port:  \e[1m\e[32m$LAYER_PORT\e[0m"
printLine
sleep 1

# Install Go
cd $HOME
VER="1.23.0"
wget "https://golang.org/dl/go$VER.linux-amd64.tar.gz"
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf "go$VER.linux-amd64.tar.gz"
rm "go$VER.linux-amd64.tar.gz"
[ ! -f ~/.bash_profile ] && touch ~/.bash_profile
echo 'export PATH=/usr/local/go/bin:$HOME/go/bin:$PATH' >> ~/.bash_profile
source $HOME/.bash_profile
[ ! -d ~/go/bin ] && mkdir -p ~/go/bin
export PATH="$HOME/go/bin:$PATH"

# Version check
echo $(go version) && sleep 1

# Download Prysm protocol binary
printGreen "3. Downloading Tellor binary and setting up..." && sleep 1
cd $HOME
mkdir -p $HOME/.layer/cosmovisor/upgrades/v5.1.2/bin

wget https://github.com/tellor-io/layer/releases/download/v5.1.2/layer_Linux_x86_64.tar.gz
tar -xvf layer_Linux_x86_64.tar.gz

sudo mv layerd $HOME/.layer/cosmovisor/upgrades/v5.1.2/bin/
chmod +x $HOME/.layer/cosmovisor/upgrades/v5.1.2/bin/layerd

sudo ln -sfn $HOME/.layer/cosmovisor/upgrades/v5.1.2 $HOME/.layer/cosmovisor/current
sudo ln -sfn $HOME/.layer/cosmovisor/current/bin/layerd /usr/local/bin/layerd

go install cosmossdk.io/tools/cosmovisor/cmd/cosmovisor@v1.6.0

# Create service file
sudo bash -c "cat > /etc/systemd/system/layerd.service" << EOF
[Unit]
Description=Tellor node service
After=network-online.target

[Service]
User=$USER
ExecStart=$(which cosmovisor) run start --home $HOME/.layer --keyring-backend test  --key-name $TELLOR_WALLET --api.enable --api.swagger
Restart=on-failure
RestartSec=10
LimitNOFILE=65535
Environment="DAEMON_HOME=$HOME/.layer"
Environment="DAEMON_NAME=layerd"
Environment="UNSAFE_SKIP_BACKUP=true"
Environment="PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:$HOME/.layer/cosmovisor/current/bin"

[Install]
WantedBy=multi-user.target
EOF

# Enable the service
sudo systemctl daemon-reload
sudo systemctl enable layerd

# Initialize the node
printGreen "7. Initializing the node..."
layerd config node tcp://localhost:${LAYER_PORT}657
layerd config keyring-backend os
layerd config chain-id tellor-1
layerd init $MONIKER --chain-id tellor-1

# Download genesis and addrbook files
printGreen "8. Downloading genesis and addrbook..."
wget -O $HOME/.layer/config/genesis.json https://raw.githubusercontent.com/hazennetworksolutions/tellor-mainnet/refs/heads/main/genesis.json
wget -O $HOME/.layer/config/addrbook.json https://raw.githubusercontent.com/hazennetworksolutions/tellor-mainnet/refs/heads/main/addrbook.json


# Configure gas prices and ports
printGreen "9. Configuring custom ports and gas prices..." && sleep 1
sed -i 's|minimum-gas-prices =.*|minimum-gas-prices = "0loya"|g' $HOME/.layer/config/app.toml
sed -i -e "s/prometheus = false/prometheus = true/" $HOME/.layer/config/config.toml
sed -i -e "s/^indexer *=.*/indexer = \"null\"/" $HOME/.layer/config/config.toml

sed -i.bak -e "s%:1317%:${LAYER_PORT}317%g;
s%:8080%:${LAYER_PORT}080%g;
s%:9090%:${LAYER_PORT}090%g;
s%:9091%:${LAYER_PORT}091%g;
s%:8545%:${LAYER_PORT}545%g;
s%:8546%:${LAYER_PORT}546%g;
s%:6065%:${LAYER_PORT}065%g" $HOME/.layer/config/app.toml

# Configure P2P and ports
sed -i.bak -e "s%:26658%:${LAYER_PORT}658%g;
s%:26657%:${LAYER_PORT}657%g;
s%:6060%:${LAYER_PORT}060%g;
s%:26656%:${LAYER_PORT}656%g;
s%^external_address = \"\"%external_address = \"$(wget -qO- eth0.me):${LAYER_PORT}656\"%;
s%:26660%:${LAYER_PORT}660%g" $HOME/.layer/config/config.toml

# Set up seeds and peers
printGreen "10. Setting up peers and seeds..." && sleep 1
SEEDS="327fb4151de9f78f29ff10714085e347a4e3c836@rpc.tellor.nodestake.org:666"
PEERS="3037a8c239cdcdcf7fbc0ed050a11ecdc0397374@91.99.194.56:26656,17355981bc61dc3c4169158e3d73f22099a5f9c0@152.53.254.219:41767,5ef1ed1fec8700bf9ee16625db2718997ceb499d@157.180.52.245:41656,23a9da592ee6688eac45c82a256ef302a661469b@195.3.223.78:51656,95e55a6cfb850db8c23e969ddd461eac28b98702@3.91.103.4:26656,7fd4d34f3b19c41218027d3b91c90d073ab2ba66@54.221.149.61:26656,2737f23b2223ab1673ce682afdf50d34633f5f7c@69.250.123.126:26656,9358c72aa8be31ce151ef591e6ecf08d25812993@18.143.181.83:26656,2904aa32501548e127d3198c8f5181fb4d67bbe6@18.116.23.104:26656,2b8af463a1f0e84aec6e4dbf3126edf3225df85e@13.52.231.70:26656,f2644778a8a2ca3b55ec65f1b7799d32d4a7098e@54.149.160.93:26656,5a9db46eceb055c9238833aa54e15a2a32a09c9a@54.67.36.145:26656"
sed -i -e "/^\[p2p\]/,/^\[/{s/^[[:space:]]*seeds *=.*/seeds = \"$SEEDS\"/}" \
       -e "/^\[p2p\]/,/^\[/{s/^[[:space:]]*persistent_peers *=.*/persistent_peers = \"$PEERS\"/}" \
       $HOME/.layer/config/config.toml

# Pruning Settings
sed -i -e "s/^pruning *=.*/pruning = \"custom\"/" $HOME/.layer/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"100\"/" $HOME/.layer/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"19\"/" $HOME/.layer/config/app.toml

# Download the snapshot
# printGreen "12. Downloading snapshot and starting node..." && sleep 1





# Start the node
printGreen "13. Starting the node..."
sudo systemctl restart layerd

# Check node status
printGreen "14. Checking node status..."
sudo journalctl -u layerd -f -o cat

# Verify if the node is running
if systemctl is-active --quiet layerd; then
  echo "The node is running successfully! Logs can be found at /var/log/layer_node_install.log"
else
  echo "The node failed to start. Logs can be found at /var/log/layer_node_install.log"
fi
