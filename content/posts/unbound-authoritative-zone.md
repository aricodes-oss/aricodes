+++
title = "Using Unbound as an Authoritative Nameserver"
date = "2025-02-20T16:09:13-08:00"
#dateFormat = "2006-01-02" # This value can be configured for per-post date formatting
author = "Aria"
cover = "https://nlnetlabs.nl/static/logos/Unbound/Unbound_FC_Shaded_cropped.svg"
tags = ["unbound", "dns", "pihole", "raspberry pi"]
keywords = ["unbound", "dns", "pihole", "raspberry pi", "raspberry pi 4"]
description = "Unbound is commonly paired with [Pi-hole](https://pi-hole.net/) for local DNS resolution. But what if we want our own private zone that's only available on the local network? This post explores and documents just how to do that."
showFullContent = false
readingTime = true
hideComments = false
draft = false
+++

# TL;DR
(our example zone is going to be `ari.lab`, replace that with your domain)

Create `/etc/unbound/unbound.conf.d/zones.conf` with the following content:
{{< code language="yaml" title="/etc/unbound/unbound.conf.d/zones.conf">}}auth-zone:
  name: ari.lab
  zonefile: /etc/unbound/zones/ari.zone
{{< /code >}}

Then create `/etc/unbound/zones/ari.zone` with the following content:
{{< code language="zonefile" title="/etc/unbound/zones/ari.zone" >}}$TTL    3600 ; 1 Hour
$ORIGIN ari.lab.
ari.lab. IN SOA pihole.lan. ari.aricodes.net. (
                              20250211 ; serial
                              10800 ; refresh
                              3600 ; retry
                              604800 ; expire
                              300 ; minimum
                             )
@  1D  IN  NS pihole.lan.

; Your DNS records here
@ 600 IN A 192.168.1.200
@ 600 IN A 192.168.1.201
@ 600 IN A 192.168.1.202
@ 600 IN A 192.168.1.203
@ 600 IN A 192.168.1.204
@ 600 IN A 192.168.1.205
@ 600 IN A 192.168.1.206
@ 600 IN A 192.168.1.207
* IN CNAME ari.lab.
{{< /code >}}

Run `unbound-checkconf` to make sure that your configuration is valid, and then `sudo systemctl daemon-reload && sudo systemctl restart unbound` to have your changes take effect!

# Introduction

We've talked about [pi-hole](https://pi-hole.net/) several times before and it certainly needs no introduction. While it's a fantastic tool for network-wide adblocking, the project (intentionally) falls short as a full DNS server as it simply forwards queries to an upstream provider. This is suboptimal in two key regards: privacy, and configuration; and the intersection of these issues is what we're focusing on today.

## Why are we doing this?

For my home lab setup I want to be able to have a private DNS zone that's internal to my network so I can mint SSL certs and route traffic by subdomain through the same reverse proxy I have serving external traffic. Ideally I'd also like to use a fictitious top-level domain (TLD) because it opens up more options for cute puns.

Technically I do _already_ have a private internal DNS zone at `.lan`/`.local` that is managed by my router's DHCP server, but since it only serves traffic for that zone (and I don't like having these changes bring down my network temporarily) it seemed more appropriate to have my pi-hole be responsible for this zone.

## Tackling problems

First off, let's start with privacy. There is an excellent [high-level overview on the pi-hole setup guide for Unbound](https://docs.pi-hole.net/guides/dns/unbound/) that goes over this, but the short version is "we can either trust Cloudflare not to lie to us/monitor our queries OR we can resolve every query from the root nameservers ourselves." Resolving the queries ourselves is slower because we don't get to benefit from a regional cache network, but it also nearly guarantees that our upstream response hasn't been poisoned.

Configuration is our other sore spot. Pi-hole will technically allow you to create local DNS records through its admin interface, but that is limited to single-target A records and a restricted subset of CNAME records, which isn't very helpful for our purposes - we need an [SOA (start of authority) record](https://en.wikipedia.org/wiki/SOA_record) to make ourselves authoritative for a zone. Fortunately for us, Unbound actually supports loading a DNS zone from a file! Less fortunately, this seems to be a feature that very few people use, and as such it's hard to find good documentation on how to use it.

## Finding Resources

