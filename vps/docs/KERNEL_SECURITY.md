# Kernel Security Parameters

This document explains the kernel security parameters used in our system setup role.

## Overview

These parameters are based on industry-standard security hardening guidelines from:
- CIS (Center for Internet Security) Benchmarks
- NIST (National Institute of Standards and Technology) SP 800-123
- DISA STIG (Defense Information Systems Agency Security Technical Implementation Guides)
- Linux kernel security best practices

## Parameter Explanations

### Network Forwarding

```yaml
- { name: "net.ipv4.ip_forward", value: "1" }
```
**Purpose**: Enables IP forwarding, allowing packets to be forwarded between network interfaces.  
**Default**: 0 (disabled)  
**Our Setting**: 1 (enabled)  
**Reason**: Required for Docker to function properly. Docker needs to forward packets between container networks and the host network.  
**Source**: [Docker Documentation](https://docs.docker.com/network/), CIS Docker Benchmark

### ICMP Redirect Controls

```yaml
- { name: "net.ipv4.conf.all.send_redirects", value: "0" }
- { name: "net.ipv4.conf.default.send_redirects", value: "0" }
```
**Purpose**: Controls whether the system sends ICMP redirect messages.  
**Default**: 1 (enabled)  
**Our Setting**: 0 (disabled)  
**Reason**: Prevents the system from sending ICMP redirect messages, which could be used in routing-based attacks.  
**Source**: CIS Benchmark 3.2.1, NIST SP 800-123

### ICMP Redirect Acceptance

```yaml
- { name: "net.ipv4.conf.all.accept_redirects", value: "0" }
- { name: "net.ipv4.conf.default.accept_redirects", value: "0" }
```
**Purpose**: Controls whether the system accepts ICMP redirect messages.  
**Default**: 1 (enabled)  
**Our Setting**: 0 (disabled)  
**Reason**: Prevents the system from accepting ICMP redirect messages, which could be used to alter routing tables maliciously.  
**Source**: CIS Benchmark 3.2.2, NIST SP 800-123

### Secure ICMP Redirects

```yaml
- { name: "net.ipv4.conf.all.secure_redirects", value: "0" }
- { name: "net.ipv4.conf.default.secure_redirects", value: "0" }
```
**Purpose**: Controls whether the system accepts "secure" ICMP redirect messages (from gateways listed in the default gateway list).  
**Default**: 1 (enabled)  
**Our Setting**: 0 (disabled)  
**Reason**: Even "secure" redirects can potentially be exploited, so we disable them for maximum security.  
**Source**: CIS Benchmark 3.2.3, DISA STIG

### Broadcast Echo Protection

```yaml
- { name: "net.ipv4.icmp_echo_ignore_broadcasts", value: "1" }
```
**Purpose**: Controls whether the system responds to broadcast ICMP echo requests (pings).  
**Default**: 1 (enabled in modern kernels)  
**Our Setting**: 1 (enabled)  
**Reason**: Prevents the system from being used in "Smurf" amplification DDoS attacks.  
**Source**: CIS Benchmark 3.2.5, NIST SP 800-123

### Bogus Error Response Protection

```yaml
- { name: "net.ipv4.icmp_ignore_bogus_error_responses", value: "1" }
```
**Purpose**: Controls whether the kernel logs bogus error responses.  
**Default**: 1 (enabled in modern kernels)  
**Our Setting**: 1 (enabled)  
**Reason**: Reduces log spam from malformed packets and potential DoS attacks.  
**Source**: CIS Benchmark 3.2.6

### Martian Packet Logging

```yaml
- { name: "net.ipv4.conf.all.log_martians", value: "1" }
- { name: "net.ipv4.conf.default.log_martians", value: "1" }
```
**Purpose**: Controls whether the system logs packets with impossible source addresses ("martian" packets).  
**Default**: 0 (disabled)  
**Our Setting**: 1 (enabled)  
**Reason**: Helps detect network scanning and spoofing attempts.  
**Source**: CIS Benchmark 3.2.4, DISA STIG

### Kernel Address Display Restriction

```yaml
- { name: "kernel.dmesg_restrict", value: "1" }
```
**Purpose**: Controls whether unprivileged users can view kernel logs via dmesg.  
**Default**: 0 (disabled)  
**Our Setting**: 1 (enabled)  
**Reason**: Prevents unprivileged users from accessing potentially sensitive kernel information.  
**Source**: CIS Benchmark 1.5.1, DISA STIG

### Kernel Pointer Restriction

```yaml
- { name: "kernel.kptr_restrict", value: "2" }
```
**Purpose**: Controls exposure of kernel address information via /proc and other interfaces.  
**Default**: 0 (disabled)  
**Our Setting**: 2 (maximum restriction)  
**Reason**: Prevents kernel address leaks that could aid in kernel exploitation.  
**Source**: CIS Benchmark 1.5.2, NIST SP 800-123

## Additional Resources

- [CIS Benchmarks](https://www.cisecurity.org/cis-benchmarks/)
- [NIST SP 800-123](https://csrc.nist.gov/publications/detail/sp/800-123/final)
- [Linux Kernel Documentation](https://www.kernel.org/doc/Documentation/sysctl/)
- [Docker Security](https://docs.docker.com/engine/security/)