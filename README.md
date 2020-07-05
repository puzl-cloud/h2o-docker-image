H2O is a fully open source, distributed in-memory machine learning platform with linear scalability. Used by puzl.ee Kubernetes cloud provider.

#### Build:

```
docker build \
    --build-arg H2O_VERSION=3.30.0.1 \
    -t puzlcloud/h2o:3.30.0.1 .
```
