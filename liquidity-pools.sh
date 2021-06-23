# Useful commands for inspecting ~/Desktop/Crypto/liquidity-pools.txt

# Sum of total initial position values and fees
grep -A 1 Initial | grep --color=never -Eo "[0-9]+\.[0-9]+" | paste -sd+ - | bc
