package com.example.my_vpn_plugin.core;

import java.net.InetSocketAddress;
import java.nio.channels.Selector;
import java.nio.channels.SocketChannel;

import com.example.my_vpn_plugin.tunnel.Config;
import com.example.my_vpn_plugin.tunnel.RawTunnel;
import com.example.my_vpn_plugin.tunnel.Tunnel;
import com.example.my_vpn_plugin.tunnel.httpconnect.HttpConnectConfig;
import com.example.my_vpn_plugin.tunnel.httpconnect.HttpConnectTunnel;

public class TunnelFactory {

    public static Tunnel wrap(SocketChannel channel, Selector selector) {
        return new RawTunnel(channel, selector);
    }

    public static Tunnel createTunnelByConfig(InetSocketAddress destAddress, Selector selector) throws Exception {
        if (destAddress.isUnresolved()) {
            Config config = ProxyConfig.Instance.getDefaultTunnelConfig(destAddress);
            if (config instanceof HttpConnectConfig) {
                return new HttpConnectTunnel((HttpConnectConfig) config, selector);
            }
            throw new Exception("The config is unknow.");
        } else {
            return new RawTunnel(destAddress, selector);
        }
    }

}
