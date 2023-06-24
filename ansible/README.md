# SSH opts

Connect over a SOCKS5 proxy.
```yaml
ansible_ssh_common_args: -o ProxyCommand='nc -X 5 -x 127.0.0.1:1080 %h %p'
```
