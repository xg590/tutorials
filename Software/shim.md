# Fuck Microsoft for "Linux Would NOT Boot"

* Solution

```sh
apt install grub-efi-amd64-signed
```

## **Why shim suddenly becomes a problem**

A Linux system using Secure Boot relies on the following chain:

**Firmware → Microsoft UEFI CA → shim → GRUB/kernel**

“shim” is signed by Microsoft so that UEFI firmware will trust it.

When shim “becomes a problem,” it is usually because of one of these:

### **1. A new UEFI update revoked older shim certificates**

This is the *most common cause*.
Vendors sometimes push firmware updates that include Microsoft’s updated Secure Boot DBX (revocation list).
If that update lists your shim as *revoked*, your firmware will refuse to boot it.

This is not a bug — it’s a security response to vulnerabilities (e.g., BootHole, GRUB bugs, or vulnerable shim builds).

The result:
**Your existing Linux bootloader becomes untrusted → machine stops booting Linux**.

