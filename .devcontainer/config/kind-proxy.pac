// Route only what lives on the `kind` Docker network through the SOCKS5 proxy
// (`mise run sandbox:socks-proxy:start`). *.127.0.0.1.nip.io stays DIRECT: it targets the
// ingress ports already published on the host, and 127.0.0.1 would be the proxy itself.
function FindProxyForURL(url, host) {
  var proxy = "SOCKS5 127.0.0.1:1080";
  // kind network (LoadBalancer IPs from cloud-provider-kind, containers): Docker picks it in 172.16.0.0/12
  function isKindIp(ip) { return isInNet(ip, "172.16.0.0", "255.240.0.0"); }

  // Docker container names (kind-registry, kubernetes-stack-control-plane, ...)
  if (isPlainHostName(host) && host !== "localhost") return proxy;
  if (/^\d+\.\d+\.\d+\.\d+$/.test(host) && isKindIp(host)) return proxy;
  // nip.io names embedding a kind IP (app.172.19.0.5.nip.io, app-172-19-0-5.nip.io): the host can't
  // route them, the proxy resolves them remotely
  var nip = host.match(/(?:^|[.-])(\d+)[.-](\d+)[.-](\d+)[.-](\d+)\.nip\.io$/);
  if (nip && isKindIp(nip.slice(1, 5).join("."))) return proxy;
  return "DIRECT";
}
