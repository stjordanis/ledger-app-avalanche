
. tests/lib.sh

# Path m/44'/9000'/1'/1
# 8000002c
# 80002328
# 80000001
# 80000001

@test "Ledger app produces a public key upon request" {
  run apdu_with_clicks "8003000011048000002c800023288000000080000000" "$ACCEPT_CLICKS"
  [ "$status" -eq 0 ]
  diff tests/provide_public_key_apdu_0_0.txt <(echo "$output")
}

@test "Ledger app produces a different public key upon request" {
  run apdu_with_clicks "8003000011048000002c800023288000000180000001" "$ACCEPT_CLICKS"
  [ "$status" -eq 0 ]
  diff tests/provide_public_key_apdu_1_1.txt <(echo "$output")
}

@test "Ledger app produces expected top-level public key" {
  run apdu_with_clicks "8003000009028000002c80002328" "$ACCEPT_CLICKS"
  [ "$status" -eq 0 ]
  diff tests/provide_public_key_apdu_root.txt <(echo "$output")
}

@test "Ledger app prompts with a mainnet key by default" {
  run apdu_with_clicks "8003000011048000002c800023288000000180000001" "$ACCEPT_CLICKS"
  promptsCheck 2 tests/mainnet-provide-pubkey-prompts.txt
  [ "$status" -eq 0 ]
  diff tests/provide_public_key_apdu_1_1.txt <(echo "$output")
}

#@test "Ledger app prompts with a testnet key when testnet addresses are enabled" {
#  clicks "lLlLlLlLrRrRrlRLrlRLrRrRrlRLlLlLlL"
#  sleep 1
#  run apdu_with_clicks "8003000011048000002c800023288000000180000001" "rR"
#  promptsCheck 2 tests/testnet-provide-pubkey-prompts.txt
#  [ "$status" -eq 0 ]
#  clicks "lLlLlLlLrRrRrlRLrlRLrRrRrlRLlLlLlL"
#  diff tests/provide_public_key_apdu_1_1.txt <(echo "$output")
#}

@test "Ledger app produces an extended public key upon request" {
  run apdu_with_clicks "8004000011048000002c800023288000000000000000" "rRrRrRrRrR$ACCEPT_CLICKS"
  promptsCheck 3 tests/provide_ext_public_key_prompts.txt
  [ "$status" -eq 0 ]
  diff tests/provide_ext_public_key_apdu_0_0.txt <(echo "$output")
}
