I tried to reproduce this on RDNA2 with the hardware cursor and couldn't: cursor ioctls stay fast and no events are dropped.

**Setup:** RX 6650 XT (Navi 23), kernel 7.2.9 (CachyOS), XLibre 1.25.2 built from source, **modesetting** DDX, TearFree on, atomic modesetting off (legacy cursor ioctls), 2x 1920x1080. Logitech G305 at 1000 Hz, libinput default (adaptive) accel.

**Method:** traced the server's DRM ioctls while moving the mouse fast for the whole trace:
```
sudo timeout 10 strace -tt -f -T -e trace=ioctl -p $(pgrep -x Xorg || pgrep -x X) -o cursor.strace
```

| `DRM_IOCTL_MODE_CURSOR` | desktop, both monitors, 10 s | fullscreen vkcube, one monitor, 15 s |
|---|---|---|
| calls | 8707 | 12508 |
| mean | 0.051 ms | 0.058 ms |
| p99 | 0.081 ms | 0.089 ms |
| max | 0.190 ms | 0.201 ms |

All cursor moves happen on the input thread. No `SYN_DROPPED` in `Xorg.0.log` during either run.

In one other run, three cursor ioctls on the input thread took 15–17 ms, right next to a `DRM_IOCTL_MODE_CURSOR2` (cursor image change) on the main thread that took 11.8 ms. That run had no drops, and I couldn't reproduce the stalls afterwards.

VRR: I couldn't get VRR to actually engage here (no `VRR_ENABLED` property write showed up in the trace even with a fullscreen Vulkan window), so I can't say anything about the VRR-on case.

Since `SWCursor` makes the drops go away for you (and for Xcv1007 in #1723), the hardware cursor path looks like the suspect, but on my hardware it's fast. Could you run the same strace while reproducing the drops and post the cursor timings? This prints them:
```
grep DRM_IOCTL_MODE_CURSOR cursor.strace | grep -oE '<[0-9.]+>$' | tr -d '<>' | sort -n | awk '{a[NR]=$1;s+=$1} END{printf "n=%d mean=%.3fms p99=%.3fms max=%.3fms\n",NR,s/NR*1000,a[int(NR*.99)]*1000,a[NR]*1000}'
```
If those come out in the milliseconds on your 4K setup, that would confirm slow hardware cursor updates on the input thread as the cause.
