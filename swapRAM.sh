# Configure and enable swap file
SWAP_SIZE=12G
SWAP_FILE=/swapfile
echo "🛠 Setting up swap file ($SWAP_SIZE)..."
sudo fallocate -l $SWAP_SIZE $SWAP_FILE || sudo dd if=/dev/zero of=$SWAP_FILE bs=1M count=12288
sudo chmod 600 $SWAP_FILE
sudo mkswap $SWAP_FILE
sudo swapon $SWAP_FILE

# Persist swap configuration
if ! grep -q "$SWAP_FILE" /etc/fstab; then
    echo "$SWAP_FILE none swap sw 0 0" | sudo tee -a /etc/fstab
fi

echo 'vm.swappiness=10' | sudo tee /etc/sysctl.d/99-swap.conf
sudo sysctl -p /etc/sysctl.d/99-swap.conf

echo "✅ Installation complete, run 'screen -S nexus' to start"
echo "📊 Swap setup completed. Checking status..."
free -h