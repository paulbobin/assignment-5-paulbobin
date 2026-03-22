#!/bin/bash
# Local debug script for aesdsocket.c logic

# 1. Clean and Build locally
echo "--- Step 1: Building locally ---"
rm -f aesdsocket
gcc -Wall -Werror aesdsocket.c -o aesdsocket
if [ $? -ne 0 ]; then echo "Compilation failed"; exit 1; fi

# 2. Cleanup old data
rm -f /var/tmp/aesdsocketdata
killall -q aesdsocket || true

# 3. Start server in background (NOT as a daemon first, to see logs)
echo "--- Step 2: Starting server ---"
./aesdsocket &
SERVER_PID=$!
sleep 1

# 4. Independent Test
echo "--- Step 3: Sending Test Data ---"
TEST_STR="debug_test_123"
echo "Sending: $TEST_STR"
# We use -N to ensure nc closes the socket after sending
echo "$TEST_STR" | nc localhost 9000 -w 1 > received_data.txt

# 5. Diagnostic Output
echo "--- Step 4: Results ---"
if [ -f /var/tmp/aesdsocketdata ]; then
    echo "✅ File /var/tmp/aesdsocketdata was created."
    echo "Actual file content on disk:"
    cat /var/tmp/aesdsocketdata
else
    echo "❌ ERROR: /var/tmp/aesdsocketdata was NOT created!"
fi

echo -e "\nData received back from socket:"
cat received_data.txt

# 6. Cleanup
kill $SERVER_PID
rm received_data.txt
