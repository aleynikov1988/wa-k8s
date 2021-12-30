# wa-k8s

### Calico seting up CIDR
```
POD_CIDR="10.100.0.0/16" \
sed -i -e "s?192.168.0.0/16?$POD_CIDR?g" calico.yaml
```