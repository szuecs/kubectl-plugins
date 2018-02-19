## Skipper kubectl plugin

This kubectl plugin is made to control
[skipper ingress](https://zalando.github.io/skipper/kubernetes/ingress-usage)
and use it's features easily.

## Install

Just copy the plugin to your `~/.kube/plugins` folder.

    % git clone git@github.com:szuecs/kubectl-plugins.git
    % cd kubectl-plugins
    % ./install.sh
    % kubectl plugin skipper
    Usage: kubectl plugin skipper <subcommand> <args>
    subcommands:
        traffic <ingress> <svc-old> <svc-new> <percentage-new>

### Traffic switching - blue/green deployment

You need to have one Ingress yaml with two services as backend.

    % cat ingress.yaml
    apiVersion: extensions/v1beta1
    kind: Ingress
    metadata:
      name: sszuecs-demo
      namespace: default
    spec:
      rules:
      - host: sszuecs-demo.example.com
        http:
          paths:
          - backend:
              serviceName: sszuecs-demo-v1
              servicePort: 80
          - backend:
              serviceName: sszuecs-demo-v2
              servicePort: 80

 Both versions will get 50% traffic each:

    % curl https://sszuecs-demo.example.com
    Hello Blue!
    % curl https://sszuecs-demo.example.com
    Hello Green
    % curl https://sszuecs-demo.example.com
    Hello Green
    % curl https://sszuecs-demo.example.com
    Hello Green
    % curl https://sszuecs-demo.example.com
    Hello Green
    % curl https://sszuecs-demo.example.com
    Hello Blue!
    % curl https://sszuecs-demo.example.com
    Hello Blue!
    % curl https://sszuecs-demo.example.com
    Hello Blue!
    % curl https://sszuecs-demo.example.com
    Hello Green

In order to show blue-green traffic switching we initially set 0 to the new service sszuecs-demo-v2.

    % kubectl plugin skipper traffic sszuecs-demo sszuecs-demo-v1 sszuecs-demo-v2 0

0% traffic goes to the new Kubernetes service "sszuecs-demo-v2" and 100% to "sszuecs-demo-v1":

    % curl https://sszuecs-demo.example.com
    Hello Blue!
    % curl https://sszuecs-demo.example.com
    Hello Blue!
    % curl https://sszuecs-demo.example.com
    Hello Blue!
    % curl https://sszuecs-demo.example.com
    Hello Blue!
    % curl https://sszuecs-demo.example.com
    Hello Blue!

60% traffic to the new Kubernetes service "sszuecs-demo-v2":

    % kubectl plugin skipper traffic sszuecs-demo sszuecs-demo-v1 sszuecs-demo-v2 60
    ingress "sszuecs-demo patched
    % curl https://sszuecs-demo.teapot.zalan.do
    Hello Green
    % curl https://sszuecs-demo.teapot.zalan.do
    Hello Green
    % curl https://sszuecs-demo.teapot.zalan.do
    Hello Blue!
    % curl https://sszuecs-demo.teapot.zalan.do
    Hello Blue!
    % curl https://sszuecs-demo.teapot.zalan.do
    Hello Green
    % curl https://sszuecs-demo.teapot.zalan.do
    Hello Green
    % curl https://sszuecs-demo.teapot.zalan.do
    Hello Blue!
    % curl https://sszuecs-demo.teapot.zalan.do
    Hello Green
    % curl https://sszuecs-demo.teapot.zalan.do
    Hello Green
    % curl https://sszuecs-demo.teapot.zalan.do
    Hello Blue!

100% traffic to the new Kubernetes service "sszuecs-demo-v2":

    % kubectl plugin skipper traffic sszuecs-demo sszuecs-demo-v1 sszuecs-demo-v2 100
    ingress "sszuecs-demo patched
    % curl https://sszuecs-demo.example.com
    Hello Green
    % curl https://sszuecs-demo.example.com
    Hello Green
    % curl https://sszuecs-demo.example.com
    Hello Green
    % curl https://sszuecs-demo.example.com
    Hello Green
    % curl https://sszuecs-demo.example.com
    Hello Green
    % curl https://sszuecs-demo.example.com
    Hello Green
