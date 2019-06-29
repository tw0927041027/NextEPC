# Use OpenStack Vim

> 確認各項環境資源(Network,Image,Flavor...)

### Register VIM
```sh
openstack vim register --config-file vim_config.yaml --is-default openstack-vim
```

### OnBoarded VNFD
```sh
openstack vnf descriptor create --vnfd-file free5gc-amf-vnfd.yaml free5gc-amf-vnfd
openstack vnf descriptor create --vnfd-file free5gc-smf-vnfd.yaml free5gc-smf-vnfd
openstack vnf descriptor create --vnfd-file free5gc-hss-vnfd.yaml free5gc-hss-vnfd
openstack vnf descriptor create --vnfd-file free5gc-pcrf-vnfd.yaml free5gc-pcrf-vnfd
openstack vnf descriptor create --vnfd-file free5gc-upf-vnfd.yaml free5gc-upf-vnfd
openstack vnf descriptor create --vnfd-file free5gc-webui-vnfd.yaml mongodb-vnfd
openstack vnf descriptor create --vnfd-file mongodb.vnfd.yaml free5gc-webui-vnfd
```

### OnBoarded NSD
```sh
openstack ns descriptor create --nsd-file free5gc-nsd.yaml free5gc-nsd
```

### Instance NS
```sh
openstack ns create --nsd-name free5gc-nsd free5gc-ns
```
