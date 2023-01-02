# 8-bit responder

This is my curriculum project of MCS-51 Microcontroller.
code has been verified.

---

## Function of this item

There are 8 keys that controlled by our players, and 2 keys controlled by our host.

At the beginning, the host should set a specific time by using *KEY_TIME_SET* , and then, starting counting when the host  press *KEY_HOST* .

1. Time set
2. Wait for starting
3. Count down and wait for answer
4. Two options
   1. Time out, beep half second & automatical reset
   2. Or someone answered in time, then waiting for manual reset