Initially I came across [this blog post](https://stafwag.github.io/blog/blog/2020/03/22/use-unbound-as-dns-over-tls-and-authoritative-dns-server/), which told me that I was doing was at least _possible_, but was not ultimately very helpful. The post assumes that you're going to be using their docker image - which was last updated 4 years ago and doesn't help me on baremetal - and provides a couple scripts to generate configuration files in there that need tweaking to run outside of a container. Additionally, the DNS zonefiles in that post are malformed and will fail `unbound-checkconf`. That gives us somewhere to start at least!

# Implementation

## Configuring Unbound

Beginning with dissecting the config generation scripts, they basically take a set of zone files and produce accompanying Unbound configuration files. When we unwind the logic we get something like the following file:
{{< code language="yaml" title="/etc/unbound/unbound.conf.d/zones.conf">}}auth-zone:
  name: ari.lab
  zonefile: /etc/unbound/zones/ari.zone
{{< /code >}}

Where `ari.lab` is the domain we're building the zone for, and `zonefile` is the absolute path of the DNS zone file. *Make sure you swap these example values out with your own.*

If defiance of the existence of multiple shell scripts in that project, this is actually the end of the unbound configuration for our usecase! 🎉

## Writing Our Zone File

Fortunately, it is much easier to find information on writing a DNS zone file as it's the subject of [multiple RFCs](https://en.wikipedia.org/wiki/Zone_file). The actual resource I used for writing my zone was [this excellent blog post](https://andres.jaimes.net/90/how-to-create-a-dns-zone-file/).

In the previous step we configured unbound to look for this file at `/etc/unbound/zones/ari.zone`. Here's the contents of that file in my setup:
{{< code language="zonefile" title="/etc/unbound/zones/ari.zone" >}}$TTL    3600 ; 1 Hour
$ORIGIN ari.lab.
ari.lab. IN SOA pihole.lan. ari.aricodes.net. (
                              20250211 ; serial
                              10800 ; refresh
                              3600 ; retry
                              604800 ; expire
                              300 ; minimum
                             )
@  1D  IN  NS pihole.lan.

; Your DNS records here
@ 600 IN A 192.168.1.200
@ 600 IN A 192.168.1.201
@ 600 IN A 192.168.1.202
@ 600 IN A 192.168.1.203
@ 600 IN A 192.168.1.204
@ 600 IN A 192.168.1.205
@ 600 IN A 192.168.1.206
@ 600 IN A 192.168.1.207
* IN CNAME ari.lab.
{{< /code >}}

That's a dense block of text, so let's break it down line by line.

1. `$TTL    3600 ; 1 Hour` - Sets the default record TTL to 1 hour
2. `$ORIGIN ari.lab.` - Sets the basename unqualified record names have appended. For instance, if your record name is `www` and your `$ORIGIN` is `ari.lab.` that record's fully qualified address would be `www.ari.lab.`
3. Our SOA record is our largest single block: {{< code language="zonefile" >}}ari.lab. IN SOA pihole.lan. ari.aricodes.net. (
                              20250211 ; serial
                              10800 ; refresh
                              3600 ; retry
                              604800 ; expire
                              300 ; minimum
                             ){{< /code >}}

- `ari.lab.` is the name of the record, also our origin
- `IN SOA` means "this is an SOA record"
- `pihole.lan.` is the authoritative name server for this zone.
- `ari.aricodes.net` is the email address of the administrator of this zone, with the `@` substituted by a `.`
- `20250211 ; serial` is the serial number of the file. This should be incremented every time the file is modified, common practice being to set it to the current date.
- `10800 ; refresh` is how often the name server should check with the primary nameserver for fresh zone data
- `3600 ; retry` is how long the name server should wait if it fails to fetch fresh zone data
- `604800 ; expire` is how long the name server should serve cached zone data if fetching fresh data fails
- `300 ; minimum` is the minimum TTL of the SOA record
4. `@  1D  IN  NS pihole.lan.` - This is the NS record for our domain, which is required for our server to respond authoritatively for this zone

Then, finally, we can start adding whatever records to this zone we want. I'll go over two here:

5. `@ 600 IN A 192.168.1.200` - Creates an `A` record for `ari.lab.` pointing to `192.168.1.200`
6. `* IN CNAME ari.lab.` - Creates a CNAME record for `*.ari.lab.`, pointing to `ari.lab.`

# Done!

We've now got a private DNS zone that only our Pi-hole will respond to! Hopefully this has been illuminating.

If you have any questions, are getting errors, or are just lost following this - feel free to reach out and [email me](/contact) at any time!
